;;; config/habit-tracker.el -*- lexical-binding: t; -*-

(defface habit-tracker-done   '((t :foreground "#a6e3a1")) "done")
(defface habit-tracker-missed '((t :foreground "#585b70")) "missed.")
(defface habit-tracker-blank  '((t :foreground "#313244")) "nil")

(setq habit-trackers
      '((:file "~/org/agenda/logs/learn.org" :start "2026-05-22" :title "learning tracker")
        (:file "~/org/agenda/logs/media.org" :start "2026-05-22" :title "media tracker")))

(defun habit-tracker--buf-name (cfg)
  (format "*%s*" (plist-get cfg :title)))

(defun habit-tracker--parse-done-dates (file)
  (let (dates)
    (with-temp-buffer
      (insert-file-contents (expand-file-name file))
      (goto-char (point-min))
      (while (re-search-forward
              "^\\*+\\s-+DONE.*<\\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}\\)" nil t)
        (push (match-string 1) dates)))
    (delete-dups dates)))

(defun habit-tracker--to-time (date-str)
  (encode-time 0 0 12
               (string-to-number (substring date-str 8 10))
               (string-to-number (substring date-str 5 7))
               (string-to-number (substring date-str 0 4))))

(defun habit-tracker--fmt (time)
  (format-time-string "%Y-%m-%d" time))

(defun habit-tracker--dow (time)
  (1- (string-to-number (format-time-string "%u" time))))

(defun habit-tracker--render (cfg)
  (let* ((file       (plist-get cfg :file))
         (start-date (plist-get cfg :start))
         (title      (plist-get cfg :title))
         (done-dates (habit-tracker--parse-done-dates file))
         (today-str  (format-time-string "%Y-%m-%d"))
         (start      (habit-tracker--to-time start-date))
         (today      (habit-tracker--to-time today-str))
         (grid-start (time-subtract start (days-to-time (habit-tracker--dow start))))
         (grid-end   (time-add today (days-to-time (- 6 (habit-tracker--dow today)))))
         (weeks '())
         (cur grid-start))

    (while (not (time-less-p grid-end cur))
      (let (week)
        (dotimes (_ 7)
          (let* ((ds (habit-tracker--fmt cur))
                 (st (cond
                      ((string< ds start-date) 'blank)
                      ((time-less-p today cur)  'blank)
                      ((member ds done-dates)   'done)
                      (t                        'missed))))
            (push (cons ds st) week))
          (setq cur (time-add cur (days-to-time 1))))
        (push (nreverse week) weeks)))
    (setq weeks (nreverse weeks))

    (erase-buffer)
    (insert (propertize (format " %s\n" title) 'face '(:weight bold :height 1.2))
            (propertize (format " %s ~ %s\n\n" start-date today-str)
                        'face 'font-lock-comment-face))

    (let* ((ncols (length weeks))
           (row   (make-string (* 2 ncols) ?\s))
           (prev  ""))
      (dotimes (i ncols)
        (let* ((thu (nth 3 (nth i weeks)))
               (mon (format-time-string "%b" (habit-tracker--to-time (car thu)))))
          (unless (equal mon prev)
            (let ((pos (* 2 i)))
              (dotimes (j (min (length mon) (- (length row) pos)))
                (aset row (+ pos j) (aref mon j))))
            (setq prev mon))))
      (insert "     " (propertize row 'face 'font-lock-comment-face) "\n"))

    (let ((days '("Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun")))
      (dotimes (r 7)
        (insert (propertize (format " %s " (nth r days)) 'face 'font-lock-comment-face))
        (dolist (week weeks)
          (let* ((cell (nth r week))
                 (face (pcase (cdr cell)
                         ('done   'habit-tracker-done)
                         ('missed 'habit-tracker-missed)
                         (_       'habit-tracker-blank))))
            (insert (propertize "\u25a0 " 'face face 'help-echo (car cell)))))
        (insert "\n")))

    (let* ((total  (max 1 (1+ (floor (/ (float-time (time-subtract today start)) 86400)))))
           (done-n (length (seq-filter
                            (lambda (d) (and (not (string< d start-date))
                                             (not (string> d today-str))))
                            done-dates)))
           (streak 0)
           (chk    today))
      (while (member (habit-tracker--fmt chk) done-dates)
        (cl-incf streak)
        (setq chk (time-subtract chk (days-to-time 1))))
      (insert "\n"
              (propertize (format " %d/%d days" done-n total) 'face '(:weight bold))
              (propertize (format "  |  streak: %d" streak) 'face 'habit-tracker-done)
              "\n\n"
              (propertize " q close  g refresh" 'face 'font-lock-comment-face)
              "\n"))))

;; Mode

(defvar-local habit-tracker--cfg nil)

(defvar habit-tracker-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "g" #'habit-tracker-refresh-current)
    (define-key map "q" #'quit-window)
    map))

(define-derived-mode habit-tracker-mode special-mode "Habits")

(defun habit-tracker-refresh-current ()
  (interactive)
  (when habit-tracker--cfg
    (let ((inhibit-read-only t))
      (habit-tracker--render habit-tracker--cfg))
    (goto-char (point-min))))

(defun habit-tracker--ensure-buf (cfg)
  (let ((buf (get-buffer-create (habit-tracker--buf-name cfg))))
    (with-current-buffer buf
      (let ((inhibit-read-only t))
        (habit-tracker--render cfg))
      (goto-char (point-min))
      (habit-tracker-mode)
      (setq habit-tracker--cfg cfg))
    buf))

;; Auto show/hide based on visible buffers

(defun habit-tracker--cfg-for-buffer ()
  (when buffer-file-name
    (cl-find-if (lambda (cfg)
                  (string-suffix-p (file-name-nondirectory (plist-get cfg :file))
                                   buffer-file-name))
                habit-trackers)))

(defun habit-tracker--sync (_frame)
  (dolist (cfg habit-trackers)
    (let* ((fname (file-name-nondirectory (plist-get cfg :file)))
           (visible (cl-some (lambda (win)
                               (let ((bf (buffer-file-name (window-buffer win))))
                                 (and bf (string-suffix-p fname bf))))
                             (window-list)))
           (tracker-buf (get-buffer (habit-tracker--buf-name cfg)))
           (tracker-win (and tracker-buf (get-buffer-window tracker-buf t))))
      (cond
       ((and visible (not tracker-win))
        (display-buffer-in-side-window
         (habit-tracker--ensure-buf cfg) '((side . top) (window-height . 13))))
       ((and (not visible) tracker-win)
        (delete-window tracker-win))))))

(defun habit-tracker--on-kill ()
  (when-let ((cfg (habit-tracker--cfg-for-buffer)))
    (when-let ((buf (get-buffer (habit-tracker--buf-name cfg))))
      (when-let ((win (get-buffer-window buf t)))
        (delete-window win))
      (kill-buffer buf))))

(add-hook 'window-buffer-change-functions #'habit-tracker--sync)
(add-hook 'kill-buffer-hook #'habit-tracker--on-kill)

(defun habit-tracker ()
  (interactive)
  (let ((cfg (habit-tracker--cfg-for-buffer)))
    (if cfg
        (habit-tracker--ensure-buf cfg)
      (find-file (expand-file-name (plist-get (car habit-trackers) :file))))))

;;; lisp/org/commands.el -*- lexical-binding: t; -*-

(defun toad/org-open (file)
  "visit FILE in the org workspace."
  (toad/go "org")
  (make-directory (file-name-directory file) t)
  (find-file file))

;; keep dynamic binding valid before org-agenda loads.
(defvar org-agenda-overriding-header)

(defun toad/org-agenda ()
  "visit the task list."
  (interactive)
  (toad/org-open (toad/org-agenda-file)))

(defun toad/org-today ()
  "visit today's log."
  (interactive)
  (toad/org-open (toad/org-daily-file)))

(defun toad/org-today-refresh ()
  "visit today's log and pull the week's tasks under * agenda again.
only that section is replaced, the rest of the file is left alone."
  (interactive)
  (toad/org-today)
  (toad/org-refresh))

(defun toad/org-week ()
  "visit this week's log, rebuilt even if it was already open."
  (interactive)
  (let* ((file (toad/org-weekly-file))
         (open (find-buffer-visiting file)))
    (toad/org-open file)
    ;; a newly opened buffer already ran the refresh hook.
    (when open (toad/org-open-h))))

(defun toad/org-urgent ()
  "list every unfinished [#A] task across the agenda files."
  (interactive)
  (let ((org-agenda-overriding-header "urgent"))
    (org-tags-view nil "PRIORITY=\"A\"/!")))

;; calendar binds these dynamically while drawing.
(defvar displayed-month)
(defvar displayed-year)

(defvar-local toad/org-calendar-keyword nil
  "the tracker keyword the calendar shades by, nil shades by logs.")

(defun toad/org-calendar (shade)
  "show three months, RET or a click on a day opens its log.
SHADE is logs, fading the days without one, or a tracker such as
study: faded without a record, greener the more records that day."
  (interactive
   (list (completing-read "shade by: " (cons "logs" (mapcar #'downcase (toad/org-keywords)))
                          nil t nil nil "logs")))
  (toad/go "org")
  (calendar)
  (with-current-buffer calendar-buffer
    (setq toad/org-calendar-keyword (unless (equal shade "logs") (upcase shade))))
  (calendar-redraw))

(defun toad/org-calendar-file (date)
  "the daily log for a calendar DATE, (month day year)."
  (pcase-let ((`(,month ,day ,year) date))
    (toad/org-daily-file (encode-time (list 0 0 0 day month year nil -1 nil)))))

(defun toad/org-calendar-open (&optional event)
  "open the log of the day at point, or under the mouse EVENT.
a day with no log yet is created from the daily template."
  (interactive (list last-nonmenu-event))
  (when (mouse-event-p event) (mouse-set-point event))
  (let ((file (toad/org-calendar-file (calendar-cursor-to-date t))))
    (calendar-exit)
    (toad/org-open file)))

(defun toad/org-calendar-green (alpha)
  "a background ALPHA of the way from the theme's background to its green."
  (list :background (doom-blend (face-foreground 'success nil t)
                                (face-background 'default nil t) alpha)))

(defun toad/org-calendar-shade (date counts)
  "the face for calendar DATE, nil to leave it plain.
with a keyword the green deepens with the day's records, like github."
  (if toad/org-calendar-keyword
      (let ((day (calendar-absolute-from-gregorian date)))
        (pcase (gethash day counts 0)
          (0 'shadow)
          (1 (toad/org-calendar-green 0.35))
          (2 (toad/org-calendar-green 0.65))
          (_ (toad/org-calendar-green 1.0))))
    (unless (file-exists-p (toad/org-calendar-file date)) 'shadow)))

(defun toad/org-calendar-mark-h ()
  "shade every visible day with `toad/org-calendar-shade'."
  (let ((counts (make-hash-table :test #'eql)))
    ;; read the tracker once per redraw, not once per visible day.
    (when toad/org-calendar-keyword
      (let ((from (calendar-absolute-from-gregorian
                   (list displayed-month 1 displayed-year))))
        (dolist (entry (toad/org-entries toad/org-calendar-keyword
                                       (- from 31) (+ from 62)))
          (cl-incf (gethash (car entry) counts 0)))))
    (save-excursion
      (dolist (offset '(-1 0 1))
        (let ((month displayed-month) (year displayed-year))
          (calendar-increment-month month year offset)
          (dotimes (i (calendar-last-day-of-month month year))
            (let ((date (list month (1+ i) year)))
              (when-let* ((face (toad/org-calendar-shade date counts)))
                (calendar-cursor-to-visible-date date)
                (overlay-put (make-overlay (1- (point)) (1+ (point))) 'face face)))))))))

(defun toad/org-sort-tasks (method)
  "sort the children of the section at point using METHOD."
  (interactive
   (let ((choices '(("DONE last" . ?f) ("Priority" . ?p)
                    ("Alphabetical" . ?a) ("Scheduled date" . ?s)
                    ("Deadline" . ?d))))
     (list (cdr (assoc (completing-read "Sort section: " choices nil t) choices)))))
  (let ((mark-active nil))
    (org-sort-entries nil method
                      (when (eq method ?f)
                        (lambda () (if (org-entry-is-done-p) 1 0)))
                      (when (eq method ?f) #'<))))

(toad/bind-global "M-a" #'toad/org-agenda)
(toad/bind-global "M-t" #'toad/org-today)
(toad/bind-global "M-n" #'org-capture)
(after! org
  (map! :map org-mode-map "M-p" #'org-priority))
(after! calendar
  ;; either hook may run, depending on whether today is visible.
  (add-hook 'calendar-today-visible-hook #'toad/org-calendar-mark-h)
  (add-hook 'calendar-today-invisible-hook #'toad/org-calendar-mark-h)
  (map! :map calendar-mode-map
        :n "RET" #'toad/org-calendar-open
        :n [mouse-1] #'toad/org-calendar-open))

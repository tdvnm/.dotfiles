;;; lisp/org/commands.el -*- lexical-binding: t; -*-

;;; visiting

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

(defun toad/org-urgent ()
  "list every unfinished [#A] task across the agenda files."
  (interactive)
  (let ((org-agenda-overriding-header "urgent"))
    (org-tags-view nil "PRIORITY=\"A\"/!")))

;;; calendar

;; calendar binds these dynamically while drawing.
(defvar displayed-month)
(defvar displayed-year)

(defvar-local toad/org-calendar-tracker nil
  "the tracker the calendar shades by, nil shades by logs.")

;; local to this session: org's date prompts redraw the calendar, which ends it.
(define-minor-mode toad/org-calendar-mode
  "shade the calendar by logs or a tracker, RET opens a day's log.")

(defun toad/org-calendar (shade)
  "show three months, RET or a click on a day opens its log.
SHADE is logs, fading the days without one, or a tracker such as
study: faded without a record, greener the more records that day."
  (interactive
   (list (completing-read "shade by: " (cons "logs" (toad/org-trackers))
                          nil t nil nil "logs")))
  (toad/go "org")
  (calendar)
  (with-current-buffer calendar-buffer
    (setq toad/org-calendar-tracker (unless (equal shade "logs") shade))
    (toad/org-calendar-mode)
    (calendar-redraw)))

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
with a tracker the green deepens with the day's records, like github."
  (if toad/org-calendar-tracker
      (let ((day (calendar-absolute-from-gregorian date)))
        (pcase (gethash day counts 0)
          (0 'shadow)
          (1 (toad/org-calendar-green 0.35))
          (2 (toad/org-calendar-green 0.65))
          (_ (toad/org-calendar-green 1.0))))
    (unless (file-exists-p (toad/org-calendar-file date)) 'shadow)))

(defun toad/org-calendar-mark-h ()
  "shade every visible day with `toad/org-calendar-shade'."
  (when toad/org-calendar-mode
    (let ((counts (make-hash-table :test #'eql)))
      ;; read the tracker once per redraw, not once per visible day.
      (when toad/org-calendar-tracker
        (let ((from (calendar-absolute-from-gregorian
                     (list displayed-month 1 displayed-year))))
          (dolist (entry (toad/org-entries toad/org-calendar-tracker
                                         (- from 31) (+ from 62)))
            (cl-incf (gethash (car entry) counts 0)))))
      (dolist (offset '(-1 0 1))
        (let ((month displayed-month) (year displayed-year))
          (calendar-increment-month month year offset)
          (dotimes (i (calendar-last-day-of-month month year))
            (let ((date (list month (1+ i) year)))
              (when-let* ((face (toad/org-calendar-shade date counts)))
                (calendar-mark-visible-date date face)))))))))

;;; sorting

(defun toad/org-sort-tasks (method)
  "sort the tasks of the top level section at point using METHOD."
  (interactive
   (let ((choices '(("DONE last" . ?f) ("Priority" . ?p)
                    ("Alphabetical" . ?a) ("Scheduled date" . ?s)
                    ("Deadline" . ?d))))
     (list (cdr (assoc (completing-read "Sort section: " choices nil t) choices)))))
  (let ((mark-active nil))
    (org-back-to-heading t)
    (while (org-up-heading-safe))
    (org-sort-entries nil method
                      (when (eq method ?f)
                        (lambda () (if (org-entry-is-done-p) 1 0)))
                      (when (eq method ?f) #'<))))

;;; keys

(toad/bind-global "M-a" #'toad/org-agenda)
(toad/bind-global "M-t" #'toad/org-today)
(toad/bind-global "M-n" #'org-capture)
(after! org
  (map! :map org-mode-map "M-p" #'org-priority))
(after! evil
  (evil-define-minor-mode-key 'normal 'toad/org-calendar-mode
    (kbd "RET") #'toad/org-calendar-open
    [mouse-1] #'toad/org-calendar-open))
;; either hook may run, depending on whether today is visible.
(add-hook 'calendar-today-visible-hook #'toad/org-calendar-mark-h)
(add-hook 'calendar-today-invisible-hook #'toad/org-calendar-mark-h)

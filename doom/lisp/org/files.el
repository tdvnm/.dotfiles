;;; lisp/org/files.el -*- lexical-binding: t; -*-

(setq org-directory (toad/place-root "org"))

;; include course tasks in agenda searches.
(setq org-agenda-files
      (cons (expand-file-name "agenda.org" org-directory)
            (file-expand-wildcards (expand-file-name "*/agenda.org" (toad/place-root "krea")))))

(defun toad/org-file (relative)
  "RELATIVE expanded under `org-directory'."
  (expand-file-name relative org-directory))

(defun toad/org-agenda-file ()
  "the task list every log copies from, also a capture target."
  (toad/org-file "agenda.org"))

(defun toad/org-daily-file (&optional time)
  "the daily log for TIME, today by default, also a capture target."
  (toad/org-file (format-time-string "logbook/daily/%Y-%m-%d.org" time)))

(defun toad/org-weekly-file ()
  "this week's log."
  (toad/org-file (format-time-string "logbook/weekly/%G-W%V.org")))

(defun toad/org-tracker-file (keyword)
  "the tracker that remembers finished KEYWORD activities."
  (toad/org-file (concat "tracker/" (downcase keyword) ".org")))

(defun toad/org-log-kind ()
  "return `daily' or `weekly' for a dated log file, else nil."
  (when (and buffer-file-name (equal (file-name-extension buffer-file-name) "org"))
    (let ((dir (file-name-directory buffer-file-name))
          (name (file-name-base buffer-file-name)))
      (cond ((and (equal dir (toad/org-file "logbook/daily/"))
                  (string-match-p "\\`[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}\\'" name))
             'daily)
            ((and (equal dir (toad/org-file "logbook/weekly/"))
                  (string-match-p "\\`[0-9]\\{4\\}-W[0-9]\\{2\\}\\'" name))
             'weekly)))))

(defun toad/org-log-monday ()
  "absolute day of the monday starting this log's week, or nil outside logs."
  (when-let* ((kind (toad/org-log-kind))
              (name (file-name-base buffer-file-name))
              (monday (lambda (day) (- day (mod (1- day) 7)))))
    (pcase kind
      ('daily (funcall monday (org-time-string-to-absolute name)))
      ;; iso week one contains january 4th.
      ('weekly (+ (funcall monday (org-time-string-to-absolute
                                   (concat (substring name 0 4) "-01-04")))
                  (* 7 (1- (string-to-number (substring name 6)))))))))

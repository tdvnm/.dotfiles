;;; lisp/org/files.el -*- lexical-binding: t; -*-

(require 'cal-iso)

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

(defun toad/org-tracker-file (name)
  "the tracker file for NAME, a section heading such as study or contact."
  (toad/org-file (concat "tracker/" (downcase name) ".org")))

;; one task state everywhere; the section a task sits under picks its tracker.
(after! org
  (setq org-todo-keywords '((sequence "TODO" "|" "DONE"))))

(defun toad/org-log-kind ()
  "return `daily' for a dated log file, else nil."
  (when (and buffer-file-name (equal (file-name-extension buffer-file-name) "org")
             (equal (file-name-directory buffer-file-name) (toad/org-file "logbook/daily/"))
             (string-match-p "\\`[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}\\'"
                             (file-name-base buffer-file-name)))
    'daily))

(defun toad/org-log-monday ()
  "absolute day of the monday starting this log's week, or nil outside a log."
  (when (toad/org-log-kind)
    (pcase-let ((`(,week ,_ ,year)
                 (calendar-iso-from-absolute
                  (org-time-string-to-absolute (file-name-base buffer-file-name)))))
      (calendar-iso-to-absolute (list week 1 year)))))

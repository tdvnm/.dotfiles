;;; lisp/org/done.el -*- lexical-binding: t; -*-
;; org binds these dynamically during a state change.
(defvar org-state)
(defvar org-last-state)

(defun toad/org-record (keyword title)
  "append TITLE to the KEYWORD tracker with today's date.
history is append-only: reopening or undoing DONE does not remove a record."
  (let* ((file (toad/org-tracker-file keyword))
         (visiting (find-buffer-visiting file))
         (modified (and visiting (buffer-modified-p visiting))))
    (make-directory (file-name-directory file) t)
    (with-current-buffer (find-file-noselect file)
      (save-excursion
        (save-restriction
          (widen)
          (goto-char (point-max))
          (unless (bolp) (insert "\n"))
          (insert (format-time-string "* [%Y-%m-%d %a] : ") title "\n")
          (if modified
              (message "Activity recorded; save %s to keep it" (buffer-name))
            (save-buffer)))))))

(defun toad/org-finish-source (title)
  "finish the uniquely named agenda.org task TITLE.
Leave ambiguous matches alone and preserve unrelated unsaved edits."
  (with-current-buffer (find-file-noselect (toad/org-agenda-file))
    (save-excursion
      (save-restriction
        (widen)
        (let ((modified (buffer-modified-p))
              (matches (delq nil (org-map-entries
                                  (lambda ()
                                    (when (and (org-get-todo-state)
                                               (equal title (org-get-heading t t t t)))
                                      (point)))
                                  nil 'file 'archive 'comment))))
          (cond
           ((cdr matches)
            (message "More than one task named %s; agenda.org left unchanged" title))
           (matches
            (goto-char (car matches))
            (unless (org-entry-is-done-p)
              (org-todo "DONE")
              (if modified
                  (message "Task completed; save agenda.org to keep it")
                (save-buffer))))))))))

(defun toad/org-done-h ()
  "finishing a daily entry marks its agenda.org source or records the activity.
every keyword but TODO is an activity; the weekly is a view, so it records nothing."
  (when-let* (((eq (toad/org-log-kind) 'daily))
              ((equal org-state "DONE"))
              (title (string-trim (org-get-heading t t t t)))
              ((not (string-empty-p title))))
    (cond ((equal org-last-state "TODO")
           (toad/org-finish-source title))
          ((member org-last-state org-not-done-keywords)
           (toad/org-record org-last-state title)))))

(after! org
  (setq org-log-done 'time)
  (add-hook 'org-after-todo-state-change-hook #'toad/org-done-h))

;;; lisp/org/logs.el -*- lexical-binding: t; -*-

(defun toad/org-fill (heading text)
  "replace the body of the top level HEADING with TEXT, if the heading exists."
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (when-let* ((pos (seq-some
                       #'identity
                       (org-map-entries
                        (lambda ()
                          (when (equal (org-get-heading t t t t) heading)
                            (point)))
                        "LEVEL=1" nil))))
        (goto-char pos)
        (let ((end (save-excursion (org-end-of-subtree t t))))
          (forward-line 1)
          (delete-region (point) end)
          (insert text "\n"))))))

(defun toad/org-task-due-p (from to)
  "non-nil when the task at point is scheduled or due between days FROM and TO."
  (seq-some (lambda (key)
              (when-let* ((date (org-entry-get nil key)))
                (<= from (org-time-string-to-absolute date) to)))
            '("SCHEDULED" "DEADLINE")))

(defun toad/org-tasks (from to stars)
  "copy the unfinished agenda.org tasks due between days FROM and TO under STARS."
  (with-current-buffer (find-file-noselect (toad/org-agenda-file))
    (mapconcat
     #'identity
     (org-map-entries
      (lambda ()
        (when (toad/org-task-due-p from to)
          (let ((dates (delq nil (mapcar (lambda (key)
                                           (when-let* ((date (org-entry-get nil key)))
                                             (concat key ": " date)))
                                         '("SCHEDULED" "DEADLINE")))))
            (concat stars " " (org-get-heading nil nil nil t) "\n"
                    (when dates (concat (string-join dates " ") "\n"))))))
      "/!" 'file 'archive 'comment)
     "")))

(defun toad/org-refresh ()
  "pull this week's unfinished agenda.org tasks into this daily's * agenda."
  (interactive)
  (when-let* ((from (toad/org-log-monday)))
    (toad/org-fill "agenda" (toad/org-tasks from (+ from 6) "**"))))

;; a new daily gets this week's tasks once, when it is created.
(defun toad/org-open-h ()
  "seed a new file from its template, and fill a new daily log."
  (when (and buffer-file-name (toad/under-p buffer-file-name org-directory))
    (let ((clean (not (buffer-modified-p)))
          (new (zerop (buffer-size))))
      (when new (toad/org-seed))
      (when (eq (toad/org-log-kind) 'daily)
        (when new
          (toad/org-refresh)
          ;; restore the file's folding after inserting generated text.
          (org-cycle-set-startup-visibility))
        (when clean (save-buffer))))))

(add-hook 'org-mode-hook #'toad/org-open-h)

;;; lisp/org/done.el -*- lexical-binding: t; -*-
;; org binds these dynamically during a state change.
(defvar org-state)
(defvar org-last-state)

;;; trackers

(defun toad/org-record (tracker title)
  "append TITLE to TRACKER with today's date.
history is append-only: reopening or undoing DONE does not remove a record."
  (let* ((file (toad/org-tracker-file tracker))
         (visiting (find-buffer-visiting file))
         (modified (and visiting (buffer-modified-p visiting))))
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

(defun toad/org-entries (tracker from to)
  "(DAY STAMP TITLE) for every TRACKER record dated between days FROM and TO."
  (let ((file (toad/org-tracker-file tracker)))
    (when (file-exists-p file)
      (with-current-buffer (find-file-noselect file)
        (delq nil
              (org-map-entries
               (lambda ()
                 (when-let* ((stamp (org-entry-get nil "TIMESTAMP_IA"))
                             (day (org-time-string-to-absolute stamp))
                             ((<= from day to)))
                   (list day stamp
                         (replace-regexp-in-string "\\`\\[[^]]*\\] : " ""
                                                   (org-get-heading t t t t)))))
               nil 'file))))))

(defun toad/org-trackers ()
  "every tracker name, one per file in tracker/."
  (let ((dir (toad/org-file "tracker/")))
    (when (file-directory-p dir)
      (mapcar #'file-name-base (directory-files dir nil "\\.org\\'")))))

;;; done hook

(defun toad/org-finish-source (title)
  "finish the agenda.org task TITLE, unless the title is ambiguous.
return non-nil when TITLE names exactly one task there."
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
            (message "More than one task named %s; agenda.org left unchanged" title)
            nil)
           (matches
            (goto-char (car matches))
            (unless (org-entry-is-done-p)
              (org-todo "DONE")
              (if modified
                  (message "Task completed; save agenda.org to keep it")
                (save-buffer)))
            t)))))))

(defun toad/org-tracker-above ()
  "the tracker named by the nearest heading above point, or nil."
  (seq-find (lambda (name) (file-exists-p (toad/org-tracker-file name)))
            (reverse (org-get-outline-path))))

;; a daily's copy finishes its agenda.org task, whose own DONE records it.
(defun toad/org-done-h ()
  "record a finished task in the tracker its section is named after."
  (when-let* (((equal org-state "DONE"))
              ((member org-last-state org-not-done-keywords))
              ((toad/under-p buffer-file-name org-directory))
              (title (string-trim (org-get-heading t t t t)))
              ((not (string-empty-p title)))
              ((not (and (eq (toad/org-log-kind) 'daily)
                         (toad/org-finish-source title))))
              (tracker (toad/org-tracker-above)))
    (toad/org-record tracker title)))

(after! org
  (setq org-log-done 'time)
  (add-hook 'org-after-todo-state-change-hook #'toad/org-done-h))

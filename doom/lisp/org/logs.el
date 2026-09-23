;;; lisp/org/logs.el -*- lexical-binding: t; -*-

(defun toad/org-sections ()
  "titles of the top level headings in this buffer."
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      ;; lowercase headings must not match uppercase todo keywords.
      (let ((case-fold-search nil) titles)
        (while (re-search-forward org-complex-heading-regexp nil t)
          (when (equal (match-string 1) "*")
            (push (match-string-no-properties 4) titles)))
        (nreverse titles)))))

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

(defun toad/org-entries (keyword from to)
  "(DAY STAMP TITLE) for every KEYWORD record dated between days FROM and TO."
  (let ((file (toad/org-tracker-file keyword)))
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

(defun toad/org-keywords ()
  "every activity keyword, one per tracker file."
  (let ((dir (toad/org-file "tracker/")))
    (when (file-directory-p dir)
      (mapcar (lambda (file) (upcase (file-name-base file)))
              (directory-files dir nil "\\.org\\'")))))

(defun toad/org-week-tasks (from)
  "tasks due and activities done, under one heading per day, monday FROM first."
  (mapconcat
   (lambda (day)
     (concat "** " (downcase (format-time-string "%A" (org-time-from-absolute day))) "\n"
             (toad/org-tasks day day "***")
             (mapconcat (lambda (keyword)
                          (mapconcat (pcase-lambda (`(,_ ,_ ,title))
                                       (concat "*** " keyword " " title "\n"))
                                     (toad/org-entries keyword day day) ""))
                        (toad/org-keywords) "")))
   (number-sequence from (+ from 6))
   ""))

(defun toad/org-records (keyword from to)
  "copy KEYWORD tracker records dated between days FROM and TO."
  (mapconcat (pcase-lambda (`(,_ ,stamp ,title))
               (concat "** " stamp " : " title "\n"))
             (toad/org-entries keyword from to) ""))

(defun toad/org-refresh ()
  "rebuild this log's generated sections from this week's sources.
The daily lists tasks; the weekly groups them by day and includes history."
  (interactive)
  (when-let* ((from (toad/org-log-monday)))
    (atomic-change-group
      (toad/org-fill "agenda" (pcase (toad/org-log-kind)
                                ('daily (toad/org-tasks from (+ from 6) "**"))
                                ('weekly (toad/org-week-tasks from))))
      (toad/org-history))))

(defun toad/org-history ()
  "fill every weekly section named after a tracker with that week's records."
  (when-let* (((eq (toad/org-log-kind) 'weekly))
              (from (toad/org-log-monday)))
    (dolist (heading (toad/org-sections))
      (when (file-exists-p (toad/org-tracker-file heading))
        (toad/org-fill heading (toad/org-records heading from (+ from 6)))))))

(defun toad/org-open-h ()
  "seed a new file and fill it; a daily once, a weekly every time.
the daily is yours after creation, so reordering and DONEs stay. the
weekly is a live view of the week and gets rebuilt each time."
  (when (and buffer-file-name (toad/under-p buffer-file-name org-directory))
    (let ((clean (not (buffer-modified-p)))
          (new (zerop (buffer-size))))
      (when new (toad/org-seed))
      (pcase (toad/org-log-kind)
        ('daily (when new (toad/org-refresh)))
        ('weekly (toad/org-refresh)))
      (when (toad/org-log-kind)
        ;; restore the file's folding after inserting generated text.
        (org-cycle-set-startup-visibility)
        (when clean (save-buffer))))))

(add-hook 'org-mode-hook #'toad/org-open-h)

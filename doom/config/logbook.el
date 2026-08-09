;;; config/logbook.el -*- lexical-binding: t; -*-

(require 'calendar)

(defvar toad/logbook-dir "~/org/logbook/")
(defvar toad/daily-template (expand-file-name "daily_template.org" toad/logbook-dir))
(defvar toad/gym-file "~/org/ref/gym.org")
(defvar toad/main-quest-lookahead 3
  "How many days ahead a DEADLINE still counts as a main quest.
Files listed in `toad/deadline-warning-by-file' use their own value
instead, so main quests match what the agenda is showing.")

(defun toad/logbook-today-file ()
  (expand-file-name (format-time-string "%Y%m%d.org") toad/logbook-dir))

(defun toad/logbook-file-date (&optional file)
  "The date a logbook file is for, as YYYY-MM-DD. Nil if FILE isn't a daily log.
FILE defaults to the current buffer's file."
  (let ((file (or file buffer-file-name)))
    (when (and file
               (string-match
                "logbook/\\([0-9]\\{4\\}\\)\\([0-9]\\{2\\}\\)\\([0-9]\\{2\\}\\)\\.org\\'"
                file))
      (format "%s-%s-%s"
              (match-string 1 file) (match-string 2 file) (match-string 3 file)))))

(defun toad/read-template (file)
  "Read template FILE, replacing <DATE> with today's formatted date."
  (when (file-exists-p file)
    (with-temp-buffer
      (insert-file-contents file)
      (goto-char (point-min))
      (while (search-forward "<DATE>" nil t)
        (replace-match (format-time-string "%A, %d %B %Y")))
      (buffer-string))))

(defun toad/date-to-days (date-str)
  "Absolute day number for a YYYY-MM-DD string."
  (calendar-absolute-from-gregorian
   (list (string-to-number (substring date-str 5 7))
         (string-to-number (substring date-str 8 10))
         (string-to-number (substring date-str 0 4)))))

(defun toad/collect-main-quests ()
  "Collect main quests from `org-agenda-files'.
A TODO qualifies if it is dated today, overdue, has a DEADLINE within
that file's lookahead (see `toad/deadline-warning-by-file', falling back
to `toad/main-quest-lookahead'), or is marked [#A] with no date.
Sub-tasks (level 3+) are prefixed with their level-2 parent, so krea
items read \"linear algebra: assignment 1\". Most urgent first."
  (let ((today (toad/date-to-days (format-time-string "%Y-%m-%d")))
        overdue due-today upcoming priority)
    (dolist (file (org-agenda-files))
      (when (file-exists-p file)
       (let ((lookahead (toad/deadline-warning-days-for
                         file toad/main-quest-lookahead)))
        (with-temp-buffer
          (insert-file-contents file)
          (goto-char (point-min))
          (let (parents) ; ancestors of point: ((level . title) ...)
            (while (re-search-forward "^\\(\\*+\\)[ \t]+\\(.+\\)$" nil t)
              (let* ((level (length (match-string 1)))
                     (raw (string-trim (match-string 2)))
                     (head-start (line-beginning-position))
                     (entry-end (save-excursion
                                  (if (re-search-forward "^\\*+[ \t]" nil t)
                                      (line-beginning-position)
                                    (point-max))))
                     (text (and (string-match "\\`TODO[ \t]+\\(.+\\)" raw)
                                (match-string 1 raw))))
                (setq parents
                      (cons (cons level (replace-regexp-in-string
                                         "\\`\\(TODO\\|DONE\\)[ \t]+" "" raw))
                            (seq-remove (lambda (p) (>= (car p) level)) parents)))
                (when (and text (not (string-blank-p text)))
                  (let* ((clean (string-trim
                                 (replace-regexp-in-string "\\[#[A-Z]\\]\\|<[^>]+>" "" text)))
                         (parent2 (cdr (assq 2 (cdr parents))))
                         (label (if (and parent2 (> level 2))
                                    (format "%s: %s" parent2 clean)
                                  clean))
                         dates deadlines)
                    (save-excursion
                      (goto-char head-start)
                      (while (re-search-forward
                              "<\\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}\\)" entry-end t)
                        (let ((d (toad/date-to-days (match-string 1))))
                          (push d dates)
                          (when (save-excursion
                                  (goto-char (match-beginning 0))
                                  (looking-back "DEADLINE:[ \t]*" (line-beginning-position)))
                            (push d deadlines)))))
                    (cond
                     ((memq today dates)
                      (push label due-today))
                     ((seq-some (lambda (d) (< d today)) dates)
                      (push (concat label " (overdue)") overdue))
                     ((seq-some (lambda (d) (<= d (+ today lookahead)))
                                deadlines)
                      (push (format "%s (due in %dd)" label
                                    (- (apply #'min deadlines) today))
                            upcoming))
                     ((and (null dates) (string-match-p "\\[#A\\]" text))
                      (push label priority))))))))))))
    (append (nreverse due-today) (nreverse overdue)
            (nreverse upcoming) (nreverse priority))))

(defun toad/gym-plan-for-today ()
  "Exercises under today's weekday heading in `toad/gym-file'.
Nil on rest days (headings with no list items)."
  (let ((day (format-time-string "%A"))
        exercises)
    (when (file-exists-p toad/gym-file)
      (with-temp-buffer
        (insert-file-contents toad/gym-file)
        (goto-char (point-min))
        (let ((case-fold-search t))
          (when (re-search-forward (format "^\\* %s" day) nil t)
            (let ((end (save-excursion
                         (if (re-search-forward "^\\* " nil t)
                             (match-beginning 0)
                           (point-max)))))
              (while (re-search-forward "^[ \t]*- \\(.+\\)$" end t)
                (push (string-trim (match-string 1)) exercises)))))))
    (nreverse exercises)))

(defun log-today ()
  "Create today's log from the template, main quests filled from the agenda."
  (interactive)
  (let ((file (toad/logbook-today-file)))
    (if (file-exists-p file)
        (progn (find-file file)
               (message "today's log already exists"))
      (find-file file)
      (insert (or (toad/read-template toad/daily-template)
                  (concat "#+TITLE: " (format-time-string "%A, %d %B %Y")
                          "\n#+AUTHOR: toad\n\n* main quest\n* side quests\n** TODO \n* dailies\n** TODO gym\n** TODO learn something new\n** TODO read\n** TODO reply to people\n* rambling of the day\n** \n")))
      (let ((items (toad/collect-main-quests)))
        (goto-char (point-min))
        (when (re-search-forward "^\\* main quest" nil t)
          (end-of-line)
          (if items
              (dolist (item items)
                (insert (format "\n** TODO %s" item)))
            (insert "\n** TODO ")))
        ;; today's exercises go under the gym daily; on a rest day the
        ;; heading loses its TODO so there is nothing to tick off.
        (let ((gym (toad/gym-plan-for-today)))
          (goto-char (point-min))
          (when (re-search-forward "^\\*\\* \\(?:TODO \\)?gym.*$" nil t)
            (if gym
                (dolist (ex gym)
                  (insert (format "\n*** TODO %s" ex)))
              (replace-match "** gym : rest day" t t))))
        (save-buffer)
        (goto-char (point-min))
        (message "today's log created — %d main quest%s"
                 (length items) (if (= (length items) 1) "" "s"))))))

(defun log-open ()
  "Open today's log file if it exists."
  (interactive)
  (let ((file (toad/logbook-today-file)))
    (if (file-exists-p file)
        (find-file file)
      (when (y-or-n-p "no log for today — create one? ")
        (log-today)))))

(defun log-side-quest ()
  "Prompt for a side quest and add it to today's log."
  (interactive)
  (let ((quest (read-string "side quest: "))
        (file (toad/logbook-today-file)))
    (unless (file-exists-p file)
      (log-today))
    (find-file file)
    (goto-char (point-min))
    (if (re-search-forward "^\\* side quests" nil t)
        (progn
          (save-excursion
            (forward-line 1)
            (when (looking-at "\\*\\* TODO\\s-*$")
              (delete-region (line-beginning-position) (min (1+ (line-end-position)) (point-max)))))
          (let ((end (save-excursion
                       (forward-line 1)
                       (if (re-search-forward "^\\* " nil t)
                           (match-beginning 0)
                         (point-max)))))
            (goto-char end)
            (unless (bolp) (insert "\n"))
            (insert (format "** TODO %s\n" quest))))
      (goto-char (point-max))
      (insert (format "\n* side quests\n** TODO %s\n" quest)))
    (save-buffer)
    (message "added: %s" quest)))

;; any TODO under "side quests" in a daily log also lands under "* rest"
;; in agenda/agenda.org when the log is saved (skipped if already there).
(defun toad/sync-side-quests-to-agenda ()
  (when (and buffer-file-name
             (string-match-p "logbook/[0-9]\\{8\\}\\.org\\'" buffer-file-name))
    (let (quests)
      (save-excursion
        (goto-char (point-min))
        (when (re-search-forward "^\\* side quests" nil t)
          (let ((end (save-excursion
                       (if (re-search-forward "^\\* " nil t)
                           (match-beginning 0)
                         (point-max)))))
            (while (re-search-forward "^\\*\\* TODO \\(.+\\)$" end t)
              (let ((q (string-trim (match-string-no-properties 1))))
                (unless (string-blank-p q)
                  (push q quests)))))))
      (when quests
        (with-current-buffer (find-file-noselect
                              (expand-file-name "agenda/agenda.org" org-directory))
          (let (added)
            (dolist (q (nreverse quests))
              (save-excursion
                (goto-char (point-min))
                (unless (search-forward q nil t)
                  (goto-char (point-min))
                  (if (re-search-forward "^\\* rest" nil t)
                      (progn (org-end-of-subtree t)
                             (unless (bolp) (insert "\n")))
                    (goto-char (point-max))
                    (unless (bolp) (insert "\n"))
                    (insert "\n* rest\n"))
                  (insert (format "** TODO %s\n" q))
                  (setq added t))))
            (when added
              (save-buffer)
              (message "side quest(s) synced to agenda"))))))))

(add-hook 'after-save-hook #'toad/sync-side-quests-to-agenda)

(defun log-thought ()
  "Add a timestamped rambling to today's log."
  (interactive)
  (let ((thought (read-string "rambling: "))
        (file (toad/logbook-today-file)))
    (unless (file-exists-p file)
      (log-today))
    (find-file file)
    (goto-char (point-min))
    (if (re-search-forward "^\\* \\(rambling\\|thoughts\\) of the day" nil t)
        (progn
          (save-excursion
            (forward-line 1)
            (when (looking-at "\\*\\*\\s-*$")
              (delete-region (line-beginning-position) (min (1+ (line-end-position)) (point-max)))))
          (let ((end (save-excursion
                       (forward-line 1)
                       (if (re-search-forward "^\\* " nil t)
                           (match-beginning 0)
                         (point-max)))))
            (goto-char end)
            (unless (bolp) (insert "\n"))
            (insert (format "** %s %s\n" (format-time-string "%H:%M") thought))))
      (goto-char (point-max))
      (insert (format "\n* rambling of the day\n** %s %s\n" (format-time-string "%H:%M") thought)))
    (save-buffer)
    (message "rambling logged")))

(defalias 'log-ramble 'log-thought)

(defun log-streak ()
  "Show your consecutive logging streak."
  (interactive)
  (let ((streak 0)
        (date (time-subtract (current-time) (days-to-time 1))))
    (while (file-exists-p
            (expand-file-name (format-time-string "%Y%m%d.org" date) toad/logbook-dir))
      (setq streak (1+ streak))
      (setq date (time-subtract date (days-to-time 1))))
    (when (file-exists-p (toad/logbook-today-file))
      (setq streak (1+ streak)))
    (message "log streak: %d day%s" streak (if (= streak 1) "" "s"))))

(defun log-agenda ()
  "Show today's main quests (same list log-today pulls) in a buffer."
  (interactive)
  (let ((items (toad/collect-main-quests)))
    (if (not items)
        (message "nothing on the agenda for today")
      (with-current-buffer (get-buffer-create "*today's agenda*")
        (erase-buffer)
        (org-mode)
        (insert (format "#+TITLE: agenda for %s\n\n" (format-time-string "%A, %d %B")))
        (dolist (item items)
          (insert (format "* TODO %s\n" item)))
        (goto-char (point-min))
        (pop-to-buffer (current-buffer))))))

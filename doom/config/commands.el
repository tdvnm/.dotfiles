;;; config/commands.el -*- lexical-binding: t; -*-

;; ── open files ───────────────────────────────────────────────
;; M-x open-<name> to jump to any org file instantly.

(defmacro toad/def-open (name file)
  "Define an interactive `open-NAME' command that opens ~/org/FILE."
  (let ((fn (intern (format "open-%s" name))))
    `(defun ,fn ()
       ,(format "Open ~/org/%s." file)
       (interactive)
       (find-file (expand-file-name ,file org-directory)))))

(toad/def-open "agenda"   "agenda/agenda.org")
(toad/def-open "krea"     "agenda/krea.org")
(toad/def-open "research" "agenda/research.org")
(toad/def-open "work"     "agenda/work.org")
(toad/def-open "inbox"    "inbox.org")
(defalias 'open-dump 'open-inbox)   ; inbox = the dump; sort it later with refile-inbox
(toad/def-open "projects" "projects.org")
(toad/def-open "films"    "lists/films.org")
(toad/def-open "books"    "lists/books.org")
(toad/def-open "courses"  "lists/courses.org")
(toad/def-open "shop"     "lists/shop.org")
(toad/def-open "goals"    "me/goals.org")
(toad/def-open "essays"   "essays/ideas.org")

;; ── show views ───────────────────────────────────────────────
;; M-x show-<thing> for agenda views.

(defun show-agenda ()
  "Show the org-agenda for today (scheduled/deadline items)."
  (interactive)
  (org-agenda nil "a"))

(defun show-todos ()
  "Show all TODO items across agenda files."
  (interactive)
  (org-agenda nil "t"))

;; ── add entries ──────────────────────────────────────────────
;; M-x add-<thing> to quickly add items to the right place.

(defun add-task ()
  "Quickly add a TODO to inbox.org. Refile later with M-x refile-inbox."
  (interactive)
  (let ((task (read-string "task: ")))
    (with-current-buffer (find-file-noselect (expand-file-name "inbox.org" org-directory))
      (goto-char (point-min))
      (if (re-search-forward "^\\* tasks" nil t)
          (progn (org-end-of-subtree t)
                 (unless (bolp) (insert "\n")))
        (goto-char (point-max))
        (insert "\n* tasks\n"))
      (insert (format "** TODO %s\n" task))
      (save-buffer))
    (message "task added: %s" task)))

(defun add-note ()
  "Quickly add a note to inbox.org."
  (interactive)
  (let ((note (read-string "note: ")))
    (with-current-buffer (find-file-noselect (expand-file-name "inbox.org" org-directory))
      (goto-char (point-min))
      (if (re-search-forward "^\\* notes" nil t)
          (progn (org-end-of-subtree t)
                 (unless (bolp) (insert "\n")))
        (goto-char (point-max))
        (insert "\n* notes\n"))
      (insert (format "** %s\n" note))
      (save-buffer))
    (message "noted: %s" note)))

(defalias 'add-dump 'add-note)

(defun add-todo ()
  "Add a TODO to agenda/agenda.org (high/medium/rest), krea.org, or work.org."
  (interactive)
  (let* ((section (completing-read "section: "
                                   '("high priority" "medium priority" "rest" "krea" "work")
                                   nil t))
         (task (read-string "todo: "))
         (file (pcase section
                 ("krea" "agenda/krea.org")
                 ("work" "agenda/work.org")
                 (_ "agenda/agenda.org")))
         (heading (pcase section
                    ("krea" "meta")
                    ("work" "tasks")
                    (_ section)))
         (cookie (pcase section
                   ("high priority" "[#A] ")
                   ("medium priority" "[#B] ")
                   (_ ""))))
    (with-current-buffer (find-file-noselect (expand-file-name file org-directory))
      (goto-char (point-min))
      (if (re-search-forward (format "^\\* %s" (regexp-quote heading)) nil t)
          (progn (org-end-of-subtree t)
                 (unless (bolp) (insert "\n")))
        (goto-char (point-max))
        (unless (bolp) (insert "\n"))
        (insert (format "\n* %s\n" heading)))
      (insert (format "** TODO %s%s\n" cookie task))
      (save-buffer))
    (message "added to %s: %s" section task)))

(defun add-reply ()
  "Add a reply-to entry (text/mail) to agenda/agenda.org with a date."
  (interactive)
  (let* ((name (read-string "who: "))
         (type (completing-read "type: " '("text" "mail")))
         (date (format-time-string "%Y-%m-%d %a"
                                   (org-read-date nil t nil "by when: "))))
    (with-current-buffer (find-file-noselect (expand-file-name "agenda/agenda.org" org-directory))
      (goto-char (point-min))
      (if (re-search-forward (format "^\\*\\* %s" type) nil t)
          (progn (org-end-of-subtree t)
                 (unless (bolp) (insert "\n"))
                 (insert (format "*** TODO %s\n<%s>\n" name date)))
        (goto-char (point-max))
        (insert (format "\n* reply\n** %s\n*** TODO %s\n<%s>\n" type name date)))
      (save-buffer))
    (message "reply added: %s (%s)" name type)))

(defun add-film ()
  "Add a film to the watchlist with tier, year, and director."
  (interactive)
  (let* ((name (read-string "film: "))
         (tier (completing-read "tier: " '("S" "A" "B" "C" "D")))
         (release (read-string "release year: "))
         (director (read-string "director (blank to skip): ")))
    (find-file (expand-file-name "lists/films.org" org-directory))
    (goto-char (point-max))
    (insert (format "\n*** TODO %s\n:PROPERTIES:\n:TIER:     %s\n:RELEASE:  %s\n"
                    name tier release))
    (unless (string-empty-p director)
      (insert (format ":DIRECTOR: %s\n" director)))
    (insert ":END:\n")
    (save-buffer)
    (message "film added: %s" name)))

(defun add-book ()
  "Add a book to the reading list."
  (interactive)
  (let* ((author (read-string "author: "))
         (title (read-string "title: ")))
    (find-file (expand-file-name "lists/books.org" org-directory))
    (goto-char (point-max))
    (insert (format "** TODO %s - %s\n" author title))
    (save-buffer)
    (message "added: %s - %s" author title)))

(defun toad/project-dirs ()
  "Names of all in-depth projects (folders under ~/org/projects/)."
  (let ((root (expand-file-name "projects/" org-directory)))
    (when (file-directory-p root)
      (seq-filter (lambda (d) (file-directory-p (expand-file-name d root)))
                  (directory-files root nil "^[^.]")))))

(defun add-project ()
  "Start an in-depth project: projects/<name>/ with todo.org + log.org, linked from projects.org."
  (interactive)
  (let* ((name (read-string "project: "))
         (slug (string-trim (replace-regexp-in-string "[^a-z0-9]+" "_" (downcase name)) "_" "_"))
         (dir (expand-file-name (concat "projects/" slug "/") org-directory))
         (todo-file (expand-file-name "todo.org" dir))
         (log-file (expand-file-name "log.org" dir)))
    (make-directory dir t)
    (unless (file-exists-p todo-file)
      (with-current-buffer (find-file-noselect todo-file)
        (insert (format "#+TITLE: %s\n\n* todo\n** TODO \n" name))
        (save-buffer)))
    (unless (file-exists-p log-file)
      (with-current-buffer (find-file-noselect log-file)
        (insert (format "#+TITLE: %s log\n#+AUTHOR: toad\n\n* %s\n** \n"
                        name (format-time-string "%-d %B")))
        (save-buffer)))
    ;; link it from the projects.org overview
    (with-current-buffer (find-file-noselect (expand-file-name "projects.org" org-directory))
      (goto-char (point-min))
      (unless (search-forward (format "projects/%s/todo.org" slug) nil t)
        (if (re-search-forward "^\\* in-depth projects" nil t)
            (org-end-of-subtree t)
          (goto-char (point-max)))
        (unless (bolp) (insert "\n"))
        (insert (format "** [[file:projects/%s/todo.org][%s]]\n" slug name))
        (save-buffer)))
    ;; make its todos show up in agenda views right away
    (add-to-list 'org-agenda-files todo-file t)
    (find-file todo-file)
    (message "project started: projects/%s/" slug)))

(defun open-project ()
  "Pick an in-depth project and open its todo.org."
  (interactive)
  (let ((name (completing-read "project: " (toad/project-dirs) nil t)))
    (find-file (expand-file-name (format "projects/%s/todo.org" name) org-directory))))

(defun log-project ()
  "Add a dated entry to a project's log.org."
  (interactive)
  (let* ((name (completing-read "project: " (toad/project-dirs) nil t))
         (entry (read-string "worked on: "))
         (file (expand-file-name (format "projects/%s/log.org" name) org-directory))
         (today (format-time-string "* %-d %B")))
    (with-current-buffer (find-file-noselect file)
      (goto-char (point-max))
      (unless (bolp) (insert "\n"))
      (unless (save-excursion (re-search-backward (concat "^" (regexp-quote today) "$") nil t))
        (insert (format "\n%s\n" today)))
      (insert (format "** %s\n" entry))
      (save-buffer))
    (message "logged to %s: %s" name entry)))

(defun add-essay-idea ()
  "Add an essay idea to essays/ideas.org."
  (interactive)
  (let ((idea (read-string "essay idea: ")))
    (with-current-buffer (find-file-noselect (expand-file-name "essays/ideas.org" org-directory))
      (goto-char (point-max))
      (insert (format "* TODO %s\n" idea))
      (save-buffer))
    (message "essay idea: %s" idea)))

;; ── search & browse ──────────────────────────────────────────
;; M-x browse-org / search-org to find anything.

(defun browse-org ()
  "Find a file inside ~/org/."
  (interactive)
  (consult-find org-directory))

(defun search-org ()
  "Full-text search across all files in ~/org/."
  (interactive)
  (consult-ripgrep org-directory))

;; ── refile ───────────────────────────────────────────────────
;; M-x refile-inbox to move inbox items to the right file.

(defun refile-inbox ()
  "Refile the heading at point into the right file."
  (interactive)
  (let ((org-refile-targets
         (append '(("~/org/agenda/agenda.org" :maxlevel . 2)
                   ("~/org/agenda/krea.org" :maxlevel . 2)
                   ("~/org/agenda/research.org" :maxlevel . 2)
                   ("~/org/agenda/work.org" :maxlevel . 1)
                   ("~/org/projects.org" :maxlevel . 2)
                   ("~/org/lists/books.org" :maxlevel . 1)
                   ("~/org/lists/courses.org" :maxlevel . 1)
                   ("~/org/me/goals.org" :maxlevel . 1))
                 (mapcar (lambda (f) (cons f '(:maxlevel . 1)))
                         (file-expand-wildcards "~/org/projects/*/todo.org")))))
    (org-refile)))

;; ── misc ─────────────────────────────────────────────────────

(defun toad/ddg-search (query)
  "Search QUERY on DuckDuckGo in Firefox."
  (interactive "sSearch: ")
  (start-process "firefox" nil "firefox" "--new-window"
                 (concat "https://duckduckgo.com/?q=" (url-hexify-string query))))

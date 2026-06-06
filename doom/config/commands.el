;;; config/commands.el -*- lexical-binding: t; -*-

;; quick-open

(defun toad/open-agenda ()
  (interactive)
  (find-file "~/org/agenda/agenda.org"))

(defun toad/open-films ()
  (interactive)
  (find-file "~/org/films/list.org"))

(defun toad/open-books ()
  (interactive)
  (find-file "~/org/books/list.org"))

(defun toad/open-work ()
  (interactive)
  (find-file "~/org/agenda/work.org"))

;; add reply

(defun toad/add-reply ()
  "Add a reply entry (text/mail) to reply.org with a date."
  (interactive)
  (let* ((name (read-string "name: "))
         (type (completing-read "type: " '("text" "mail")))
         (date (format-time-string "%Y-%m-%d %a" (org-read-date nil t nil "when: "))))
    (find-file "~/org/agenda/reply.org")
    (goto-char (point-min))
    (if (re-search-forward (format "^\\* %s" type) nil t)
        (progn
          (org-end-of-subtree t)
          (unless (bolp) (insert "\n"))
          (insert (format "** TODO %s\n<%s>\n" name date)))
      (goto-char (point-max))
      (insert (format "\n* %s\n** TODO %s\n<%s>\n" type name date)))
    (save-buffer)
    (message "added: %s → %s" name type)))

;; tracker logging

(defun toad/log-learn ()
  "Log today's learning in the learning tracker."
  (interactive)
  (let ((desc (read-string "learned: "))
        (today (format-time-string "<%Y-%m-%d %a>")))
    (find-file "~/org/agenda/tracker/learn.org")
    (goto-char (point-max))
    (unless (bolp) (insert "\n"))
    (insert (format "** DONE %s %s\n" today desc))
    (save-buffer)
    (message "logged: %s" desc)))

(defun toad/log-media ()
  "Log today's media in the media tracker."
  (interactive)
  (let ((desc (read-string "watched/listened: "))
        (today (format-time-string "<%Y-%m-%d %a>")))
    (find-file "~/org/agenda/tracker/media.org")
    (goto-char (point-max))
    (unless (bolp) (insert "\n"))
    (insert (format "** DONE %s %s\n" today desc))
    (save-buffer)
    (message "logged: %s" desc)))

;;; config/org.el -*- lexical-binding: t; -*-

(setq org-directory "~/org/")
(setq +fold-ellipsis (propertize "󱞣" 'face '(:height 1.0)))
(setq org-agenda-files
      (append (file-expand-wildcards "~/org/agenda/*.org")
              '("~/org/projects.org" "~/org/inbox.org")
              (file-expand-wildcards "~/org/projects/*/todo.org")))

;; how many days before a DEADLINE it starts showing in the agenda, per file.
;; krea assessments need runway; agenda/research items only matter right before.
(defvar toad/deadline-warning-by-file
  '(("krea.org"     . 5)
    ("agenda.org"   . 1)
    ("research.org" . 1))
  "Alist of agenda file name to its own `org-deadline-warning-days'.
Files not listed here keep the global value.")

(defun toad/deadline-warning-days-for (file &optional default)
  "Deadline lead time for FILE, or DEFAULT if it has no entry."
  (or (and file
           (alist-get (file-name-nondirectory file)
                      toad/deadline-warning-by-file nil nil #'equal))
      default))

(defun toad/deadline-warning-days-a (fn &rest args)
  "Run FN with `org-deadline-warning-days' set for the file being scanned.
`org-agenda-get-deadlines' runs inside the source file's buffer, so
`buffer-file-name' tells us which agenda file these deadlines came from."
  (let ((org-deadline-warning-days
         (toad/deadline-warning-days-for buffer-file-name
                                         org-deadline-warning-days)))
    (apply fn args)))

(advice-add 'org-agenda-get-deadlines :around #'toad/deadline-warning-days-a)

;; progressive org heading sizes
(custom-set-faces!
  '(org-level-1 :inherit outline-1 :height 1.15 :weight bold))

(add-hook 'org-mode-hook #'org-modern-mode)

(after! org-modern
  (setq org-modern-star 'replace
        org-modern-replace-stars '("" "󰫢" "◉" "○" "✸" )
        org-modern-todo nil
        org-modern-keyword nil))

;; org-capture: SPC X to quickly capture to inbox
(after! org
  (setq org-capture-templates
        '(("t" "Task" entry (file+headline "~/org/inbox.org" "tasks")
           "** TODO %?\n%U\n")
          ("n" "Note" entry (file+headline "~/org/inbox.org" "notes")
           "** %?\n%U\n"))))

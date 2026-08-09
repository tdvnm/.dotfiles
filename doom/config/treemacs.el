;;; config/treemacs.el -*- lexical-binding: t; -*-

(defmacro toad/open-dir (name path)
  `(defun ,name () (interactive) (dired ,path)))

(toad/open-dir toad/org    "~/org")
(toad/open-dir toad/code   "~/code")

(defun treemacs-org ()
  "Show ~/org/ in treemacs."
  (interactive)
  ;; dired the directory itself rather than opening a file inside it — the old
  ;; version opened ~/org/agenda.org, which moved to agenda/ in the July reorg,
  ;; so every call silently created an empty file at the old path.
  (dired (expand-file-name "~/org/"))
  (treemacs-display-current-project-exclusively))

(defun treemacs-code ()
  "Show ~/code/ in treemacs."
  (interactive)
  (dired (expand-file-name "~/code/"))
  (treemacs-display-current-project-exclusively))

(map! "M-d" #'treemacs
      "M-f" #'treemacs-select-window
      "M-o" #'toad/org
      "M-c" #'toad/code)

(setq treemacs-position 'right)
(setq treemacs-width 45)
(setq treemacs-default-visit-action 'treemacs-visit-node-in-most-recently-used-window)

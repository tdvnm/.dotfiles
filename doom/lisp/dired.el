;;; lisp/dired.el -*- lexical-binding: t; -*-
;; hide dotfiles alongside doom's existing omit patterns.
(after! dired-x
  (unless (string-prefix-p "\\`\\.\\|" dired-omit-files)
    (setq dired-omit-files (concat "\\`\\.\\|" dired-omit-files))))

(after! dirvish-subtree
  (setopt dirvish-subtree-state-style 'plus))

;; restore file creation keys hidden by dirvish.
(after! dirvish
  (map! :map (dired-mode-map dirvish-mode-map)
        :n "N" #'dired-create-empty-file
        :n "+" #'dired-create-directory))

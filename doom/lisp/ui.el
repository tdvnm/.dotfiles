;;; lisp/ui.el -*- lexical-binding: t; -*-

;;; fonts and theme

;; missing fonts stay nil, doom's default; rerun per frame, the daemon starts without one.
(defun toad/set-fonts-h ()
  "use these fonts when installed."
  (when (find-font (font-spec :family "Monaspace Neon NF"))
    (setq doom-font (font-spec :family "Monaspace Neon NF" :size 16)))
  (when (find-font (font-spec :family "Unifont"))
    (setq doom-symbol-font (font-spec :family "Unifont"))))

(toad/set-fonts-h)
(add-hook 'server-after-make-frame-hook #'toad/set-fonts-h -101)

(setq doom-theme 'base16-bubblegum)

(custom-set-faces! '(org-date :underline nil))

;;; modeline

(setq nyan-animate-nyancat t
      nyan-animation-frame-interval 0.5)
(nyan-mode)

;; main with the workspace name where the tab-bar name would go.
(after! doom-modeline
  (setq doom-modeline-persp-name t)
  (doom-modeline-def-modeline 'main
    '(eldoc bar window-state persp-name window-number modals matches follow
      buffer-info remote-host buffer-position word-count parrot selection-info)
    '(compilation objed-state misc-info project-name battery grip irc mu4e gnus
      github debug repl lsp minor-modes input-method indent-info
      buffer-encoding major-mode process vcs check time)))

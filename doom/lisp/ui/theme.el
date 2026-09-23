;;; lisp/ui/theme.el -*- lexical-binding: t; -*-
;; choose fonts before doom's frame hook at depth -100.
(defun toad/fonts-init-h ()
  "choose installed fonts before doom applies them to a graphical frame."
  (when (display-graphic-p)
    (when (find-font (font-spec :family "Monaspace Neon NF"))
      (setq doom-font (font-spec :family "Monaspace Neon NF" :size 16)))
    (when (find-font (font-spec :family "Unifont"))
      (setq doom-symbol-font (font-spec :family "Unifont")))))

(toad/fonts-init-h)
(add-hook 'server-after-make-frame-hook #'toad/fonts-init-h -101)

(setq doom-theme 'base16-bubblegum)

(custom-set-faces! '(org-date :underline nil))

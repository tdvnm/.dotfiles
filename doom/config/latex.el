;;; config/latex.el -*- lexical-binding: t; -*-

(defun toad/latex-compile-on-save ()
  (add-hook 'after-save-hook
            #'toad/latex-run-all nil t))

(defun toad/latex-run-all ()
  (call-interactively #'TeX-command-run-all))

(after! tex
  (setq TeX-show-compilation nil)
  (setq TeX-view-program-selection '((output-pdf "PDF Tools")))
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)
  (add-hook 'LaTeX-mode-hook #'toad/latex-compile-on-save))

;;; config/latex.el -*- lexical-binding: t; -*-

(defun +latex-compile-on-save ()
  (add-hook 'after-save-hook
            #'+latex-run-all nil t))

(defun +latex-run-all ()
  (call-interactively #'TeX-command-run-all))

(after! tex
  (setq TeX-show-compilation nil)
  (add-hook 'LaTeX-mode-hook #'+latex-compile-on-save))

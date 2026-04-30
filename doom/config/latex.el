;;; config/latex.el -*- lexical-binding: t; -*-

(after! tex
  (setq TeX-show-compilation nil)           ; don't pop up compilation log
  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (add-hook 'after-save-hook
                        (lambda () (call-interactively #'TeX-command-run-all))
                        nil t))))

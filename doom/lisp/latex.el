;;; lisp/latex.el -*- lexical-binding: t; -*-
;; keep compiled documents inside emacs.
(setq +latex-viewers '(pdf-tools))

;; use whichever server is installed.
(after! lsp-tex
  (cond ((executable-find "texlab")   (setq lsp-tex-server 'texlab))
        ((executable-find "digestif") (setq lsp-tex-server 'digestif))))

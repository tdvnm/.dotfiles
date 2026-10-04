;;; lisp/modes.el -*- lexical-binding: t; -*-

;;; latex

;; keep compiled documents inside emacs.
(setq +latex-viewers '(pdf-tools))

;; use whichever server is installed.
(after! lsp-tex
  (cond ((executable-find "texlab")   (setq lsp-tex-server 'texlab))
        ((executable-find "digestif") (setq lsp-tex-server 'digestif))))

;;; web

(after! web-mode
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-enable-css-colorization t
        web-mode-enable-auto-quoting nil))

;;; rss

(after! elfeed-org
  (setq rmh-elfeed-org-files
        (list (expand-file-name "library/feeds.org" (toad/place-root "org")))))

;;; config/ui.el -*- lexical-binding: t; -*-

(setq doom-theme 'doom-henna)
(add-to-list 'custom-theme-load-path (expand-file-name "themes/" doom-user-dir))

;; (setq doom-font (font-spec :family "Monaspace Neon NF" :size 16))
(setq doom-font (font-spec :family "Sergamon" :size 16))

;; frameless + transparency
(add-to-list 'default-frame-alist '(undecorated . t))
(set-frame-parameter nil 'alpha '(92 . 92))

;; keep cursor vertically centered
(setq scroll-margin 999
      maximum-scroll-margin 0.5)

(setq display-line-numbers-type 'relative)

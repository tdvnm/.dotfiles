;;; config/ui.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "Monaspace Neon NF" :size 16)
      doom-variable-pitch-font (font-spec :family "Monaspace Neon NF" :size 16))

(setq doom-theme 'base16-horizon-sakura)

(setq display-line-numbers-type 'relative)

(setq scroll-margin 999
      scroll-conservatively 101
      fast-but-imprecise-scrolling t)

(setq font-lock-maximum-size nil
      jit-lock-stealth-time 0.5
      jit-lock-chunk-size 4000
      jit-lock-stealth-nice nil)

(setq read-process-output-max (* 1024 1024)
      inhibit-compacting-font-caches t)



(custom-set-faces!
  '(font-lock-function-name-face :weight bold)
  '(font-lock-keyword-face :weight bold)
  '(font-lock-builtin-face :weight bold)
  '(font-lock-type-face :weight bold)
  '(font-lock-variable-name-face :weight bold))

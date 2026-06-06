;;; config/ui.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "Monaspace Neon NF" :size 16))

(setq doom-theme 'base16-bubblegum)

(setq display-line-numbers-type 'relative)

(setq split-height-threshold nil
      split-width-threshold 0)

(setq scroll-margin 999)

(setq read-process-output-max (* 1024 1024)
      inhibit-compacting-font-caches t)



(defun my/vterm-toggle ()
  "Toggle vterm in a right side window."
  (interactive)
  (if-let ((win (cl-find-if (lambda (w)
                              (with-current-buffer (window-buffer w)
                                (eq major-mode 'vterm-mode)))
                            (window-list))))
      (delete-window win)
    (let ((buf (get-buffer-create "*vterm*"))
          (win (split-window (frame-root-window)
                             (- (round (* 0.35 (frame-width))))
                             'right)))
      (set-window-buffer win buf)
      (select-window win)
      (unless (eq major-mode 'vterm-mode)
        (vterm-mode)))))

(custom-set-faces!
  '(font-lock-function-name-face :weight bold)
  '(font-lock-keyword-face :weight bold)
  '(font-lock-builtin-face :weight bold)
  '(font-lock-type-face :weight bold)
  '(font-lock-variable-name-face :weight bold))

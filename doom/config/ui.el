;;; config/ui.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "Monaspace Neon NF" :size 16))
(setq doom-theme 'base16-bubblegum)
(setq display-line-numbers-type 'relative)
(setq split-height-threshold nil
      split-width-threshold 0)
(setq scroll-margin 999)
(setq read-process-output-max (* 1024 1024)
      inhibit-compacting-font-caches t)

;; bypass XWayland's clipboard bridge and read the Wayland clipboard directly,
;; like neovim does. Verified necessary: with an external app owning the
;; clipboard, `gui-get-selection' returns nil here while `wl-paste' returns the
;; text, so Emacs' native X11 read is simply broken under this compositor.
;;
;; Emacs calls this synchronously on every yank, so it must never block:
;;   - skip entirely when Emacs owns the selection. The kill-ring is already
;;     current, and asking wl-paste would route through Xwayland back to this
;;     very Emacs, which is sitting blocked here waiting for the answer.
;;   - wrap in `timeout', which runs the child in its own process group and
;;     signals the whole group. wl-paste forks a `cat' to stream the data; if
;;     only wl-paste were killed, that `cat' would survive holding our pipe
;;     open and we would block forever anyway.
;;   - call-process directly rather than `shell-command-to-string', so no
;;     extra shell sits in the middle of that process group.
(defun toad/wl-paste ()
  (unless (and (fboundp 'x-selection-owner-p)
               (x-selection-owner-p 'CLIPBOARD))
    (with-temp-buffer
      (when (eq 0 (call-process "timeout" nil t nil "0.3" "wl-paste" "-n"))
        (let ((text (buffer-string)))
          (unless (or (string-empty-p text)
                      (equal text (car kill-ring)))
            text))))))
(setq interprogram-paste-function #'toad/wl-paste)

;; nyan cat in modeline
(use-package! nyan-mode
  :init (nyan-mode 1)
  :config
  (setq nyan-wavy-trail t)
  (nyan-start-animation))

(use-package! rainbow-mode
  :hook (emacs-lisp-mode . rainbow-mode))

(use-package! evil-goggles
  :init (evil-goggles-mode)
  :config (evil-goggles-use-diff-faces))

(custom-set-faces!
  '(font-lock-function-name-face :weight bold)
  '(font-lock-keyword-face :weight bold)
  '(font-lock-builtin-face :weight bold)
  '(font-lock-type-face :weight bold)
  '(font-lock-variable-name-face :weight bold))

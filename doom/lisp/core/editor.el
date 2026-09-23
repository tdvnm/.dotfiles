;;; lisp/core/editor.el -*- lexical-binding: t; -*-
(setq display-line-numbers-type 'relative
      shell-file-name (or (executable-find "bash") "/bin/sh"))

;; keep the cursor centered while moving through a buffer.
(setq scroll-margin 99999
      maximum-scroll-margin 0.5
      scroll-conservatively 10)

;; doom's gcmh-mode declaration misses the gcmh feature on this install.
(after! gcmh
  (setq gcmh-idle-delay 'auto
        gcmh-auto-idle-delay-factor 10
        gcmh-high-cons-threshold (* 64 1024 1024)))

;; snippet completion requires the disabled snippets module.
(after! lsp-mode
  (setq lsp-enable-snippet (modulep! :editor snippets)))

(defface toad/flash-face
  '((((background light)) :background "#a8e0d7" :extend nil)
    (((background dark))  :background "#17564d" :extend nil))
  "face the yank flash paints with.")

(defun toad/flash-yank-a (beg end &rest _)
  "flash the yanked region from BEG to END."
  (let ((overlay (make-overlay beg end)))
    (overlay-put overlay 'face 'toad/flash-face)
    (overlay-put overlay 'priority 100)
    (run-with-timer 0.15 nil #'delete-overlay overlay)))

(defun toad/quit-buffer-keep-window ()
  "kill this buffer and show the previous one, keeping the window."
  (interactive)
  (let ((buf (current-buffer)))
    (switch-to-prev-buffer nil t)
    (when (eq (current-buffer) buf)
      (switch-to-buffer (doom-fallback-buffer)))
    (unwind-protect
        (kill-buffer buf)
      (when (buffer-live-p buf)
        (switch-to-buffer buf)))))

(defun toad/half-fill ()
  "toggle auto fill at half the window width."
  (interactive)
  (setq fill-column (/ (window-body-width) 2))
  (auto-fill-mode 'toggle))

;; ask the filesystem so newly created files appear in project searches.
(after! projectile
  (setq projectile-enable-caching nil))

;; keep copied text out of saved history.
(after! savehist
  (setq savehist-additional-variables
        (delq 'register-alist
              (delq 'kill-ring savehist-additional-variables))))

(after! evil
  (setq evil-insert-state-cursor 'box)
  (evil-ex-define-cmd "q[uit]" #'toad/quit-buffer-keep-window)
  (advice-add 'evil-yank :after #'toad/flash-yank-a))

;; letters make diagnostics readable without fringe icons.
(after! flycheck
  (setq-default flycheck-indication-mode 'left-margin
                flycheck-fixable-indicator nil)
  (dolist (spec '((error   "E" flycheck-fringe-error)
                  (warning "W" flycheck-fringe-warning)
                  (info    "H" flycheck-fringe-info)))
    (setf (get (nth 0 spec) 'flycheck-margin-spec)
          (flycheck-make-margin-spec (nth 1 spec) (nth 2 spec))))
  (add-hook 'flycheck-mode-hook #'flycheck-refresh-fringes-and-margins))

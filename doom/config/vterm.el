;;; config/vterm.el -*- lexical-binding: t; -*-

(defvar toad/vterm-buf-name "*vterm-popup*")

(defun toad/vterm-toggle ()
  "Toggle a vterm side window on the right at 50% width."
  (interactive)
  (if-let ((win (cl-find-if (lambda (w)
                              (string= (buffer-name (window-buffer w))
                                       toad/vterm-buf-name))
                            (window-list))))
      (progn (delete-window win)
             (when (get-buffer toad/vterm-buf-name)
               (bury-buffer (get-buffer toad/vterm-buf-name))))
    (let* ((buf (or (get-buffer toad/vterm-buf-name)
                    (generate-new-buffer toad/vterm-buf-name)))
           (win (display-buffer-in-side-window
                 buf `((side . right) (window-width . 0.5)))))
      (select-window win)
      (unless (eq major-mode 'vterm-mode)
        (vterm-mode))
      (set-window-dedicated-p win t))))

(map! :nvig "M-q" #'toad/vterm-toggle)
(after! vterm
  (evil-define-key* '(normal insert visual emacs) vterm-mode-map (kbd "M-q") #'toad/vterm-toggle)
  (setq vterm-kill-buffer-on-exit nil))

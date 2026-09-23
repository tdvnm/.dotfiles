;;; lisp/pdf.el -*- lexical-binding: t; -*-
(defun toad/pdf-buffer-p (buffer &rest _)
  "whether BUFFER is a pdf, even if renamed."
  (when-let* ((buffer (and buffer (get-buffer buffer))))
    (with-current-buffer buffer (derived-mode-p 'pdf-view-mode))))

(defun toad/pdf-split (buffer alist)
  "display BUFFER in a new right-hand split using ALIST."
  (let ((split-window-preferred-function
         (lambda (window) (split-window window nil 'right))))
    (display-buffer-pop-up-window buffer alist)))

;; doom rebuilds display rules from its own list.
(let ((rule '(toad/pdf-buffer-p
              (display-buffer-reuse-window toad/pdf-split)
              (window-width . 0.5))))
  (add-to-list 'display-buffer-alist rule)
  (add-to-list '+popup--display-buffer-alist rule))

;; file opening normally bypasses display rules.
(defun toad/pdf-switch-a (fn buffer &rest args)
  "let pdf display rules apply when FN switches to BUFFER with ARGS."
  (let ((switch-to-buffer-obey-display-actions
         (or switch-to-buffer-obey-display-actions
             (toad/pdf-buffer-p buffer))))
    (apply fn buffer args)))

(advice-add 'switch-to-buffer :around #'toad/pdf-switch-a)

;; nix may install epdfinfo beside its elisp, outside path.
(after! pdf-info
  (unless (file-executable-p pdf-info-epdfinfo-program)
    (when-let* ((found (or (executable-find "epdfinfo")
                           (seq-find #'file-executable-p
                                     (mapcar (lambda (dir)
                                               (expand-file-name "epdfinfo" dir))
                                             load-path)))))
      (setq pdf-info-epdfinfo-program found))))

(after! pdf-view
  (setq-default pdf-view-display-size 'fit-width))

;;; lisp/pdf.el -*- lexical-binding: t; -*-

(defun toad/pdf-buffer-p (buffer &rest _)
  "whether BUFFER, a buffer or its name, is a pdf."
  (when-let* ((buffer (and buffer (get-buffer buffer))))
    (with-current-buffer buffer (derived-mode-p 'pdf-view-mode))))

;; one pdf-only column right of the main area; doom rebuilds the alist, so add to both.
(let ((rule '(toad/pdf-buffer-p
              (display-buffer-reuse-mode-window display-buffer-in-direction)
              (direction . right)
              (window . main)
              (dedicated . t))))
  (add-to-list 'display-buffer-alist rule)
  (add-to-list '+popup--display-buffer-alist rule))

;; find-file shows buffers with switch-to-buffer, which skips display rules.
(defun toad/pdf-switch-a (fn buffer &rest args)
  "let the pdf rule place BUFFER when FN switches to it with ARGS."
  (let ((switch-to-buffer-obey-display-actions
         (or switch-to-buffer-obey-display-actions
             (toad/pdf-buffer-p buffer))))
    (apply fn buffer args)))

(advice-add 'switch-to-buffer :around #'toad/pdf-switch-a)

;; the drawer opens files inside its own window, so hand pdfs to the rule.
(defun toad/pdf-find-entry-h (entry &rest _)
  "show ENTRY through the pdf rule when it is a pdf."
  (unless (file-directory-p entry)
    (let ((buffer (find-file-noselect entry)))
      (when (toad/pdf-buffer-p buffer)
        (pop-to-buffer buffer)
        t))))

(add-hook 'dirvish-find-entry-hook #'toad/pdf-find-entry-h)

;; nix ships epdfinfo beside its own copy of pdf-tools on the load path.
(after! pdf-info
  (setq pdf-info-epdfinfo-program (locate-file "epdfinfo" load-path nil 'executable)))

(after! pdf-view
  (setq-default pdf-view-display-size 'fit-width))

;;; lisp/windows.el -*- lexical-binding: t; -*-

;; split only when asked.
(setq pop-up-windows nil)

;;; tabs

(toad/bind-global "M-[" #'centaur-tabs-backward)
(toad/bind-global "M-]" #'centaur-tabs-forward)

;;; workspaces

;; keep workspace numbers in place order.
(setq +workspaces-main (caar toad/places))

(defun toad/places-order-a (names)
  "sort NAMES by their position in `toad/places', unknown names last."
  (let ((order (mapcar #'car toad/places)))
    (sort (copy-sequence names)
          (lambda (a b)
            (< (or (cl-position a order :test #'equal) most-positive-fixnum)
               (or (cl-position b order :test #'equal) most-positive-fixnum))))))

(advice-add '+workspace-list-names :filter-return #'toad/places-order-a)

(defun toad/place-fresh-p ()
  "non-nil when the workspace has no real buffers."
  (not (seq-some #'doom-real-buffer-p (+workspace-buffer-list))))

;; doom quits dirvish before a switch, which can leave scratch behind.
(defun toad/place-resume ()
  "show a real buffer when the only window holds a non-real one."
  (when (and (not (doom-real-buffer-p (current-buffer)))
             (null (cdr (window-list))))
    (when-let* ((real (seq-find #'doom-real-buffer-p (+workspace-buffer-list))))
      (switch-to-buffer real))))

(defun toad/go (name &optional dired)
  "switch to the place NAME.
with DIRED, open its root when the workspace is empty."
  (interactive (list (completing-read "place: " (mapcar #'car toad/places) nil t)
                     t))
  (let ((root (or (toad/place-root name)
                  (user-error "No place named %s" name))))
    (unless (file-directory-p root)
      (user-error "Place does not exist: %s" (abbreviate-file-name root)))
    (+workspace-switch name t)
    (if (and dired (toad/place-fresh-p))
        (dired root)
      (toad/place-resume))
    root))

(defun toad/places-init-h ()
  "create any missing place workspaces."
  (when (bound-and-true-p persp-mode)
    (dolist (name (mapcar #'car (cdr toad/places)))
      (unless (+workspace-exists-p name)
        (+workspace-new name)))))

;; the direct call also handles config reloads.
(add-hook 'persp-mode-hook #'toad/places-init-h t)
(when (bound-and-true-p persp-mode)
  (toad/places-init-h))

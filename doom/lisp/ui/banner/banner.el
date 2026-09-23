;;; lisp/ui/banner/banner.el -*- lexical-binding: t; -*-

(defconst toad/banner-dir (dir!)
  "directory holding banner.txt and the pngs.")

(defconst toad/banner-image-scale 0.28
  "image height as a fraction of window height, so it scales with the frame.")

(defun toad/banner--art ()
  "the ascii art as lines, or nil if it is not readable."
  (let ((f (expand-file-name "banner.txt" toad/banner-dir)))
    (when (file-readable-p f)
      (split-string
       (with-temp-buffer (insert-file-contents f) (buffer-string)) "\n" t))))

(defun toad/banner--image (name height)
  "image NAME scaled to HEIGHT px, nil in a terminal or if the file is gone."
  (let ((f (expand-file-name name toad/banner-dir)))
    (when (and (display-graphic-p)
               (image-type-available-p 'png)
               (file-readable-p f))
      (ignore-errors (create-image f nil nil :height height)))))

(defun toad/banner--insert-image (img win-pw)
  "insert IMG centered in a window WIN-PW pixels wide."
  (let ((margin (max 0 (/ (- win-pw (car (image-size img t))) 2))))
    (insert (propertize " " 'display `(space :width (,margin)))
            (propertize " " 'display img)
            "\n")))

(defun toad/banner--pad (px)
  "insert PX pixels of vertical space."
  (when (> px 0)
    (let ((p (point)))
      (insert "\n")
      (put-text-property p (point) 'line-height px))))

(define-derived-mode toad/banner-mode special-mode "Banner"
  "read-only buffer holding the banner. `q' buries it."
  (setq-local cursor-type nil
              mode-line-format nil
              display-line-numbers nil
              truncate-lines t)
  (buffer-disable-undo))

(defun toad/banner-render ()
  "draw the banner centered for the selected window, and return its buffer."
  (let* ((win     (selected-window))
         (win-pw  (window-pixel-width win))
         (win-ph  (window-pixel-height win))
         (img-h   (max 1 (round (* win-ph toad/banner-image-scale))))
         (freedom (toad/banner--image "freedom.png" img-h))
         (gnu     (toad/banner--image "gnu.png" img-h))
         (lines   (toad/banner--art))
         (art-w   (if lines (apply #'max (mapcar #'string-width lines)) 0))
         (used    (+ (* (length lines) (frame-char-height (window-frame win)))
                     (if freedom img-h 0)
                     (if gnu img-h 0)))
         (v-pad   (max 0 (/ (- win-ph used) 2)))
         (h-pad   (max 0 (/ (- (window-body-width win) art-w) 2)))
         (buf     (get-buffer-create "*banner*")))
    (with-current-buffer buf
      (unless (derived-mode-p 'toad/banner-mode) (toad/banner-mode))
      (let ((inhibit-read-only t))
        (erase-buffer)
        (toad/banner--pad v-pad)
        (when freedom (toad/banner--insert-image freedom win-pw))
        (dolist (line lines)
          (insert (make-string h-pad ?\s) line "\n"))
        (when gnu (toad/banner--insert-image gnu win-pw))
        (toad/banner--pad v-pad))
      (goto-char (point-min)))
    buf))

;; a missing banner must not prevent startup.
(setq initial-buffer-choice
      (lambda ()
        (condition-case err
            (toad/banner-render)
          (error (message "banner failed to render: %S" err)
                 (get-buffer-create "*scratch*")))))

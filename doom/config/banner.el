;;; config/banner.el -*- lexical-binding: t; -*-

;; The startup banner: freedom.png on top, ascii art in the middle, gnu.png
;; below, the whole stack centered in the window.
;;
;; M-x banner (or open-banner / show-banner) brings it back any time.

(defvar toad/banner-dir (expand-file-name "config/banner/" doom-user-dir))
(defvar toad/banner-buffer "*banner*")
(defvar toad/banner-image-scale 0.28
  "Height of each image as a fraction of the window height.
Scales with the window instead of the old hardcoded 320/280 pixels, so
the banner keeps its proportions on any monitor.")

(defun toad/banner--file (name)
  (expand-file-name name toad/banner-dir))

(defun toad/banner--art ()
  "The ascii art as a list of lines, or nil if banner.txt is unreadable."
  (let ((f (toad/banner--file "banner.txt")))
    (when (file-readable-p f)
      (split-string
       (with-temp-buffer (insert-file-contents f) (buffer-string))
       "\n" t))))

(defun toad/banner--image (name height)
  "Image NAME scaled to HEIGHT pixels, or nil if it can't be displayed.
Returns nil rather than signalling in a terminal frame, without image
support, or with the file missing — the banner degrades to plain ascii."
  (let ((f (toad/banner--file name)))
    (when (and (display-graphic-p)
               (image-type-available-p 'png)
               (file-readable-p f))
      (ignore-errors (create-image f nil nil :height height)))))

(defun toad/banner--insert-image (img win-pw)
  "Insert IMG horizontally centered in a window WIN-PW pixels wide."
  (let* ((w (car (image-size img t)))
         (margin (max 0 (/ (- win-pw w) 2))))
    (insert (propertize " " 'display `(space :width (,margin)))
            (propertize " " 'display img)
            "\n")))

(defun toad/banner-render (&optional window)
  "Draw the banner into `toad/banner-buffer', centered for WINDOW.
Re-run this whenever the window changes size; all the padding is
computed from WINDOW's current dimensions rather than cached."
  (let* ((window (or window
                     (get-buffer-window toad/banner-buffer)
                     (selected-window)))
         (win-ph  (window-pixel-height window))
         (win-pw  (window-pixel-width window))
         (win-w   (window-body-width window))
         (char-h  (frame-char-height (window-frame window)))
         (lines   (toad/banner--art))
         (art-w   (if lines (apply #'max (mapcar #'string-width lines)) 0))
         (art-ph  (* (length lines) char-h))
         (img-h   (max 1 (round (* win-ph toad/banner-image-scale))))
         (freedom (toad/banner--image "freedom.png" img-h))
         (gnu     (toad/banner--image "gnu.png" img-h))
         (used    (+ art-ph (if freedom img-h 0) (if gnu img-h 0)))
         (v-pad   (max 0 (/ (- win-ph used) 2)))
         (h-pad   (max 0 (/ (- win-w art-w) 2))))
    (with-current-buffer (get-buffer-create toad/banner-buffer)
      (let ((inhibit-read-only t))
        (erase-buffer)
        (when (> v-pad 0)
          (let ((p (point)))
            (insert "\n")
            (put-text-property p (point) 'line-height v-pad)))
        (when freedom (toad/banner--insert-image freedom win-pw))
        (dolist (line lines)
          (insert (make-string h-pad ?\s) line "\n"))
        (when gnu (toad/banner--insert-image gnu win-pw))
        (when (> v-pad 0)
          (let ((p (point)))
            (insert "\n")
            (put-text-property p (point) 'line-height v-pad))))
      (goto-char (point-min))
      (current-buffer))))

(define-derived-mode toad/banner-mode special-mode "Banner"
  "Read-only buffer holding the banner. `q' buries it."
  (setq-local cursor-type nil
              mode-line-format nil
              display-line-numbers nil
              truncate-lines t)
  (buffer-disable-undo))

;;;###autoload
(defun banner ()
  "Show the banner, centered for the window it lands in."
  (interactive)
  (let ((buf (get-buffer-create toad/banner-buffer)))
    (with-current-buffer buf
      (unless (derived-mode-p 'toad/banner-mode) (toad/banner-mode)))
    ;; select first, render second: the padding needs the real window size.
    (pop-to-buffer-same-window buf)
    (toad/banner-render (selected-window))
    (goto-char (point-min))))

(defalias 'open-banner 'banner)
(defalias 'show-banner 'banner)

(defun toad/banner--on-resize (frame)
  "Re-center the banner when its window changes size."
  (dolist (win (window-list frame 'no-minibuf))
    (when (eq (window-buffer win) (get-buffer toad/banner-buffer))
      (with-demoted-errors "banner: %S" (toad/banner-render win)))))

(add-hook 'window-size-change-functions #'toad/banner--on-resize)

;; `initial-buffer-choice' must return a buffer and must never signal, or
;; Emacs comes up with no window at all. Fall back to scratch if anything
;; about the banner is broken.
(setq initial-buffer-choice
      (lambda ()
        (condition-case err
            (let ((buf (get-buffer-create toad/banner-buffer)))
              (with-current-buffer buf
                (unless (derived-mode-p 'toad/banner-mode) (toad/banner-mode)))
              (toad/banner-render)
              buf)
          (error (message "banner failed to render: %S" err)
                 (get-buffer-create "*scratch*")))))

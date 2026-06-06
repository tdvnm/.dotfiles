;;; config/banner.el -*- lexical-binding: t; -*-

(defun my/open-banner ()
  (let* ((lines     (split-string (with-temp-buffer
                                    (insert-file-contents (expand-file-name "config/banner/banner.txt" doom-user-dir))
                                    (buffer-string)) "\n" t))
         (art-h     (length lines))
         (art-w     (apply #'max (mapcar #'length lines)))
         (win-ph    (window-pixel-height))
         (win-pw    (window-pixel-width))
         (win-w     (window-total-width))
         (lh        (frame-char-height))
         (art-ph    (* art-h lh))
         (freedom-h 320)
         (gnu-h     280)
         (v-pad-px  (max 0 (/ (- win-ph freedom-h art-ph gnu-h) 2)))
         (h-pad     (max 0 (/ (- win-w art-w) 2)))
         ;; centered image helper
         (center-img (lambda (img)
                       (let* ((w      (car (image-size img t)))
                              (margin (max 0 (/ (- win-pw w) 2))))
                         (insert (propertize " " 'display `(space :width (,margin)))
                                 (propertize " " 'display img)
                                 "\n"))))
         (freedom-img (create-image (expand-file-name "config/banner/freedom.png" doom-user-dir) nil nil :height freedom-h))
         (gnu-img     (create-image (expand-file-name "config/banner/gnu.png"     doom-user-dir) nil nil :height gnu-h))
         (buf         (get-buffer-create "*banner*")))
    (with-current-buffer buf
      (erase-buffer)
      ;; top padding
      (let ((p (point)))
        (insert "\n")
        (put-text-property p (point) 'line-height v-pad-px))
      ;; freedom.png centered at top
      (funcall center-img freedom-img)
      ;; ascii art centered
      (dolist (line lines)
        (insert (make-string h-pad ?\s) line "\n"))
      ;; gnu.png centered below
      (funcall center-img gnu-img)
      ;; bottom padding
      (let ((p (point)))
        (insert "\n")
        (put-text-property p (point) 'line-height v-pad-px))
      (goto-char (point-min))
      (read-only-mode 1))
    buf))

(setq initial-buffer-choice #'my/open-banner)

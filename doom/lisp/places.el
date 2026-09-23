;;; lisp/places.el -*- lexical-binding: t; -*-

(defconst toad/places
  `(("org"    . "~/org/")
    ("code"   . "~/code/")
    ("config" . ,doom-user-dir)
    ("krea"   . "~/krea/")
    ("misc"   . "~/"))
  "workspace name to root directory. the order sets SPC TAB 1 2 3 4 5.")

(defun toad/place-root (name)
  "expanded root of the place called NAME, or nil when there is no such place."
  (when-let* ((root (cdr (assoc name toad/places))))
    (toad/dir root)))

(defun toad/place-containing (path)
  "the most specific place containing PATH, or nil when none does.
this keeps the catch-all `misc' place from claiming projects that belong to
`org', `code', `config', or `krea'."
  (let (winner winner-length)
    (pcase-dolist (`(,name . ,_) toad/places)
      (let ((root (toad/place-root name)))
        (when (and (toad/under-p path root)
                   (> (length root) (or winner-length -1)))
          (setq winner name
                winner-length (length root)))))
    winner))

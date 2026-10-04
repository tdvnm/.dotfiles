;;; lisp/lib.el -*- lexical-binding: t; -*-

;;; paths

(defun toad/dir (path)
  "PATH as an absolute directory name, with a trailing slash."
  (file-name-as-directory (expand-file-name path)))

(defun toad/under-p (file dir)
  "non-nil when FILE sits inside DIR."
  (and file dir
       (file-in-directory-p (expand-file-name file) (toad/dir dir))))

;;; places

(defconst toad/places
  `(("org"    . "~/org/")
    ("code"   . "~/code/")
    ("config" . ,doom-user-dir)
    ("krea"   . "~/krea/")
    ("misc"   . "~/"))
  "workspace name to root directory. the order sets SPC TAB 1 2 3 4 5.")

(defun toad/place-root (name)
  "expanded root of the place NAME, or nil."
  (when-let* ((root (cdr (assoc name toad/places))))
    (toad/dir root)))

(defun toad/place-containing (path)
  "the most specific place containing PATH, or nil."
  (let (winner winner-length)
    (pcase-dolist (`(,name . ,_) toad/places)
      (let ((root (toad/place-root name)))
        (when (and (toad/under-p path root)
                   (> (length root) (or winner-length -1)))
          (setq winner name
                winner-length (length root)))))
    winner))

;;; keys

;; the override map keeps evil from shadowing personal shortcuts.
(defun toad/bind-global (key command)
  "bind KEY to COMMAND in every mode and evil state."
  (general-define-key :keymaps 'override
                      :states '(nil normal motion visual insert emacs operator replace)
                      key command))

(defun toad/keys ()
  "open the readme at its keys section."
  (interactive)
  (find-file (expand-file-name "README.md" doom-user-dir))
  (widen)
  (goto-char (point-min))
  (when (search-forward "## Keys" nil t)
    (beginning-of-line))
  (recenter 0))

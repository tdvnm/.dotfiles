;;; lisp/lib.el -*- lexical-binding: t; -*-

(defun toad/dir (path)
  "PATH as an absolute directory name, with a trailing slash."
  (file-name-as-directory (expand-file-name path)))

(defun toad/under-p (file dir)
  "non-nil when FILE sits inside DIR."
  (and file dir
       (file-in-directory-p (expand-file-name file) (toad/dir dir))))

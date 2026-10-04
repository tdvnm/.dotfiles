;;; lisp/org/template.el -*- lexical-binding: t; -*-

(defun toad/org-seed ()
  "fill an empty file from its directory's template.org, else a plain header.
<name> becomes the filename."
  (let ((name (file-name-base buffer-file-name))
        (template (expand-file-name "template.org" (file-name-directory buffer-file-name))))
    (if (and (file-exists-p template) (not (equal name "template")))
        (let ((text (with-temp-buffer (insert-file-contents template) (buffer-string))))
          (setq text (replace-regexp-in-string "<name>" name text t t))
          (insert text)
          ;; read the #+ settings inserted after org initialized.
          (org-set-regexps-and-options)
          (goto-char (point-min))
          (re-search-forward "^\\*\\* TODO " nil t))
      (insert (format "#+TITLE: %s\n#+AUTHOR: %s\n#+DATE: %s\n\n"
                      name user-full-name (format-time-string "%Y-%m-%d"))))))

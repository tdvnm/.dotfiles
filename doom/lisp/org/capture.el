;;; lisp/org/capture.el -*- lexical-binding: t; -*-

(after! org-capture
  (setq org-capture-templates
        (append
         (mapcar (lambda (section)
                   (list (substring section 0 1) section 'entry
                         (list 'file+headline 'toad/org-agenda-file section)
                         "* TODO %?"))
                 '("agenda" "krea" "maint" "contact"))
         `(("n" "note" entry (file+headline toad/org-daily-file "motd")
            "* %<%H:%M> %?\n")
           ("l" "link" entry
            (file+headline ,(toad/org-file "library/links.org") "cool websites")
            "* [[%^{url}]]\n%^{description}" :immediate-finish t)))))

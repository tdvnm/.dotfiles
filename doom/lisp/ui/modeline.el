;;; lisp/ui/modeline.el -*- lexical-binding: t; -*-
(use-package! nyan-mode
  :init (nyan-mode 1)
  :config
  (setopt nyan-wavy-trail nil
          nyan-animation-frame-interval 0.5)
  (nyan-start-animation))

;; put the workspace name in the otherwise empty tab-bar slot.
(after! doom-modeline
  (setq doom-modeline-persp-name t)

  (pcase-let ((`(,lhs ,rhs) (alist-get 'main doom-modeline--modelines)))
    (doom-modeline-def-modeline 'main
      (mapcar (lambda (segment)
                (if (eq segment 'workspace-name) 'persp-name segment))
              lhs)
      (remq 'persp-name rhs))))

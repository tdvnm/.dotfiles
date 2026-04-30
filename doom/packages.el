;;; $DOOMDIR/packages.el -*- no-byte-compile: t; -*-

(package! org-modern)

(package! copilot
  :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el" "dist")))

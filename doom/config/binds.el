;;; config/binds.el -*- lexical-binding: t; -*-

;;; Evil command remaps
(evil-ex-define-cmd "q"  #'kill-current-buffer)
(evil-ex-define-cmd "bd" #'evil-quit)

;;; Global keybindings
(map! "M-[" #'centaur-tabs-backward
      "M-]" #'centaur-tabs-forward)

(map! :leader
      :desc "Find file in org" "o r" (cmd! (consult-find "~/org/")))

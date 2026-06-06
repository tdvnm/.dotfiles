;;; config/binds.el -*- lexical-binding: t; -*-

;; :q kills buffer, :bd closes window
(evil-ex-define-cmd "q"  #'kill-current-buffer)
(evil-ex-define-cmd "bd" #'evil-quit)


;; tab navigation
(map! "M-[" #'centaur-tabs-backward
      "M-]" #'centaur-tabs-forward)

(map! :leader
      :desc "Toggle vterm right" "o t" #'my/vterm-toggle
      :desc "Find file in org" "o r" (cmd! (consult-find "~/org/"))
      :desc "Search ripgrep" "s w" #'consult-ripgrep)

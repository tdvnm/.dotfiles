;;; config/binds.el -*- lexical-binding: t; -*-

;; :q kills buffer, :bd closes window
(evil-ex-define-cmd "q"  #'kill-current-buffer)
(evil-ex-define-cmd "bd" #'evil-quit)

;; tab navigation
(map! "M-[" #'centaur-tabs-backward
      "M-]" #'centaur-tabs-forward)

(map! :leader
      :desc "Toggle vterm popup" "o v" #'toad/vterm-toggle
      :desc "Browse org files"   "o r" #'browse-org
      :desc "Search org"         "o s" #'search-org
      :desc "RSS feed"           "o R" #'elfeed
      :desc "Search ripgrep"     "s w" #'consult-ripgrep
      :desc "DuckDuckGo search"  "s g" #'toad/ddg-search)

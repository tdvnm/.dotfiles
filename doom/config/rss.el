;;; config/rss.el -*- lexical-binding: t; -*-

(after! elfeed

  (setq elfeed-search-filter "@1-week-ago +unread")

  (map! :map elfeed-search-mode-map
        :n "1" (cmd! (elfeed-search-set-filter "@1-week-ago +unread +darknet"))
        :n "2" (cmd! (elfeed-search-set-filter "@1-week-ago +unread +law"))
        :n "3" (cmd! (elfeed-search-set-filter "@1-week-ago +unread +india"))
        :n "4" (cmd! (elfeed-search-set-filter "@1-week-ago +unread +cs"))
        :n "0" (cmd! (elfeed-search-set-filter "@1-week-ago +unread"))))

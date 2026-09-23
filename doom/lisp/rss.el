;;; lisp/rss.el -*- lexical-binding: t; -*-

(defconst toad/rss-file (expand-file-name "library/feeds.org" (toad/place-root "org"))
  "the feed list, filed with the other reading lists.")

(after! elfeed-org
  (setq rmh-elfeed-org-files (list toad/rss-file)))

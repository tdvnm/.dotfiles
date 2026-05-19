;;; config/treemacs.el -*- lexical-binding: t; -*-

(map! "M-d" #'treemacs
      "M-f" #'treemacs-select-window)

(setq treemacs-position 'right)
(setq treemacs-default-visit-action 'treemacs-visit-node-in-most-recently-used-window)

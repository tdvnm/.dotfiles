;;; config/org.el -*- lexical-binding: t; -*-

(setq org-directory "~/org/")
(setq +fold-ellipsis " 󱞣")
(setq org-agenda-files '("~/org/agenda/" "~/org/agenda/logs/"))

;; progressive org heading sizes (absolute heights)
 (custom-set-faces!
   '(org-level-1 :inherit outline-1 :height 1.1 :weight bold)
)

(add-hook 'org-mode-hook #'org-modern-mode)

(after! org-modern
  (setq org-modern-star 'replace
        org-modern-replace-stars '("" "󰫢" "◉" "○" "✸" )
        org-modern-priority '((?A . ""))
))

 (use-package! org-journal
   :defer t
   :config
   (setq org-journal-dir "~/org/journal/"
         org-journal-file-type 'weekly
         org-journal-date-format "%A, %d %B %Y"
         org-journal-file-format "W%V_%y_%B_%d.org"
         org-journal-time-format ""
         org-journal-date-prefix "#+TITLE: "
         org-journal-carryover-items nil)

   (defun org-journal-custom-template ()
     "Insert custom journal template after creating a new entry."
     (goto-char (point-max))
     (insert "\n* Main Quest\n\n* Side Quest\n\n* Learning\n\n* What to Do Better Tomorrow\n"))

(add-hook 'org-journal-after-header-create-hook #'org-journal-custom-template))

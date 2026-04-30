;;; config/org.el -*- lexical-binding: t; -*-

(setq org-directory "~/org/")

(after! org
  (setq org-ellipsis " ⋯")
  (add-hook 'org-mode-hook #'org-modern-mode)
  (add-hook 'org-mode-hook #'flyspell-mode)
  (add-hook 'org-mode-hook (lambda () (buffer-face-set '(:family "Monospace" :height 110))))
  (add-hook 'org-columns-mode-hook (lambda () (org-modern-mode -1)))
  (advice-add 'org-columns-quit :after (lambda (&rest _) (org-modern-mode 1)))

  (custom-set-faces!
    '(org-document-title        :foreground "#e8c49a" :weight bold :height 1.3)
    '(org-document-info         :foreground "#c9b07a")
    '(org-document-info-keyword :foreground "#8a7a5a")
    '(org-column                :inherit default :box nil)
    '(org-column-title          :inherit default :box nil :weight bold)
    '(org-headline-done         :foreground "#8fa0a5")))

(after! org-modern
  (setq org-modern-star 'replace
        org-modern-replace-stars '("✸" "◉" "○" "✿" "")
        org-modern-fold-stars nil
        org-modern-todo-faces
        '(("TO_WATCH" . (:background "#89b4fa" :foreground "#1e1e2e" :distant-foreground "#cdd6f4"))
          ("WATCHING" . (:background "#f9e2af" :foreground "#1e1e2e" :weight bold :distant-foreground "#cdd6f4"))
          ("WATCHED"  . (:background "#a6e3a1" :foreground "#1e1e2e" :distant-foreground "#cdd6f4"))))

  (custom-set-faces!
    '(org-modern-tag :background "#0e1a2e" :foreground "#c8d8f0"
                     :box (:line-width (1 . -1) :color "#1e3a5f")
                     :height 0.7)))

;; Company mode completion for org files
(set-company-backend! 'org-mode '(company-dabbrev company-ispell company-files))

;; ORG-JOURNAL
(use-package! org-journal
  :init
  (setq org-journal-dir "~/org/journal/"
        org-journal-file-format "%Y_%m_%d.org"
        org-journal-date-format "%A, %B %d, %Y"
        org-journal-enable-agenda-integration t
        org-journal-carryover-items "TODO=\"TODO\"|TODO=\"WAITING\"")
  :config
  (setq org-journal-file-type 'daily
        org-journal-file-header (lambda (time)
          (concat
            (format "#+TITLE: %s\n\n"
                    (format-time-string "%A, %B %d, %Y" time))
            "* today\n** TODO  \n** TODO  \n** TODO \n\n"
            "* what to do tomorrow \n\n"
            "* How was my day?\n\n"))))

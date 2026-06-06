;;; config/org.el -*- lexical-binding: t; -*-

(setq org-directory "~/org/")
(setq +fold-ellipsis " 󱞣")
(setq org-agenda-files '("~/org/agenda/" "~/org/agenda/tracker/"))

;; progressive org heading sizes (absolute heights)
(custom-set-faces!
  '(org-level-1 :inherit outline-1 :height 1.15 :weight bold))

(add-hook 'org-mode-hook #'org-modern-mode)

(after! org-modern
  (setq org-modern-star 'replace
        org-modern-replace-stars '("" "󰫢" "◉" "○" "✸" )
        org-modern-todo nil
        org-modern-keyword nil
))

(defun add-film-property ()
  "Insert a new film entry with TIER, RELEASE, and DIRECTOR properties."
  (interactive)
  (let* ((name (read-string "film: "))
         (tier (completing-read "tier: " '("S" "A" "B" "C" "D")))
         (release (read-string "release year: "))
         (director (read-string "director: ")))
    (insert (format "*** TODO %s\n:PROPERTIES:\n:TIER:     %s\n:RELEASE:  %s\n"
                    name tier release))
    (when (not (string-empty-p director))
      (insert (format ":DIRECTOR: %s\n" director)))
    (insert ":END:\n")))

;; base16-gumball-theme.el -- dark counterpart to bubblegum
;; Author: toad

;;; Code:

(require 'base16-theme)

(defvar base16-gumball-theme-colors
  '(:base00 "#1a1218"    ; bg — dark plum
    :base01 "#2a2028"    ; lighter bg — dark mauve
    :base02 "#3d2d38"    ; selection — dusty plum
    :base03 "#7a5a6a"    ; comments — muted mauve
    :base04 "#9a7888"    ; dark fg — faded rose
    :base05 "#d4b8c8"    ; fg — pale pink
    :base06 "#e8d0dc"    ; lighter fg — soft blush
    :base07 "#f5e8ef"    ; lightest fg — pink-white
    :base08 "#f03878"
    :base09 "#d47098"
    :base0A "#d050e0"
    :base0B "#10d4b0"
    :base0C "#00c8b0"
    :base0D "#00b8d4"
    :base0E "#f848b8"
    :base0F "#d83870")
  "All colors for Base16 Gumball are defined here.")

(deftheme base16-gumball)

(base16-theme-define 'base16-gumball base16-gumball-theme-colors)

;; override org-level-3 to use base09
(custom-theme-set-faces
 'base16-gumball
 '(org-level-3 ((t (:foreground "#d47098" :bold t)))))

(provide-theme 'base16-gumball)

(provide 'base16-gumball-theme)

;;; base16-gumball-theme.el ends here

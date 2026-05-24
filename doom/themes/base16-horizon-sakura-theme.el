;; base16-horizon-sakura-theme.el -- A custom base16 colorscheme
;; Combines Horizon's neon pinks/greens with Sakura's contrast and readability.

;;; Code:

(require 'base16-theme)

(defvar base16-horizon-sakura-theme-colors
  '(:base00 "#feedf3"    ; bg — sakura's warm pink-white (readable)
    :base01 "#f8e2e7"    ; lighter bg — sakura
    :base02 "#e0ccd1"    ; selection — sakura
    :base03 "#a08a8f"    ; comments — lighter, clearly distinct from code
    :base04 "#665055"    ; dark fg — sakura
    :base05 "#564448"    ; fg — sakura (high contrast on light bg)
    :base06 "#42383a"    ; darker fg — sakura
    :base07 "#33292b"    ; darkest fg — sakura
    :base08 "#e95678"    ; keywords/errors — horizon neon pink
    :base09 "#f6661e"    ; constants — sakura orange (readable)
    :base0A "#c29461"    ; types — sakura amber (readable)
    :base0B "#1aab7a"    ; strings/success — darker neon green
    :base0C "#3abcbe"    ; builtins/cyan — darker neon cyan
    :base0D "#1a9ab8"    ; functions — darker neon blue
    :base0E "#ee64ac"    ; keywords/purple — horizon neon magenta
    :base0F "#ba0d35")   ; misc — sakura deep red (readable)
  "All colors for Base16 Horizon Sakura are defined here.")

(deftheme base16-horizon-sakura)

(base16-theme-define 'base16-horizon-sakura base16-horizon-sakura-theme-colors)

(provide-theme 'base16-horizon-sakura)

(provide 'base16-horizon-sakura-theme)

;;; base16-horizon-sakura-theme.el ends here

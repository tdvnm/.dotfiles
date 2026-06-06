;; base16-bubblegum-theme.el -- A custom base16 colorscheme
;; Author: toad

;;; Code:

(require 'base16-theme)

(defvar base16-bubblegum-theme-colors
  '(:base00 "#feedf3"    ; bg — sakura's warm pink-white (readable)
    :base01 "#f8e2e7"    ; lighter bg — sakura
    :base02 "#e0ccd1"    ; selection — sakura
    :base03 "#a8889a"    ; comments — soft pink-mauve
    :base04 "#6a4e60"    ; dark fg — dusty rose
    :base05 "#5c4250"    ; fg — plum (high contrast on light bg)
    :base06 "#463840"    ; darker fg — dark mauve
    :base07 "#352930"    ; darkest fg — deep plum
    :base08 "#f03090"    ; keywords/errors — neon fuchsia
    :base09 "#c86880"    ; constants — blush rose
    :base0A "#d048a0"    ; types — vivid pink
    :base0B "#08c7a4"    ; strings/success — teal mint
    :base0C "#00a8b8"    ; builtins/cyan — electric teal
    :base0D "#00b0b8"    ; functions — teal cyan
    :base0E "#f030a8"    ; keywords/purple — hot magenta
    :base0F "#982058")   ; misc — deep berry
  "All colors for Base16 Bubblegum are defined here.")

(deftheme base16-bubblegum)

(base16-theme-define 'base16-bubblegum base16-bubblegum-theme-colors)

(provide-theme 'base16-bubblegum)

(provide 'base16-bubblegum-theme)

;;; base16-bubblegum-theme.el ends here

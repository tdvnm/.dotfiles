;;; base16-bubblegum-theme.el --- a pink/teal light theme for emacs -*- lexical-binding: t; -*-

;; Author: toad
;; Version: 0.1.0
;; Package-Requires: ((base16-theme "0"))
;; Keywords: faces themes

;;; Commentary:

;; keep the palette in one place for all generated faces.

;;; Code:

(require 'base16-theme)

(defconst base16-bubblegum-theme-colors
  '(:base00 "#feedf3"    ; bg, candy pink-white
    :base01 "#f8e2e7"    ; lighter bg, blush
    :base02 "#e0ccd1"    ; selection, petal
    :base03 "#d0a2b9"    ; comments, soft pink-mauve
    :base04 "#745268"    ; dark fg, dusty rose
    :base05 "#5c4250"    ; fg, plum
    :base06 "#463840"    ; darker fg, dark mauve
    :base07 "#352930"    ; darkest fg, deep plum
    :base08 "#ed286f"
    :base09 "#bf5e87"
    :base0A "#c13fd2"
    :base0B "#08c7a4"
    :base0C "#00b9a3"
    :base0D "#00a2b8"
    :base0E "#f030a8"
    :base0F "#cb2762")
  "All colors for Base16 Bubblegum are defined here.")

(deftheme base16-bubblegum)

;; declare first so base16's duplicate cannot override it.
(custom-theme-set-faces
 'base16-bubblegum
 '(region ((t (:background unspecified :foreground unspecified :inverse-video t)))))
(base16-theme-define 'base16-bubblegum base16-bubblegum-theme-colors)

(provide-theme 'base16-bubblegum)

(provide 'base16-bubblegum-theme)

;;; base16-bubblegum-theme.el ends here

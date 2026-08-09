;;; base16-bubblegum-theme.el --- a pink/teal light theme for emacs -*- lexical-binding: t; -*-

;; Author: toad
;; Version: 0.1.0
;; Package-Requires: ((base16-theme "0"))
;; URL: https://github.com/YOURUSER/base16-bubblegum-theme
;; Keywords: faces themes

;;; Commentary:

;; a custom base16 colorscheme — candy pink backgrounds with
;; teal, mauve, and hot pink accents.  includes a dark variant
;; called gumball.

;;; Code:

(require 'base16-theme)

(defvar base16-bubblegum-theme-colors
  '(:base00 "#feedf3"    ; bg — candy pink-white
    :base01 "#f8e2e7"    ; lighter bg — blush
    :base02 "#e0ccd1"    ; selection — petal
    :base03 "#d0a2b9"    ; comments — soft pink-mauve
    :base04 "#745268"    ; dark fg — dusty rose
    :base05 "#5c4250"    ; fg — plum
    :base06 "#463840"    ; darker fg — dark mauve
    :base07 "#352930"    ; darkest fg — deep plum
    :base08 "#ed286f"    ; variables, XML tags, markup link text, ordered lists, diff deleted
    :base09 "#bf5e87"    ; integers, booleans, constants, XML attributes, markup link URL
    :base0A "#c13fd2"    ; classes, markup bold, search text background
    :base0B "#08c7a4"    ; strings, inherited class, markup code, diff inserted
    :base0C "#00b9a3"    ; support, regex, escape chars, markup quotes
    :base0D "#00a2b8"    ; functions, methods, attribute IDs, headings
    :base0E "#f030a8"    ; keywords, storage, selector, markup italic, diff changed
    :base0F "#cb2762")
  "All colors for Base16 Bubblegum are defined here.")

(deftheme base16-bubblegum)

(base16-theme-define 'base16-bubblegum base16-bubblegum-theme-colors)

;; override org-level-3 to use base09
(custom-theme-set-faces
 'base16-bubblegum
 '(org-level-3 ((t (:foreground "#bf5e87" :bold t)))))

(provide-theme 'base16-bubblegum)

(provide 'base16-bubblegum-theme)

;;; base16-bubblegum-theme.el ends here

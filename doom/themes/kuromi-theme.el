;;; kuromi-theme.el --- A dark theme inspired by Kuromi -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Author: toad
;; Inspired by: Sanrio's Kuromi character — deep purples, hot pinks, lavender
;;
;;; Commentary:
;;
;; A dark purple theme with Kuromi's signature black-and-purple aesthetic,
;; accented with hot pinks and soft lavenders.
;;
;;; Code:

(require 'doom-themes)
;;
;;; Variables

(defgroup kuromi-theme nil
  "Options for the `kuromi' theme."


 :group 'doom-themes)

(defcustom kuromi-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'kuromi-theme
  :type 'boolean)

(defcustom kuromi-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'kuromi-theme
  :type 'boolean)

(defcustom kuromi-comment-bg kuromi-brighter-comments
  "If non-nil, comments will have a subtle highlight to enhance their
legibility."
  :group 'kuromi-theme
  :type 'boolean)

(defcustom kuromi-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line.
Can be an integer to determine the exact padding."
  :group 'kuromi-theme
  :type '(choice integer boolean))


;;
;;; Theme definition

(def-doom-theme kuromi
  "A dark theme inspired by Kuromi — deep purples, hot pinks, lavender."
  :family 'kuromi
  :background-mode 'dark

  ;; name        default   256           16
  ((bg         '("#1a1228" "black"       "black"        ))
   (fg         '("#e0d0f0" "#dfdfdf"     "brightwhite"  ))

   (bg-alt     '("#130d1f" "black"       "black"        ))
   (fg-alt     '("#7a6399" "#6b6b6b"     "white"        ))

   ;; base spectrum: deep purple-black → soft lavender white
   (base0      '("#0e0818" "black"       "black"        ))
   (base1      '("#130d1f" "#1e1e1e"     "brightblack"  ))
   (base2      '("#1a1228" "#2e2e2e"     "brightblack"  ))
   (base3      '("#1f1630" "#262626"     "brightblack"  ))
   (base4      '("#3d2e52" "#3f3f3f"     "brightblack"  ))
   (base5      '("#5c4a78" "#525252"     "brightblack"  ))
   (base6      '("#7a6399" "#6b6b6b"     "brightblack"  ))
   (base7      '("#a68db5" "#979797"     "brightblack"  ))
   (base8      '("#e0d0f0" "#dfdfdf"     "white"        ))

   (grey        base4)
   (red        '("#ff6b9d" "#ff6699" "red"          )) ; hot pink-red
   (orange     '("#e8956d" "#dd8844" "brightred"    )) ; soft peach-orange
   (green      '("#a0c8a0" "#99bb66" "green"        )) ; muted sage
   (teal       '("#5ecfcf" "#44b9b1" "brightgreen"  )) ; soft teal
   (yellow     '("#f0d080" "#ECBE7B" "yellow"       )) ; soft gold
   (blue       '("#9999ff" "#9999ff" "brightblue"   )) ; periwinkle
   (dark-blue  '("#4433aa" "#4433aa" "blue"         )) ; deep indigo
   (magenta    '("#d966ff" "#cc66ff" "brightmagenta")) ; vivid Kuromi purple
   (violet     '("#c0a0ff" "#c0a0ff" "magenta"      )) ; soft lavender
   (cyan       '("#88ddff" "#88ddff" "brightcyan"   )) ; light sky blue
   (dark-cyan  '("#5599cc" "#5599cc" "cyan"         )) ; steel blue

   (highlight      magenta)
   (vertical-bar   (doom-darken base1 0.1))
   (selection      dark-blue)
   (builtin        violet)
   (comments       (if kuromi-brighter-comments dark-cyan base5))
   (doc-comments   (doom-lighten (if kuromi-brighter-comments dark-cyan base5) 0.25))
   (constants      cyan)
   (functions      magenta)
   (keywords       violet)
   (methods        blue)
   (operators      violet)
   (type           yellow)
   (strings        green)
   (variables      (doom-lighten magenta 0.35))
   (numbers        red)
   (region         `(,(doom-lighten (car bg-alt) 0.12) ,@(doom-lighten (cdr base1) 0.30)))
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    orange)
   (vc-added       green)
   (vc-deleted     red)

   (modeline-fg              fg)
   (modeline-fg-alt          base5)
   (modeline-bg              (if kuromi-brighter-modeline
                                 (doom-darken magenta 0.5)
                               (doom-darken bg-alt 0.1)))
   (modeline-bg-alt          (if kuromi-brighter-modeline
                                 (doom-darken magenta 0.525)
                               `(,(doom-darken (car bg-alt) 0.15) ,@(cdr bg))))
   (modeline-bg-inactive     `(,(car bg-alt) ,@(cdr base1)))
   (modeline-bg-inactive-alt `(,(doom-darken (car bg-alt) 0.1) ,@(cdr bg)))

   (-modeline-pad
    (when kuromi-padded-modeline
      (if (integerp kuromi-padded-modeline) kuromi-padded-modeline 4))))


  ;;;; Base theme face overrides
  (((line-number &override) :foreground base4)
   ((line-number-current-line &override) :foreground fg)
   ((font-lock-comment-face &override)
    :background (if kuromi-comment-bg (doom-lighten bg 0.04) 'unspecified))
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis :foreground (if kuromi-brighter-modeline base8 highlight))

   ;;;; css-mode <built-in> / scss-mode
   (css-proprietary-property :foreground red)
   (css-property             :foreground green)
   (css-selector             :foreground magenta)
   ;;;; doom-modeline
   (doom-modeline-bar :background (if kuromi-brighter-modeline modeline-bg highlight))
   (doom-modeline-buffer-file :inherit 'mode-line-buffer-id :weight 'bold)
   (doom-modeline-buffer-path :inherit 'mode-line-emphasis :weight 'bold)
   (doom-modeline-buffer-project-root :foreground violet :weight 'bold)
   ;;;; ivy
   (ivy-current-match :background dark-blue :distant-foreground base0 :weight 'normal)
   ;;;; LaTeX-mode
   (font-latex-math-face :foreground cyan)
   ;;;; markdown-mode
   (markdown-markup-face :foreground base5)
   (markdown-header-face :inherit 'bold :foreground magenta)
   ((markdown-code-face &override) :background (doom-lighten base3 0.04))
   ;;;; rjsx-mode
   (rjsx-tag :foreground red)
   (rjsx-attr :foreground orange)
   ;;;; solaire-mode
   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-alt)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-inactive-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-alt))))

  ;;;; Base theme variable overrides
  ())

;;; kuromi-theme.el ends here

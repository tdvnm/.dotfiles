;;; $DOOMDIR/init.el -*- lexical-binding: t; -*-

;; Run `doom sync' after changing modules.

(doom!
 :completion
 (corfu +orderless +icons +dabbrev)
 vertico

 :ui
 doom
 hl-todo
 modeline
 (popup +defaults)
 tabs
 (vc-gutter +pretty)
 workspaces

 :editor
 (evil +everywhere)
 format

 :emacs
 (dired +dirvish +icons)
 (undo +tree)

 :checkers
 (syntax +icons)

 :tools
 lsp
 lookup
 magit
 make
 (pass +auth)
 pdf
 tree-sitter

 :lang
 (cc +lsp +tree-sitter)
 (python +tree-sitter)
 emacs-lisp
 (javascript +lsp +tree-sitter)
 (latex +fold +lsp)
 (lua +tree-sitter)
 markdown
 nix
 (org +dragndrop)
 sh
 (web +lsp)

 :app
 (rss +org)

 :config
 (default +bindings +smartparens))

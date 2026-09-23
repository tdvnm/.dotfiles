;;; $DOOMDIR/init.el -*- lexical-binding: t; -*-

;; Enabled modules are kept together at the top. Run `doom sync' after
;; changing this block.

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

;; Available modules
;;
;; These are intentionally outside the active `doom!' block. To enable one,
;; copy its line into the matching section above, remove `;;', then run
;; `doom sync'. Put point on a module or flag and press K to read its docs.
;;
;; :input
;; bidi              ; (tfel ot) thgir etirw uoy gnipleh
;; chinese
;; japanese
;; layout            ; auie,ctsrnm is the superior home row
;;
;; :completion
;; company           ; the ultimate code completion backend
;; helm              ; the *other* search engine for love and life
;; ido               ; the other *other* search engine...
;; ivy               ; a search engine for love and life
;;
;; :ui
;; deft              ; notational velocity for Emacs
;; dashboard         ; a nifty splash screen for Emacs
;; doom-quit         ; DOOM quit-message prompts when you quit Emacs
;; (emoji +unicode)  ; 🙂
;; indent-guides     ; highlighted indent columns
;; ligatures         ; ligatures and symbols to make your code pretty again
;; minimap           ; show a map of the code on the side
;; nav-flash         ; blink cursor line after big motions
;; neotree           ; a project drawer, like NERDTree for vim
;; ophints           ; highlight the region an operation acts on
;; smooth-scroll     ; So smooth you won't believe it's not butter
;; unicode           ; extended unicode support for various languages
;; vi-tilde-fringe   ; fringe tildes to mark beyond EOB
;; window-select     ; visually switch windows
;; zen               ; distraction-free coding or writing
;;
;; :editor
;; file-templates    ; auto-snippets for empty files
;; fold              ; (nigh) universal code folding
;; god               ; run Emacs commands without modifier keys
;; lispy             ; vim for lisp, for people who don't like vim
;; multiple-cursors  ; editing in many places at once
;; objed             ; text object editing for the innocent
;; parinfer          ; turn lisp into python, sort of
;; rotate-text       ; cycle region at point between text candidates
;; snippets          ; my elves. They type so I don't have to
;; (whitespace +guess +trim) ; a butler for your whitespace
;; word-wrap         ; soft wrapping with language-aware indent
;;
;; :emacs
;; electric          ; smarter, keyword-based electric-indent
;; eww               ; the internet is gross
;; ibuffer           ; interactive buffer management
;; tramp             ; remote files at your arthritic fingertips
;; vc                ; version-control and Emacs, sitting in a tree
;;
;; :term
;; eshell            ; the elisp shell that works everywhere
;; shell             ; simple shell REPL for Emacs
;; term              ; basic terminal emulator for Emacs
;; vterm             ; almost the best terminal emulation in Emacs
;; ghostel           ; the best terminal emulation in Emacs
;;
;; :checkers
;; (spell +flyspell) ; tasing you for misspelling mispelling
;; grammar           ; tasing grammar mistake every you make
;;
;; :tools
;; ansible
;; biblio            ; Writes a PhD for you (citation needed)
;; collab            ; buffers with friends
;; debugger          ; stepping through code, to help you add bugs
;; direnv
;; docker
;; editorconfig      ; let someone else argue about tabs vs spaces
;; ein               ; tame Jupyter notebooks in Emacs
;; (eval +overlay)   ; run code, run (also, repls)
;; llm               ; when I said you needed friends, I didn't mean...
;; terraform         ; infrastructure as code
;; tmux              ; an API for interacting with tmux
;; upload            ; map local to remote projects via ssh/ftp
;;
;; :os
;; (:if (featurep :system 'macos) macos) ; improve macOS compatibility
;; tty               ; improve the terminal Emacs experience
;;
;; :lang
;; ada               ; In strong typing we (blindly) trust
;; (agda +local)     ; types of types of types of types...
;; beancount         ; mind the GAAP
;; clojure           ; java with a lisp
;; common-lisp       ; if you've seen one lisp, you've seen them all
;; coq               ; proofs-as-programs
;; crystal           ; ruby at the speed of c
;; csharp            ; unity, .NET, and mono shenanigans
;; data              ; config/data formats
;; (dart +flutter)   ; paint ui and not much else
;; dhall
;; elixir            ; erlang done right
;; elm               ; care for a cup of TEA?
;; erlang            ; an elegant language for a more civilized age
;; ess               ; emacs speaks statistics
;; factor
;; faust             ; dsp, but you get to keep your soul
;; fortran           ; in FORTRAN, GOD is REAL (unless declared INTEGER)
;; fsharp            ; ML stands for Microsoft's Language
;; fstar             ; dependent types and Z3
;; gdscript          ; the language you waited for
;; (go +lsp)         ; the hipster dialect
;; (graphql +lsp)    ; Give queries a REST
;; (haskell +lsp)    ; a language that's lazier than I am
;; hy                ; readability of scheme with the speed of python
;; idris             ; a language you can depend on
;; json              ; At least it ain't XML
;; janet             ; Fun fact: Janet is me!
;; (java +lsp)       ; the poster child for carpal tunnel syndrome
;; julia             ; a better, faster MATLAB
;; kotlin            ; a better, slicker Java(Script)
;; lean              ; for folks with too much to prove
;; ledger            ; be audit you can be
;; nim               ; python + lisp at the speed of c
;; ocaml             ; an objective camel
;; odin              ; C, minus its footguns
;; php               ; perl's insecure younger brother
;; plantuml          ; diagrams for confusing people more
;; graphviz          ; diagrams for confusing yourself even more
;; purescript        ; javascript, but functional
;; qt                ; the cutest GUI framework
;; racket            ; a DSL for DSLs
;; raku              ; the artist formerly known as perl6
;; rest              ; Emacs as a REST client
;; rst               ; ReST in peace
;; (ruby +rails)     ; 1.step {|i| p i}
;; (rust +lsp)       ; Fe2O3.unwrap().unwrap().unwrap()
;; scad              ; trust the preview, regret the render
;; scala             ; java, but good
;; (scheme +guile)   ; a fully conniving family of lisps
;; sml
;; solidity          ; do you need a blockchain? No.
;; swift             ; who asked for emoji variables?
;; terra             ; Earth and Moon in alignment for performance
;; yaml              ; JSON, but readable
;; zig               ; C, but simpler
;;
;; :email
;; (mu4e +org +gmail)
;; notmuch
;; (wanderlust +gmail)
;;
;; :app
;; calendar
;; emms
;; everywhere        ; leave Emacs!? You must be joking
;; irc               ; how neckbeards socialize
;;
;; :config
;; literate

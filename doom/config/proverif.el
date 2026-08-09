;;; config/proverif.el -*- lexical-binding: t; -*-

;; .pv/.pvl/.pcv files. the language server is the one from the vscode
;; extension, unbundled to ~/.local/share/proverif-lsp/server.js — it is plain
;; node with no vscode dependency. diagnostics come from the `proverif' binary
;; on PATH (nixpkgs proverif). update steps: ~/.local/share/proverif-lsp/README.md
;;
;; if the server ever misbehaves, comment out the lsp-deferred hook at the
;; bottom — the major mode and its highlighting keep working on their own.

(defvar proverif-lsp-server-path
  (expand-file-name "~/.local/share/proverif-lsp/server.js"))

(defvar proverif-keywords
  '("among" "axiom" "channel" "choice" "clauses" "const" "def" "diff" "do"
    "elimtrue" "else" "equation" "equivalence" "event" "expand" "fail" "for"
    "forall" "foreach" "free" "fun" "get" "if" "implementation" "in"
    "inj-event" "insert" "lemma" "let" "letfun" "letproba" "new" "noninterf"
    "noselect" "not" "nounif" "or" "otherwise" "out" "param" "phase" "pred"
    "proba" "process" "proof" "public_vars" "putbegin" "query" "reduc"
    "restriction" "secret" "select" "set" "suchthat" "sync" "table" "then"
    "type" "weaksecret" "yield"))

(defvar proverif-builtins
  '("attacker" "block" "conclusion" "data" "decompData" "decompDataSelect"
    "discardSat" "discardVerif" "fullSat" "fullVerif" "hypothesis"
    "ignoreAFewTimes" "induction" "inductionOn" "instantiateSat"
    "instantiateVerif" "keepEvents" "maxSubset" "memberOptim" "mess"
    "noInduction" "noneSat" "noneVerif" "precise" "private" "proveAll"
    "pv_reachability" "pv_real_or_random" "reachability" "real_or_random"
    "removeEvents" "typeConverter"))

(defvar proverif-font-lock-keywords
  `((,(regexp-opt proverif-keywords 'words) . font-lock-keyword-face)
    (,(regexp-opt proverif-builtins 'words) . font-lock-builtin-face)
    ("||\\|&&\\|==>\\|<=>\\|<->\\|<-R\\|->\\|<-\\|<=\\|!"
     . font-lock-operator-face)))

(defvar proverif-mode-syntax-table
  (let ((table (make-syntax-table prog-mode-syntax-table)))
    ;; nestable (* *) comments, ocaml style
    (modify-syntax-entry ?\( "()1n" table)
    (modify-syntax-entry ?\) ")(4n" table)
    (modify-syntax-entry ?*  ". 23n" table)
    ;; _ and ' are identifier chars, so `new' does not match in `new_key'
    (modify-syntax-entry ?_  "w" table)
    (modify-syntax-entry ?'  "w" table)
    table))

(define-derived-mode proverif-mode prog-mode "ProVerif"
  "Major mode for ProVerif protocol specifications."
  :syntax-table proverif-mode-syntax-table
  (setq-local font-lock-defaults '(proverif-font-lock-keywords))
  (setq-local comment-start "(* ")
  (setq-local comment-end " *)")
  (setq-local comment-start-skip "(\\*+[ \t]*")
  ;; server sends semantic tokens; doom leaves this off globally
  (setq-local lsp-semantic-tokens-enable t))

(add-to-list 'auto-mode-alist '("\\.pv\\'"  . proverif-mode))
(add-to-list 'auto-mode-alist '("\\.pvl\\'" . proverif-mode))
(add-to-list 'auto-mode-alist '("\\.pcv\\'" . proverif-mode))

;; pulled by the server via workspace/configuration. parentFolderDiscoveryLimit
;; has no server-side default — omit it and cross-file references break.
(defvar lsp-proverif-binary "proverif")
(defvar lsp-proverif-parent-folder-discovery-limit 1)

(after! lsp-mode
  (add-to-list 'lsp-language-id-configuration '(proverif-mode . "pv"))

  (lsp-register-custom-settings
   '(("proverif.proverifPath" lsp-proverif-binary)
     ("proverif.parentFolderDiscoveryLimit"
      lsp-proverif-parent-folder-discovery-limit)))

  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection
                     (lambda ()
                       (list "node" proverif-lsp-server-path "--stdio"))
                     (lambda () (file-exists-p proverif-lsp-server-path)))
    :activation-fn (lsp-activate-on "pv")
    :server-id 'proverif-ls
    :initialized-fn
    (lambda (workspace)
      (with-lsp-workspace workspace
        (lsp--set-configuration (lsp-configuration-section "proverif")))))))

(add-hook 'proverif-mode-hook #'lsp-deferred)

(defun proverif-run ()
  "Run proverif on the current file."
  (interactive)
  (save-buffer)
  (compile (concat "proverif " (shell-quote-argument buffer-file-name))))

(map! :localleader
      :map proverif-mode-map
      "c" #'proverif-run)

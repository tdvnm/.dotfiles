;;; config/svelte.el -*- lexical-binding: t; -*-

;; .svelte files. The language server is `svelteserver', installed system-wide
;; from nixpkgs (nodePackages.svelte-language-server) — if M-x lsp says it
;; cannot find the binary, that package is missing from configuration.nix.

(use-package! svelte-mode
  :mode "\\.svelte\\'"
  :config
  ;; svelte-mode derives from html-mode, whose default 2-space offset matches
  ;; what prettier writes, so format-on-save and the editor agree.
  (setq svelte-basic-offset 2))

(after! lsp-mode
  ;; lsp-mode ships an :svelte-vls client but only registers `svelte-mode' as a
  ;; major mode it serves; without this it never starts in a .svelte buffer.
  (add-to-list 'lsp-language-id-configuration '(svelte-mode . "svelte")))

(add-hook 'svelte-mode-hook #'lsp-deferred)

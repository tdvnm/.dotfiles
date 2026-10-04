;;; lisp/proverif.el -*- lexical-binding: t; -*-
(defconst toad/proverif-dialects
  '(("\\.pv\\'"       proverif-pv-mode       "pitype")
    ("\\.pi\\'"       proverif-pi-mode       "pi")
    ("\\.horntype\\'" proverif-horntype-mode "horntype")
    ("\\.horn\\'"     proverif-horn-mode     "horn"))
  "file pattern, the mode proverif ships for it, and its -in format.
the four input languages proverif reads. the names differ on purpose:
a .pv file is the typed pi calculus, which proverif calls `pitype'.")

(defun toad/proverif-dialect ()
  "the -in format for this buffer, the typed pi calculus by default."
  (or (nth 2 (seq-find (lambda (row) (eq (nth 1 row) major-mode))
                       toad/proverif-dialects))
      "pitype"))

(defun toad/proverif--words ()
  "read this dialect's keywords and builtins from the installed mode tables."
  (let ((stem (string-remove-suffix "-mode" (symbol-name major-mode))))
    (cl-loop for kind in '("kw" "builtin")
             for sym = (intern-soft (format "%s-%s" stem kind))
             when (and sym (boundp sym)) append (symbol-value sym))))

(defun toad/proverif-capf ()
  "complete the proverif keyword at point.
allow other completion sources to supply user-defined names on a miss."
  (let ((bounds (or (bounds-of-thing-at-point 'symbol) (cons (point) (point)))))
    (list (car bounds) (cdr bounds) (toad/proverif--words) :exclusive 'no)))

(defun toad/proverif-prog-h ()
  "add comment commands, completion and prog hooks to the shipped mode.
it inherits from fundamental-mode, so prog hooks need to run explicitly."
  (setq-local comment-start "(* "
              comment-end " *)")
  (add-hook 'completion-at-point-functions #'toad/proverif-capf 10 t)
  (run-hooks 'prog-mode-hook))

;; the system profile puts proverif.el on the load path, without a provide form.
(when (locate-library "proverif")
  (pcase-dolist (`(,pattern ,mode ,_) toad/proverif-dialects)
    (autoload mode "proverif" "major mode for a proverif model." t)
    (add-to-list 'auto-mode-alist (cons pattern mode))
    (derived-mode-add-parents mode '(prog-mode))
    (add-hook (intern (format "%s-hook" mode)) #'toad/proverif-prog-h)))

;; saving should check syntax without running proofs.
(after! flycheck
  (flycheck-define-checker proverif
    "a proverif syntax and type checker, using proverif itself."
    :command ("proverif" "-parse-only"
              "-in" (eval (toad/proverif-dialect))
              source)
    :error-patterns
    ((error line-start "file \"" (file-name) "\", line " line
            ", character" (opt "s") " " column (opt "-" (+ digit)) ":\n"
            (opt "Error: ") (message (+ not-newline)) line-end))
    :modes (proverif-pv-mode proverif-pi-mode
            proverif-horn-mode proverif-horntype-mode))
  (add-to-list 'flycheck-checkers 'proverif))

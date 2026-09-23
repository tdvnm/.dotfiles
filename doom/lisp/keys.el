;;; lisp/keys.el -*- lexical-binding: t; -*-

(defun toad/keys ()
  "open the personal keybinding and workflow guide."
  (interactive)
  (find-file (expand-file-name "README.md" doom-user-dir))
  (widen)
  (goto-char (point-min))
  (when (search-forward "## Keys" nil t)
    (beginning-of-line))
  (recenter 0))

;; the override map keeps evil from shadowing personal shortcuts.
(defun toad/bind-global (key command)
  "reserve KEY for COMMAND across major modes and evil states.
ordinary mode and leader bindings should use `map!' directly."
  (keymap-global-set key command)
  (general-define-key :keymaps 'override
                      :states '(nil normal motion visual insert emacs operator replace)
                      key command))

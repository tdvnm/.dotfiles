;;; config/copilot.el -*- lexical-binding: t; -*-

(after! copilot
  (setq copilot-indent-offset-warning-disable t)

  (map! :map copilot-completion-map
        "<tab>" #'copilot-accept-completion
        "TAB"   #'copilot-accept-completion
        "C-f"   #'copilot-accept-completion-by-word)

  (add-hook 'prog-mode-hook #'copilot-mode))

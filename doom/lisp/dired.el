;;; lisp/dired.el -*- lexical-binding: t; -*-

;;; dired

;; hide dotfiles alongside doom's existing omit patterns.
(after! dired-x
  (unless (string-prefix-p "\\`\\.\\|" dired-omit-files)
    (setq dired-omit-files (concat "\\`\\.\\|" dired-omit-files))))

(after! dirvish-subtree
  (setopt dirvish-subtree-state-style 'plus))

;; restore file creation keys hidden by dirvish.
(after! dirvish
  (map! :map (dired-mode-map dirvish-mode-map)
        :n "N" #'dired-create-empty-file
        :n "+" #'dired-create-directory))

;;; drawer

(defconst toad/drawer-fixed-places '("org" "config")
  "places whose drawer always stays at the place root.")

(defvar toad/drawer-pins nil
  "workspace name to the directory pinned there with `.'.")

(defun toad/drawer-root ()
  "the drawer root: the pin, else the project inside this place, else the place."
  (let* ((name (+workspace-current-name))
         (place (toad/place-root name))
         (project (unless (member name toad/drawer-fixed-places)
                    (doom-project-root))))
    (toad/dir
     (cond ((alist-get name toad/drawer-pins nil nil #'equal))
           ((and project
                 (or (null place)
                     (equal name (toad/place-containing project))))
            project)
           (place)
           (project)
           (t default-directory)))))

;; auto-expand errors when the current file is outside the root.
(setq dirvish-side-auto-expand nil
      dirvish-side-width 45
      dirvish-side-display-alist '((side . right) (slot . 0))
      dirvish-side-attributes '(nerd-icons subtree-state)
      dirvish-side-mode-line-format '(:left (sort) :right (index)))

;; a workspace switch takes the drawer down, this says to redraw it.
(defvar toad/drawer-wanted nil
  "whether the drawer belongs on screen.")

(defun toad/drawer-window ()
  "the window showing the drawer, or nil."
  (require 'dirvish-side)
  (dirvish-side-session-visible-p))

(defun toad/drawer-p ()
  "non-nil when the drawer is the selected window."
  (eq (selected-window) (toad/drawer-window)))

;; keeps the buffer so expanded subtrees survive a hide.
(defun toad/drawer--hide ()
  "take the drawer window off screen."
  (when-let* ((window (toad/drawer-window)))
    (delete-window window)))

;; dirvish-side only selects a visible drawer, so hide first to reroot.
(defun toad/drawer--show ()
  "draw the drawer at `toad/drawer-root' and return its window."
  (toad/drawer--hide)
  (dirvish-side (toad/drawer-root))
  (toad/drawer-window))

(defun toad/drawer ()
  "show or hide the drawer, keeping focus."
  (interactive)
  (if (setq toad/drawer-wanted (null (toad/drawer-window)))
      (save-selected-window (toad/drawer--show))
    (toad/drawer--hide)))

(defun toad/drawer-focus ()
  "draw the drawer and select it."
  (interactive)
  (setq toad/drawer-wanted t)
  (when-let* ((window (toad/drawer--show)))
    (select-window window)))

(defun toad/drawer-pin ()
  "root this workspace's drawer at the directory at point."
  (interactive)
  (let ((file (dired-get-filename nil t)))
    (setf (alist-get (+workspace-current-name) toad/drawer-pins nil nil #'equal)
          (toad/dir (if (and file (file-directory-p file)) file (dired-current-directory))))
    (toad/drawer-focus)))

(defun toad/drawer-close ()
  "hide the drawer and forget its tree and pin."
  (interactive)
  (setq toad/drawer-wanted nil)
  (setf (alist-get (+workspace-current-name) toad/drawer-pins nil t #'equal) nil)
  (save-selected-window
    (unless (toad/drawer-window)
      (dirvish-side (toad/drawer-root)))
    (when-let* ((window (toad/drawer-window)))
      (with-selected-window window (dirvish-quit)))))

(defun toad/drawer-reroot-h (&rest _)
  "redraw a wanted drawer at the new workspace's root."
  (when toad/drawer-wanted
    (save-selected-window (toad/drawer--show))))

(add-hook 'persp-activated-functions #'toad/drawer-reroot-h)

;; drawer-only behaviour, the last command is the usual binding.
(after! dirvish
  (map! :map dirvish-mode-map
        :n "." #'toad/drawer-pin
        :n "q" (cmds! (toad/drawer-p) #'toad/drawer-close
                      #'dirvish-quit)
        :n "l" (cmds! (and (toad/drawer-p)
                           (file-directory-p (or (dired-get-filename nil t) "")))
                      #'dirvish-subtree-toggle
                      #'dired-find-file)
        :n "L" (cmds! (toad/drawer-p) #'dired-find-file
                      #'dired-do-load)
        :n "H" (cmds! (toad/drawer-p) #'dired-up-directory
                      #'dired-do-hardlink)))

(toad/bind-global "M-d" #'toad/drawer)
(toad/bind-global "M-f" #'toad/drawer-focus)
(toad/bind-global "M-e" #'dired-jump)

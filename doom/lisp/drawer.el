;;; lisp/drawer.el -*- lexical-binding: t; -*-

(defconst toad/drawer-fixed-places '("org" "config")
  "places whose automatic drawer root stays at the place root.
every other place may narrow its drawer to the active buffer's project,
provided that project is inside the place.")

(defvar toad/drawer-pins nil
  "workspace name to the directory pinned there with `.'.
a pin wins over the automatic root until `q' forgets it.")

(defun toad/drawer-root ()
  "the root the drawer should use.
a pinned directory comes first. `org' and `config' return their place
root. in every other place, return the active buffer's project when that
is the most specific place containing it, falling back to the place root.
in a workspace that is not a place, prefer the project and then `default-directory'."
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

(defvar toad/drawer-wanted nil
  "whether the drawer belongs on screen.
switching workspaces takes the drawer's window down along with the
rest of that perspective's layout, so something has to say to put it
back; the root it comes back at is derived again from `toad/drawer-root'.")

(defun toad/drawer-window ()
  "the window showing the drawer, or nil when it is not on screen."
  (require 'dirvish-side)
  (dirvish-side-session-visible-p))

(defun toad/drawer--hide ()
  "take the drawer off screen, leaving the listing alone.
the window goes; the buffer behind it stays. a subtree opened with TAB
lives in that buffer, so ending the session here would mean walking back
down the tree after every hide. `toad/drawer-close\=' is the one that
forgets."
  (when-let* ((window (toad/drawer-window)))
    (delete-window window)))

(defun toad/drawer--show ()
  "draw the drawer at `toad/drawer-root', and return its window.
takes the window down first: `dirvish-side\=' only selects a drawer that
is already up, so one left at another place would never be rerooted. the
listing it had for this root is reused, subtrees and all."
  (toad/drawer--hide)
  (dirvish-side (toad/drawer-root))
  (toad/drawer-window))

(defun toad/drawer ()
  "show or hide the drawer, rooted at `toad/drawer-root'.
point stays where it is; `toad/drawer-focus' is the one that moves it."
  (interactive)
  (if (setq toad/drawer-wanted (null (toad/drawer-window)))
      (save-selected-window (toad/drawer--show))
    (toad/drawer--hide)))

(defun toad/drawer-focus ()
  "draw the drawer at `toad/drawer-root' and select it."
  (interactive)
  (setq toad/drawer-wanted t)
  (when-let* ((window (toad/drawer--show)))
    (select-window window)))

(defun toad/drawer-pin ()
  "root the drawer at the directory at point for this workspace.
like `.' in neotree: M-d and M-f open here until `q' forgets it."
  (interactive)
  (let ((file (dired-get-filename nil t)))
    (setf (alist-get (+workspace-current-name) toad/drawer-pins nil nil #'equal)
          (toad/dir (if (and file (file-directory-p file)) file (dired-current-directory))))
    (toad/drawer-focus)))

(defun toad/drawer-close ()
  "hide the drawer, stop asking for it back, and forget its tree and pin.
the way out when a listing is wrong rather than merely in the way: this
is the one that ends the session, so the next draw reads the directory
again from scratch."
  (interactive)
  (setq toad/drawer-wanted nil)
  (setf (alist-get (+workspace-current-name) toad/drawer-pins nil t #'equal) nil)
  (save-selected-window
    (unless (toad/drawer-window)
      (dirvish-side (toad/drawer-root)))
    (when-let* ((window (toad/drawer-window)))
      (with-selected-window window (dirvish-quit)))))

(defun toad/drawer-quit ()
  "quit dirvish, also clearing the reopen preference when in the sidebar."
  (interactive)
  (if (eq (selected-window) (toad/drawer-window))
      (toad/drawer-close)
    (dirvish-quit)))

(defun toad/drawer-reroot-h (&rest _)
  "redraw a wanted drawer at the root that just became current.
on `persp-activated-functions', which fires straight from the workspace
switch, so `toad/go' and doom's own `SPC TAB n' are both covered. it is
synchronous: there is no timer here to race the switch."
  (when toad/drawer-wanted
    (save-selected-window (toad/drawer--show))))

(add-hook 'persp-activated-functions #'toad/drawer-reroot-h)

(after! dirvish
  (map! :map dirvish-mode-map
        :n "q" #'toad/drawer-quit
        :n "." #'toad/drawer-pin))

(toad/bind-global "M-d" #'toad/drawer)
(toad/bind-global "M-f" #'toad/drawer-focus)

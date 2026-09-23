;;; config.el -*- lexical-binding: t; -*-

;; helpers must load before their callers.
(load! "lisp/keys")
(load! "lisp/lib")
(load! "lisp/places")

(load! "lisp/core/identity")
(load! "lisp/core/editor")
(load! "lisp/core/windows")

(load! "lisp/ui/theme")
(load! "lisp/ui/modeline")
(load! "lisp/ui/banner/banner")

(load! "lisp/org/files")
(load! "lisp/org/template")
(load! "lisp/org/logs")
(load! "lisp/org/done")
(load! "lisp/org/capture")
(load! "lisp/org/commands")
(load! "lisp/dired")
(load! "lisp/drawer")
(load! "lisp/pdf")
(load! "lisp/latex")
(load! "lisp/nix")
(load! "lisp/proverif")
(load! "lisp/web")
(load! "lisp/rss")

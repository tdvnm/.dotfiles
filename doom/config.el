;;; config.el -*- lexical-binding: t; -*-

(setq user-full-name    "toad"
      user-mail-address "toadvnm@proton.me")

;; helpers load first.
(load! "lisp/lib")

(load! "lisp/editor")
(load! "lisp/windows")
(load! "lisp/ui")
(load! "lisp/banner/banner")

(load! "lisp/org/files")
(load! "lisp/org/template")
(load! "lisp/org/logs")
(load! "lisp/org/done")
(load! "lisp/org/capture")
(load! "lisp/org/commands")

(load! "lisp/dired")
(load! "lisp/pdf")
(load! "lisp/modes")
(load! "lisp/proverif")

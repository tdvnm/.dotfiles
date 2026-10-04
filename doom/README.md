# doom config

small, personal doom setup. one concern per file, lowercase `;;;` sections that
fold (`TAB`, listed in `SPC s i`). `custom.el` is untracked machine state, loaded
last. themes in `themes/`.

## layout

```
config.el        name, email, load order
lisp/lib.el      path helpers, places, toad/bind-global
lisp/editor.el   scrolling, yank flash, :q, flycheck
lisp/windows.el  split policy, tabs, workspaces
lisp/ui.el       fonts, theme, modeline
lisp/banner/     startup banner + images
lisp/org/        files, template, logs, done, capture, commands
lisp/dired.el    dired tweaks + drawer
lisp/pdf.el      pdf split rule, epdfinfo discovery
lisp/modes.el    latex, web, rss
lisp/proverif.el proverif modes + checker
```

## places

workspaces (`lisp/lib.el`), order sets `SPC TAB 1..5`: org `~/org/`, code
`~/code/`, config (this repo), krea `~/krea/`, misc `~/`.

## keys

`M-` is alt, reserved globally (except org-only `M-p`). personal commands: `M-x toad/`.

| key     | does                              |
| ------- | --------------------------------- |
| M-a     | agenda.org (task list)            |
| M-t     | today's log                       |
| M-n     | capture a task or note            |
| M-p     | org: set priority a/b/c, SPC clears |
| M-[ M-] | prev / next tab                   |
| M-d M-f | drawer: toggle / focus            |
| M-e     | dired here                        |

drawer: `.` pin dir as root, `q` close + forget, `l`/`L`/`H` open/enter/up.
dired: `SPC m h` toggle hidden, `N` file, `+` dir, `c` compress.

## org

`~/org/` is `org-directory`: one task list, dated logs copied from it,
append-only trackers.

```
agenda.org               tasks; sections agenda krea maint contact
logbook/daily/<date>.org today; M-t fills once from template, then yours
tracker/<name>.org       history, fed by the section of the same name
```

DONE on a task appends it to the tracker named by its nearest tracked heading;
other sections just mark it done. title-based, no ids.

## extras

pdf opens in a dedicated right column; nyan, startup banner, `speed-type-text`,
rss (`~/org/library/feeds.org`), proverif. epdfinfo and texlab come from the system.

## apply / test

runtime edits: restart or `M-x doom/reload`. module/package changes: `doom sync`
then restart.

```sh
emacs --batch -L ~/.config/emacs/.local/straight/build-30.2/org \
  -l test/org-daily-test.el -f ert-run-tests-batch-and-exit
emacs --batch -l test/pdf-test.el -f ert-run-tests-batch-and-exit
```

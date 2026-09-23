# doom config

My Doom Emacs setup. Keep the machinery small and the workflows personal.

## Layout

`init.el` selects Doom modules (and keeps the disabled-module catalogue as a
reference). `packages.el` declares extra packages. `config.el` loads personal
settings in dependency order: shared helpers → core → UI → features.
Adding a feature is one file under `lisp/` and one `load!` line.

```
config.el          loader
lisp/keys.el       toad/bind-global, the M- namespace
lisp/lib.el        path helpers
lisp/places.el     workspace names and roots
lisp/core/         identity, editor defaults, windows and workspaces
lisp/ui/           theme and fonts, modeline, startup banner
lisp/org/          files, template, logs, done, capture, commands
lisp/dired.el      dired natives dirvish hides
lisp/drawer.el     dirvish sidebar
lisp/pdf.el        pdf-tools and epdfinfo discovery
lisp/latex.el      viewer and lsp server
lisp/nix.el        formatter for doom doctor
lisp/proverif.el   proverif modes
lisp/web.el        web-mode indent
lisp/rss.el        elfeed feed list
```

`custom.el` is machine state and stays untracked. Doom loads it **after** this
config, so keep workflow settings out of it: an `org-agenda-files` entry there
would override the list in `lisp/org/files.el`. Themes live in `themes/`.

### Where to change something

| Change | Owner |
| ------ | ----- |
| Places, roots, workspace order | [lisp/places.el](lisp/places.el) |
| Global shortcut policy | [lisp/keys.el](lisp/keys.el); bindings live beside their feature |
| Editing, yank flash, `:q`, half-width fill | [lisp/core/editor.el](lisp/core/editor.el) |
| Tabs, workspace switching, split policy | [lisp/core/windows.el](lisp/core/windows.el) |
| Drawer roots, pins, visibility | [lisp/drawer.el](lisp/drawer.el) |
| Org paths, agenda sources, date recognition | [lisp/org/files.el](lisp/org/files.el) |
| New-file headers and template substitutions | [lisp/org/template.el](lisp/org/template.el) |
| Daily/weekly generation and refresh | [lisp/org/logs.el](lisp/org/logs.el) |
| Completion and activity recording | [lisp/org/done.el](lisp/org/done.el) |
| Capture menu | [lisp/org/capture.el](lisp/org/capture.el) |
| Org commands and shortcuts | [lisp/org/commands.el](lisp/org/commands.el) |
| Fonts/theme, Nyan/modeline, banner | `lisp/ui/`; palettes in `themes/` |

Use `SPC f f` to open a file or `SPC s d` to search this directory.
Keep each setting in its owner; use `after!` when the package must load first.
Keep daily tasks title-based: no custom IDs or properties.

## Places

Workspaces, in `lisp/places.el`. The order sets `SPC TAB 1..5`.

| name   | root       |
| ------ | ---------- |
| org    | ~/org/     |
| code   | ~/code/    |
| config | this repo  |
| krea   | ~/krea/    |
| misc   | ~/         |

## Keys

`M-` is Alt. Uppercase matters. Except for Org-only `M-p`, these keys are
reserved globally across modes and Evil states, replacing their usual Emacs
bindings (including minibuffer history on `M-n`).

| key   | does                                   | file            |
| ----- | -------------------------------------- | --------------- |
| M-a   | agenda.org, the task list              | org/commands.el |
| M-t   | today's log                            | org/commands.el |
| M-n   | capture a task or a note               | org/commands.el |
| M-p   | in org files: priority, then a b c or SPC | org/commands.el |
| M-c   | code workspace                         | core/windows.el |
| M-C   | config workspace                       | core/windows.el |
| M-k   | krea workspace                         | core/windows.el |
| M-m   | misc workspace                         | core/windows.el |
| M-[   | previous tab                           | core/windows.el |
| M-]   | next tab                               | core/windows.el |
| M-d   | show or hide the drawer, keep focus    | drawer.el       |
| M-f   | draw the drawer and focus it           | drawer.el       |

In dired: `SPC m h` toggles hidden/omitted files (Doom's default key, extended
to include every dotfile), `N` new file,
`+` new directory, `c` compress. In the drawer,
`.` pins the directory at point as the root for this workspace, so `M-d`
and `M-f` open there; `q` closes the drawer and forgets its tree and pin.

Personal commands start with `toad/`; type `M-x toad/` to find them.
Doom's normal leader keys remain available too.

| command                  | does                                          |
| ------------------------ | --------------------------------------------- |
| toad/org-agenda          | open agenda.org (also M-a)                    |
| toad/org-today           | today's log (also M-t)                        |
| toad/org-week            | this week's log                               |
| toad/org-urgent          | every unfinished [#A] task                    |
| toad/org-refresh         | rebuild this log's generated sections         |
| toad/org-calendar        | three months, RET opens a day's log           |
| toad/org-sort-tasks      | section at point: DONE last, priority, ...    |
| toad/go                  | switch workspace by name                      |
| toad/drawer-pin          | root the drawer at the directory at point (.) |
| toad/keys                | open this README at Keys                      |
| toad/half-fill           | wrap at half the window, again to turn off    |

## Org

`~/org/` is `org-directory`. One task list, dated logs that copy from it,
trackers that remember what got done.

```
agenda.org                 tasks, with capture sections: agenda krea maint contact
logbook/daily/<date>.org   what I am doing today
logbook/weekly/<week>.org  what this week holds and what I did in it
tracker/<keyword>.org      append-only history, one file per activity keyword
```

### Tasks

`M-a` opens `agenda.org`. `M-n` captures into it: `a` `k`
`m` `c` add a `TODO` under that section, `n` adds a note stamped with the time
under today's `motd`. Finish with `C-c C-c`, cancel with `C-c C-k`.

`M-x toad/org-urgent` lists every unfinished `[#A]` task across the agenda files (agenda.org
and each course's agenda under krea) in an agenda view: `RET` jumps to it,
`t` changes its state, `q` closes.

On a task, `M-p` then `a`, `b` or `c` sets its priority, `SPC` clears it.
On a section heading, `M-x toad/org-sort-tasks` sorts its children: DONE
last, priority, alphabetical, scheduled date, or deadline. Completed tasks
get a CLOSED timestamp.

### Logs

`M-t` opens `logbook/daily/YYYY-MM-DD.org`; `M-x toad/org-week` opens
`logbook/weekly/YYYY-Www.org`, as does the `week` link at the top of a
daily. A new file is filled from the `template.org` in its directory:
`<name>` becomes the filename, `<week>` a link to that log's weekly. Any
other empty file under `~/org/` gets title, author and date headers.

One rule each:

- **Daily**: filled once, when `M-t` creates it. After that it is yours:
  reorder, tick, delete, nothing comes back. `M-x toad/org-refresh` copies
  the week's tasks in again only if you ask.
- **Weekly**: generated sections rebuild when the file enters Org mode,
  normally when first opened from disk. Switching back to an already open buffer
  does not rebuild it: use `M-x toad/org-refresh` for fresh tasks and history.
  Edit agenda.org or the trackers; keep personal notes in separate sections.

- `agenda`: unfinished agenda.org tasks scheduled or due in that log's
  week, Monday to Sunday, in source order with their dates. The daily lists
  them flat; the weekly groups them under `** monday` … `** sunday`, and
  under each day also lists what got done that day, as `*** STUDY …`,
  `*** MAINT …`, one line per tracker record.
- `study`, `watch`, `maint`, `contact` in a weekly: that tracker's records
  from the whole week. The weekly template decides which of these exist.

Anything else in a log is yours and is left alone.

### Done

Marking a heading DONE in a log does one of two things:

- A `TODO` marks its uniquely named agenda.org task DONE too, matched by its
  exact title. Duplicate titles leave the source unchanged and show a message.
  Renaming a copy breaks the match; a manually written TODO with the same title
  also matches. No IDs or properties are used.
- Any other keyword is an activity (`STUDY`, `WATCH`, `MAINT`, `CONTACT`,
  whatever the daily template's `#+TODO` line lists) and appends
  `* [2026-09-14 Mon] : <title>` to `tracker/<keyword>.org`. Only the
  daily does this; the weekly is a view and records nothing.

Empty headings record nothing. History is append-only: reopening or
undoing DONE leaves the record, completing again adds another.

Clean source/tracker buffers are saved after an update. If a buffer already has
unsaved edits, the update stays in that buffer and a message asks you to save it.
Refreshing changes the current log buffer; save it when ready. A failed refresh
rolls back changes to its generated sections.

## Windows and extras

Automatic splits are disabled globally; manual splits still work. PDFs have
their own rule to open in a new right-hand split, reusing that PDF's window if
it is already visible. PDFs use normal page viewing by default. In a PDF,
`M-x pdf-view-roll-minor-mode` toggles continuous scrolling on or off for that
buffer. The drawer lives on the right too, follows
workspace changes, and remembers expanded trees while hidden. A pinned directory
wins over its automatic root; `q` forgets the current pin and tree.

Nyan animation, the startup banner, typing practice (`M-x speed-type-text`), RSS,
and ProVerif are intentional features. RSS reads `~/org/library/feeds.org`.
ProVerif discovers its mode from the installed executable; its checker only
parses, without running proofs. PDF support discovers `epdfinfo`; LaTeX chooses
installed `texlab`, then `digestif`. These programs come from the system.

## Checks and applying changes

Runtime edits need a restart or `M-x doom/reload`. Changes to enabled modules or
package declarations need `doom sync` followed by a restart. No package changes
were needed for this cleanup.

Run the isolated Org regression suite from this directory:

```sh
emacs --batch -l test/org-daily-test.el -f ert-run-tests-batch-and-exit
```

To check against this machine's Doom-installed Org, add
`-L ~/.config/emacs/.local/straight/build-30.2/org` before `-l`.
Tests use temporary files and templates in `test/fixtures/`, not personal logs.
They cover generation, completion, capture/cancellation, sorting, duplicate
titles, unsaved edits, and refresh rollback. Live checks also covered global
shortcuts across four modes and four Evil states, and repeated config loading.
These checks catch specific regressions; they do not prove zero bugs or exercise
every graphical/package interaction.

## ELI5: how it fits together

`init.el` chooses the toys, `packages.el` adds a few extra toys, and `config.el`
puts them on the shelf in the right order. `places.el` labels the rooms; windows
and the drawer use those same labels. Each feature keeps its own settings and
buttons together. Org keeps the task list, makes daily/weekly pages from it, and
records finished activities in trackers. Change a thing in its one named home,
then use the checks above to see whether the pieces still fit.

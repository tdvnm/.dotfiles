local set = vim.opt
-- set.nu = true
-- set.relativenumber = true

set.tabstop = 4
set.softtabstop = 4

set.shiftwidth = 4
set.expandtab = true

set.smartindent = true
set.guicursor = ""
set.signcolumn = "no"

set.wrap = false

set.swapfile = false
set.backup = false
set.undofile = true
set.undodir = os.getenv("HOME") .. "/.local/undodir"
set.clipboard:append("unnamedplus")

set.hlsearch = false
set.incsearch = true
set.inccommand = "split"
set.ignorecase = true

set.termguicolors = true

set.scrolloff = 999

set.isfname:append("@-@")
set.updatetime = 50

set.splitbelow = true
set.splitright = true

-- set.cursorline = true

set.virtualedit = "block"

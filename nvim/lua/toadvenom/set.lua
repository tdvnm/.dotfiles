local set = vim.opt
-- set.nu = true
-- set.relativenumber = true

set.tabstop = 4
set.softtabstop = 4

set.shiftwidth = 4
set.expandtab = true

set.smartindent = true
set.guicursor = ""
set.signcolumn = "yes"

set.wrap = true

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

-- highlight on yank
vim.cmd("au TextYankPost * lua vim.highlight.on_yank {higroup='IncSearch', timeout=150}")

-- set.cursorline = true
set.virtualedit = "block"
-- vim.cmd("set statusline+=%F")

if not opts then
    opts = {}
end

-- Configure hererocks and luarocks
opts.rocks = {
    hererocks = true,
    enabled = false,
}

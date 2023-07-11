vim.cmd([[
    augroup highlight_yank
    autocmd!

    au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
    autocmd VimEnter * highlight LineNr guibg=none guifg=#83a598
    autocmd VimEnter * highlight NonText guifg=#665c53

    augroup END
]])



local set = vim.opt
-- set.nu = true
-- set.relativenumber = true
-- vim.api.nvim_command('highlight NonText ctermfg=cyan guifg=cyan')

-- set.cursorline = true
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.expandtab = true

set.smartindent = true
set.guicursor = ""

set.wrap = true

set.swapfile = false
set.backup = false
set.undodir = os.getenv("HOME") .. "/.local/undodir"
set.undofile = true

set.hlsearch = false
set.incsearch = true

set.termguicolors = true

set.scrolloff = 12
set.signcolumn = "yes"

set.mouse =

    set.isfname:append("@-@")
set.updatetime = 50

-- vim.opt.colorcolumn = "81" -- set the color column to 81
-- vim.cmd [[highlight ColorColumn ctermbg=darkgrey guibg=darkgrey alpha=50]] -- highlight the color column

-- vim.cmd('highlight ColorColumn ctermbg=none guibg=#044949')

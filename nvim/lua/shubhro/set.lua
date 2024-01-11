-- vim.cmd([[
--     augroup RosepineDawnColorscheme
--     autocmd!
--     autocmd FileType tex colorscheme rose-pine-dawn
--     augroup END
-- ]])
--
-- vim.cmd [[
-- augroup AutoSaveTeX
--   autocmd!
--   autocmd TextChanged,TextChangedI *.tex silent! write
-- augroup END
-- ]]
-- autocmd VimEnter * highlight CursorLine guibg=bg guifg=#ffffff
-- autocmd VimEnter * highlight LineNr guibg=none guifg=#83a598

vim.cmd([[
    augroup highlight_yank
    autocmd!

    au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
    autocmd VimEnter * highlight NonText guifg=#665c53

    autocmd VimEnter * set signcolumn=no

    augroup END
]])



local set = vim.opt
-- set.nu = true
-- set.relativenumber = true

set.cursorline = true
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.expandtab = true

set.smartindent = true
set.guicursor = ""

set.wrap = false

set.swapfile = false
set.backup = false
set.undofile = true
set.undodir = os.getenv("HOME") .. "/.local/undodir"

set.hlsearch = false
set.incsearch = true

set.termguicolors = true

set.scrolloff = 20
set.signcolumn = "yes"

set.colorcolumn = "80"

set.isfname:append("@-@")
set.updatetime = 50

-- vim.opt.colorcolumn = "81" -- set the color column to 81
-- vim.cmd [[highlight ColorColumn ctermbg=darkgrey guibg=darkgrey alpha=50]] -- highlight the color column

-- vim.cmd('highlight ColorColumn ctermbg=none guibg=#044949')
set.clipboard:append("unnamedplus")
-- set.cursorline = true
--

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
set.undofile = true
set.undodir = os.getenv("HOME") .. "/.local/undodir"

set.hlsearch = false
set.incsearch = true

set.termguicolors = true

set.scrolloff = 14
set.signcolumn = "no"

-- set.colorcolumn = 80

set.isfname:append("@-@")
set.updatetime = 50

-- vim.opt.colorcolumn = "81" -- set the color column to 81
-- vim.cmd [[highlight ColorColumn ctermbg=darkgrey guibg=darkgrey alpha=50]] -- highlight the color column

-- vim.cmd('highlight ColorColumn ctermbg=none guibg=#044949')
set.clipboard:append("unnamedplus")
-- set.cursorline = true
--


-- -- Disable the toolbar
-- vim.cmd('set guioptions-=T')

-- -- Disable other unnecessary elements
-- vim.cmd('set guioptions-=m')
-- vim.cmd('set guioptions-=r')
-- vim.cmd('set guioptions-=L')

-- -- Centered text
-- vim.api.nvim_exec([[
--   autocmd VimEnter * call append(0, repeat([''], (winheight(0) - 1) / 2) + {'     I love coding'} + repeat([''], winheight(0) / 2 - 1))
-- ]], false)

-- -- Map <leader> to clear the screen and show the message
-- vim.api.nvim_set_keymap('n', '<leader>', ':redraw!<CR>', { noremap = true, silent = true })

local set = vim.opt

set.nu = true
set.relativenumber = true

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
-- also how long the cursor rests before the diagnostic popup (lsp.lua)
set.updatetime = 950

set.splitbelow = true
set.splitright = true

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank({ higroup = "IncSearch", timeout = 150 })
    end,
})

set.virtualedit = "block"

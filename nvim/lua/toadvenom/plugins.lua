-- plugins. exact versions are pinned in lazy-lock.json, and a fresh install
-- checks out those commits. `:Lazy update` moves them forward; commit the lock
-- after checking nothing broke.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        -- no network on first start: say so and carry on without plugins
        vim.api.nvim_echo({ { "could not clone lazy.nvim:\n" .. out, "ErrorMsg" } }, true, {})
        return
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- COLORSCHEME
    "ellisonleao/gruvbox.nvim",

    -- NAVIGATION
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
    },
    "theprimeagen/harpoon",

    -- LSP. the servers come from nix (packages.nix), not mason, so they are
    -- pinned with the system. lspconfig only supplies their default settings.
    "neovim/nvim-lspconfig",
    "nvimtools/none-ls.nvim",
    -- completions
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/nvim-cmp",
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_snipmate").lazy_load()
        end,
    },

    -- DEV
    "lervag/vimtex",

    -- ESSENTIALS
    "github/copilot.vim",
    "tpope/vim-commentary",
    "jiangmiao/auto-pairs",
    "mbbill/undotree",
}, {
    -- no plugin here needs luarocks; skip it so nothing tries to build rocks
    rocks = { enabled = false },
})

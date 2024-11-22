local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- COLORSCHEME
    "haystackandroid/strawberry",
    "ellisonleao/gruvbox.nvim",
    "mstcl/dmg",
    "nyoom-engineering/oxocarbon.nvim",
    "maxmx03/solarized.nvim",

    -- misc
    -- "Mr-LLLLL/interestingwords.nvim",
    -- "lfv89/vim-interestingwords",

    -- NAVIGATION
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.4",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    "nvim-treesitter/nvim-treesitter",
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim",
        },
    },
    "theprimeagen/harpoon",

    -- LSP
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
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
    },
    "honza/vim-snippets",

    -- DEV
    -- "sirver/ultisnips",
    "lervag/vimtex",
    -- {
    --     "OXY2DEV/markview.nvim",
    --     ft = "markdown",

    --     dependencies = {
    --         "nvim-treesitter/nvim-treesitter",
    --         "nvim-tree/nvim-web-devicons",
    --     },
    -- },

    -- ESSENTIALS
    "github/copilot.vim",
    "tpope/vim-commentary",
    "jiangmiao/auto-pairs",
    "ggandor/lightspeed.nvim",
    "numtostr/FTerm.nvim",
    "mbbill/undotree",
    -- MISC
    "Eandrju/cellular-automaton.nvim",
    -- "hoob3rt/lualine.nvim",
    "goolord/alpha-nvim",
})

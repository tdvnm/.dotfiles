lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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

-- Packer can manage itself
local plugins = { {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            -- ensure_installed = { "c", "lua", "javascript", "html" },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
},
    -- REQUIRED
    "github/copilot.vim",
    "tpope/vim-commentary",
    --- Uncomment these if you want to manage LSP servers from neovim
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },

    { 'VonHeikemen/lsp-zero.nvim',        branch = 'v3.x' },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'L3MON4D3/LuaSnip' },
    "onsails/lspkind.nvim",

    -- DASHBOARD
    -- {
    --     "startup-nvim/startup.nvim",
    --     requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    --     config = function()
    --         require "startup".setup()
    --     end
    -- },
    -- TODO
    -- IDE STUFF
    "p00f/clangd_extensions.nvim",
    "mfussenegger/nvim-dap",

    'edluffy/hologram.nvim',

    "folke/neodev.nvim",
    "ErichDonGubler/lsp_lines.nvim",

    -- GIT PLUGINS
    "lewis6991/gitsigns.nvim",
    "tpope/vim-fugitive",

    -- NAVIGATION PLUGINS
    "theprimeagen/harpoon",
    -- use({ "romgrk/barbar.nvim", requires = "nvim-web-devicons" })
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
            -- "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        }
    },

    --TELSCOPE
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        -- or                              , branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    "nvim-telescope/telescope-file-browser.nvim",


    -- MOTIONS PLUGINS
    -- use "justinmk/vim-sneak"
    "ggandor/lightspeed.nvim",
    -- use("ggandor/leap.nvim")


    -- FUN PLUGINS
    "numtostr/FTerm.nvim",
    "nvim-lualine/lualine.nvim",

    -- use("nvimdev/galaxyline.nvim")
    "jiangmiao/auto-pairs",
    "mbbill/undotree",
    --
    "folke/todo-comments.nvim",

    "Eandrju/cellular-automaton.nvim",
    -- use "lukas-reineke/indent-blankline.nvim"
    -- use {"akinsho/toggleterm.nvim", tag = '*', config = function()
    --   require("toggleterm").setup()
    -- end}
    -- use({
    --     'glepnir/galaxyline.nvim',
    --     branch = 'main'
    -- })
    -- use("jose-elias-alvarez/null-ls.nvim")

    -- web plugins
    "brenoprata10/nvim-highlight-colors",

    -- SNIPPETS
    "hrsh7th/vim-vsnip",
    "hrsh7th/vim-vsnip-integ",
    -- "SirVer/ultisnips",
    "honza/vim-snippets",


    -- "nvim-tree/nvim-web-devicons",

    -- writing
    "lervag/vimtex",
    "jakewvincent/texmagic.nvim",
    -- "junegunn/goyo.vim",

    --COLOR THEMES
    "sainttttt/flesh-and-blood",
    "folke/tokyonight.nvim",
    -- use({ "catppuccin/nvim", as = "catppuccin" })
    "nyoom-engineering/oxocarbon.nvim",
    "Mofiqul/dracula.nvim",
    -- use("sainnhe/gruvbox-material")
    "FrenzyExists/aquarium-vim",
    -- use("arcticicestudio/nord-vim")
    "rose-pine/neovim",
    "ellisonleao/gruvbox.nvim",
    -- use("NTBBloodbath/sweetie.nvim")
    --
    -- use({ "kabouzeid/nvim-jellybeans", requires = "rktjmp/lush.nvim" })
    -- {
    --     "folke/noice.nvim",
    --     event = "VeryLazy",
    --     opts = {
    --         -- add any options here
    --     },
    --     dependencies = {
    --         -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    --         "MunifTanjim/nui.nvim",
    --         -- OPTIONAL:
    --         --   `nvim-notify` is only needed, if you want to use the notification view.
    --         --   If not available, we use `mini` as the fallback
    --         "rcarriga/nvim-notify",
    --     }
    -- 'anuvyklack/pretty-fold.nvim' -- }
}

local opts = {}

require("lazy").setup(plugins, opts)

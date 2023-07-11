vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")


    -- REQUIRED
    use("github/copilot.vim")
    use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
    use("tpope/vim-commentary")
    use({
        "VonHeikemen/lsp-zero.nvim",
        branch = "v1.x",
        requires = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },             -- Required
            { "williamboman/mason.nvim" },           -- Optional
            { "williamboman/mason-lspconfig.nvim" }, -- Optional

            -- Autocompletion
            { "hrsh7th/nvim-cmp" },         -- Required
            { "hrsh7th/cmp-nvim-lsp" },     -- Required
            { "hrsh7th/cmp-buffer" },       -- Optional
            { "hrsh7th/cmp-path" },         -- Optional
            { "saadparwaiz1/cmp_luasnip" }, -- Optional
            { "hrsh7th/cmp-nvim-lua" },     -- Optional

            -- Snippets
            { "L3MON4D3/LuaSnip" },             -- Required
            { "rafamadriz/friendly-snippets" }, -- Optional
        },
    })
    use("onsails/lspkind.nvim")

    -- IDE STUFF
    use("p00f/clangd_extensions.nvim")
    use("mfussenegger/nvim-dap")
    use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
    use("folke/neodev.nvim")
    use("ErichDonGubler/lsp_lines.nvim")

    -- GIT PLUGINS
    use("lewis6991/gitsigns.nvim")
    use("tpope/vim-fugitive")

    -- NAVIGATION PLUGINS
    use("theprimeagen/harpoon")
    -- use({ "romgrk/barbar.nvim", requires = "nvim-web-devicons" })
    use({
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
    })
    use({
        "nvim-telescope/telescope.nvim",
        tag = "0.1.1",
        -- or                            , branch = '0.1.x',
        requires = { { "nvim-lua/plenary.nvim" } },
    })
    use("nvim-telescope/telescope-file-browser.nvim")


    -- MOTIONS PLUGINS
    -- use "justinmk/vim-sneak"
    use 'ggandor/lightspeed.nvim'
    -- use("ggandor/leap.nvim")


    -- FUN PLUGINS
    use("numtostr/FTerm.nvim")
    use("nvim-lualine/lualine.nvim")
    -- use("nvimdev/galaxyline.nvim")
    use("jiangmiao/auto-pairs")
    use("mbbill/undotree")
    -- use({
    --     "glepnir/dashboard-nvim",
    --     event = "VimEnter",
    --     requires = { "nvim-tree/nvim-web-devicons" },
    -- })
    use("folke/todo-comments.nvim")

    use("Eandrju/cellular-automaton.nvim")
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
    use("brenoprata10/nvim-highlight-colors")

    -- SNIPPETS
    use("hrsh7th/vim-vsnip")
    use("hrsh7th/vim-vsnip-integ")
    -- use("SirVer/ultisnips")


    use("nvim-tree/nvim-web-devicons")

    -- writing
    use("lervag/vimtex")
    use({
        'jakewvincent/texmagic.nvim',
        config = function()
            require('texmagic').setup({
                -- Config goes here; leave blank for defaults
            })
        end
    })
    use("junegunn/goyo.vim")

    --COLOR THEMES
    use("folke/tokyonight.nvim")
    use({ "catppuccin/nvim", as = "catppuccin" })
    use("nyoom-engineering/oxocarbon.nvim")
    use("Mofiqul/dracula.nvim")
    -- use("sainnhe/gruvbox-material")
    use("FrenzyExists/aquarium-vim")
    -- use("arcticicestudio/nord-vim")
    use("rose-pine/neovim")
    use("ellisonleao/gruvbox.nvim")
    use("NTBBloodbath/sweetie.nvim")
    -- use({ "kabouzeid/nvim-jellybeans", requires = "rktjmp/lush.nvim" })
end)

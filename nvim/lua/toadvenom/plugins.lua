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
    "ellisonleao/gruvbox.nvim",

    -- NAVIGATION
    -- telescope
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    -- neotree
    "nvim-treesitter/nvim-treesitter",
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        }
    },
    -- harpoon
    "theprimeagen/harpoon",

    -- ESSENTIALS
    "github/copilot.vim",
    "tpope/vim-commentary",
    "jiangmiao/auto-pairs",
    "ggandor/lightspeed.nvim",
    "numtostr/FTerm.nvim",
    "mbbill/undotree",

    -- MISC
    "Eandrju/cellular-automaton.nvim",
})

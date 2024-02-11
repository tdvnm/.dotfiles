require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
    autoinstall = true,
    highlight = {
        enable = true,
    },
    additional_vim_regex_highlighting = false,
    sync_install = false,
    -- incremental_selection = {
    --     enable = true,
    -- keymaps = {
    --     init_selection = "<leader>ss",
    --     node_incremental = "<leader>sn",
    --     scope_incremental = "grc",
    --     node_decremental = "<leader>sp",
    -- },
    -- },
})

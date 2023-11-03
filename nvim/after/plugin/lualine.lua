require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "gruvbox",
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        -- component_separators = {|},
        -- section_separators = { h },
        -- disabled_filetypes = {
        --     'NvimTree',
        --     statusline = {},
        --     winbar = {},
        -- },
        ignore_focus = {},
        always_divide_middle = true,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        },
        globalstatus = true,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_c = {
            {
                "diagnostics",
                symbols = { error = " ", warn = "󰇥 ", info = " ", hint = " " },
                colored = false,
            },
        },
        lualine_b = {
            {
                "filename",
                symbols = {
                    modified = "[] ", -- Text to show when the file is modified.
                    readonly = "󰈈 ", -- Text to show when the file is non-modifiable or readonly.
                    unnamed = "[No Name]", -- Text to show for unnamed buffers.
                    newfile = "[New]", -- Text to show for newly created file before first write
                },
            },
        },

        lualine_c = { "branch", "diff" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_z = { "location" },
    },
})

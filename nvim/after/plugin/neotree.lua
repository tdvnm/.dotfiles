vim.keymap.set("n", "<A-d>", ":Neotree show toggle<cr>")
vim.keymap.set("n", "<A-f>", ":Neotree focus<cr>")

require("neo-tree").setup({
    window = {
        position = "right",
        width = 32 ,
        mapping_options = {
            noremap = true,
            nowait = true,
        },
        mappings = {
            ["<2-LeftMouse>"] = "open",
            ["l"] = "open",
            ["<esc>"] = "cancel", -- close preview or floating neo-tree window
            ["h"] = "close_node",
            ["a"] = { 
                "add",
                config = {
                    show_path = "relative" -- "none", "relative", "absolute"
                }
            },
            ["L"] = "open_nofocus",
        },
    },
    indent = {
        indent_size = 2,
        padding = 0, -- extra padding on left hand side
    },
    commands = {
        open_nofocus = function(state)
            require("neo-tree.sources.filesystem.commands").open(state)
            vim.schedule(function()
                vim.cmd([[Neotree focus]])
            end)
        end,
    },
})

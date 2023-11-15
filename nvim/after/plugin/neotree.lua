vim.keymap.set("n", "<A-d>", vim.cmd.NeoTreeShowToggle)
vim.keymap.set("n", "<A-f>", vim.cmd.NeoTreeFocus)

require("neo-tree").setup({
    default_component_configs = {
        container = {
            enable_character_fade = true,
        },
        indent = {
            indent_size = 2,
            padding = 1, -- extra padding on left hand side
            -- indent guides
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            -- expander config, needed for nesting files
            -- with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
        },
        icon = {
            folder_closed = " ",
            folder_open = "",
            folder_empty = "",
            -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
            -- then these will never be used.
            default = "*",
            highlight = "NeoTreeFileIcon",
        },
        modified = {
            symbol = "+",
            highlight = "NeoTreeModified",
        },
        name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
        },
        git_status = {
            symbols = {
                -- Change type
                added = "+", -- or "✚", but this is redundant info if you use git_status_colors on the name
                modified = "~", -- or "", but this is redundant info if you use git_status_colors on the name
                deleted = "✖", -- this can only be used in the git_status source
                renamed = "", -- this can only be used in the git_status source
                -- Status type
                untracked = " ",
                ignored = "",
                unstaged = " ",
                staged = "",
                conflict = "",
            },
        },
    },
    window = {
        position = "right",
        width = 30,
        mapping_options = {
            noremap = true,
            nowait = true,
        },
        mappings = {
            ["<space>"] = {
                "toggle_node",
                nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
            },
            ["<2-LeftMouse>"] = "open",
            ["l"] = "open",
            ["<esc>"] = "revert_preview",
            ["P"] = { "toggle_preview", config = { use_float = true } },
            [";"] = "focus_preview",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            -- ["S"] = "split_with_window_picker",
            -- ["s"] = "vsplit_with_window_picker",
            ["t"] = "open_tabnew",
            -- ["<cr>"] = "open_drop",
            -- ["t"] = "open_tab_drop",
            ["w"] = "open_with_window_picker",
            --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
            ["C"] = "close_node",
            -- ['C'] = 'close_all_subnodes',
            ["z"] = "close_all_nodes",
            --["Z"] = "expand_all_nodes",
            ["a"] = {
                "add",
                -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
                -- some commands may take optional config options, see `:h neo-tree-mappings` for details
                config = {
                    show_path = "relative", -- "none", "relative", "absolute"
                },
            },
            ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = {
                "copy",
                config = {
                    show_path = "none", -- "none", "relative", "absolute"
                },
            },
            ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
            ["<bs>"] = "navigate_up",
            ["."] = "set_root",
            ["H"] = "toggle_hidden",
        },
    },
})
-- examples for your init.lua

-- disable netrw at the very start of your init.lua (strongly advised)
-- vim.g.loaded_netrw = 0
-- vim.g.loaded_netrwPlugin = 1
-- vim.g.nvim_tree_respect_buf_cwd = 1
-- -- set termguicolors to enable highlight groups
-- vim.opt.termguicolors = true

-- vim.keymap.set('n', '<A-d>', vim.cmd.NvimTreeToggle)
-- vim.keymap.set('n', '<A-f>', vim.cmd.NvimTreeFocus)

-- -- OR setup with some options
-- require("nvim-tree").setup({
--     renderer = {
--         group_empty = false,
--         icons = {
--             glyphs = {
--                 folder = {
--                     arrow_closed = "+",
--                     arrow_open = "~",
--                     default = "",
--                     open = "",
--                     empty = "",
--                     empty_open = "",
--                     symlink = "",
--                     symlink_open = "",
--                 }
--             },
--         },
--         indent_markers = {
--             enable = true,
--             icons = {
--                 corner = "└", edge = "│", item = "│", bottom = "─", none = " ",
--             }
--         }
--     },
--     filters = {
--         dotfiles = true,
--     },
--     view = {
--         side = "right",
--         mappings = {
--             list = {
--                 { key = "l", action="edit", mode="n" }
--             }
--         },
--         width = 30,

--     },
-- })

-- require'nvim-web-devicons'.setup {
--     -- your personnal icons can go here (to override)
--     -- you can specify color or cterm_color instead of specifying both of them
--     -- DevIcon will be appended to `name`
--     override = {
--         zsh = {
--             icon = "",
--             color = "#428850",
--             cterm_color = "65",
--             name = "Zsh"
--         }
--     };
--     -- globally enable different highlight colors per icon (default to true)
--     -- if set to false all icons will have the default icon's color
--     color_icons = true;
--     -- globally enable default icons (default to false)
--     -- will get overriden by `get_icons` option
--     default = false;
--     -- globally enable "strict" selection of icons - icon will be looked up in
--     -- different tables, first by filename, and if not found by extension; this
--     -- prevents cases when file doesn't have any extension but still gets some icon
--     -- because its name happened to match some extension (default to false)
--     strict = false;
--     -- same as `override` but specifically for overrides by filename
--     -- takes effect when `strict` is true
--     override_by_filename = {
--         [".gitignore"] = {
--             icon = "",
--             color = "#f1502f",
--             name = "git"
--         },
--         [".norg"] = {
--             icon = "",
--             color = "#f1502f",
--             name = "norg"
--         }

--     };
--     -- same as `override` but specifically for overrides by extension
--     -- takes effect when `strict` is true
--     override_by_extension = {
--         ["log"] = {
--             icon = "",
--             color = "#81e043",
--             name = "Log"
--         },
--         [".norg"] = {
--             icon = "",
--             color = "#f1502f",
--             name = "norg"
--         }
--     };
-- }

require("gruvbox").setup({
    undercurl = false,
    underline = false,
    bold = true,
    strikethrough = true,
    invert_selection = true,
    invert_signs = false,
    invert_tabline = true,
    invert_intend_guides = true,
    inverse = true,
    contrast = "hard",
    palette_overrides = {
        bright_green = "#1fcc81",
        bright_purple = "#fa76a7",
    },
    dim_inactive = false,
    transparent_mode = true,
})

vim.cmd("colorscheme gruvbox")

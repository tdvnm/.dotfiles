-- setup must be called before loading the colorscheme
-- Default options:
require("gruvbox").setup({
    undercurl = false,
    underline = false,
    bold = true,
    -- italic = false,
    strikethrough = true,
    invert_selection = true,
    invert_signs = false,
    invert_tabline = true,
    invert_intend_guides = true,
    inverse = true,    -- invert background for search, diffs, statuslines and errors
    contrast = "hard", -- can be "hard", "soft" or empty string
    palette_overrides = {
        dark0_hard = "#494f54",
        dark0 = "#494f54",
        dark0_soft = "#494f54",
        dark1 = "#23282b",
        dark2 = "#494f54",
        dark3 = "#494f54",
        dark4 = "#494f54",

        bright_red = "#fb4934",
        bright_green = "#1fcc81",
        bright_yellow = "#fabd2f",
        bright_blue = "#83a598",
        bright_purple = "#d3869b",
        bright_aqua = "#8ec07c",
        bright_orange = "#fe8019",
        neutral_red = "#cc241d",

        neutral_green = "#ac2cb8",
        neutral_yellow = "#d79921",
        neutral_blue = "#458588",
        neutral_purple = "#b16286",
        neutral_aqua = "#689d6a",
        neutral_orange = "#d65d0e",
        faded_red = "#9d0006",
        faded_green = "#79740e",
        faded_yellow = "#b57614",
        faded_blue = "#076678",
        faded_purple = "#8f3f71",
        faded_aqua = "#427b58",
        faded_orange = "#af3a03",
        gray = "#928374",
    },
    -- overrides = {
    --     SignColumn = { bg = "#070b2116" }
    -- },
    dim_inactive = true,
    transparent_mode = true,
})

vim.cmd("colorscheme gruvbox")

-- PRIMEAGEN
-- require("rose-pine").setup({
-- 	disable_background = true,
-- })

-- function ColorMyPencils(color)
-- 	color = color or "gruvbox"
-- 	vim.cmd.colorscheme(color)

-- 	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- 	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- end

-- ColorMyPencils()

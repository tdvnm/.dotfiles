require("gruvbox").setup({
    undercurl = false,
    underline = false,
    bold = true,
    strikethrough = true,
    invert_selection = true,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = true,
    inverse = true,    -- invert background for search, diffs, statuslines and errors
    contrast = "hard", -- can be "hard", "soft" or empty string
    palette_overrides = {
        dark0_hard = "#626369",
        dark0 = "#626369",
        dark0_soft = "#626369",
        dark1 = "#23282b",
        dark2 = "#626369",
        dark3 = "#626369",
        dark4 = "#626369",

        bright_green = "#1fcc81",
        bright_purple = "#fa76a7",

        gray = "#928374",
    },
    -- overrides = {
    --     SignColumn = { bg = "#070b2116" }
    -- },
    dim_inactive = false,
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

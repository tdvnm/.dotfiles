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
        dark0_hard = "#1c1c1c",
    },
    overrides = {},
    dim_inactive = false,
    transparent_mode = true,
})

vim.cmd("colorscheme gruvbox")

--
--
--
--
--
--
--
--
--
--
--
--
--
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

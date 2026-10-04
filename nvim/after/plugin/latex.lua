-- vimtex: compile with latexmk, view in zathura.
-- zathura_simple skips the xdotool window lookup, which doesn't exist on wayland
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_view_method = "zathura_simple"

-- vimtex mappings start with ,
vim.g.maplocalleader = ","

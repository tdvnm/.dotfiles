local remap = vim.keymap.set

vim.g.mapleader = " "

remap("v", "K", ":m '<-2<CR>gv=gv")
remap("v", "J", ":m '>+1<CR>gv=gv")

remap("i", "jj", "<Esc>=ap")

remap("n", "H", "i<Cr><Esc>k")
remap("n", "L", "O<Esc>j")

remap("n", "<C-k>", "15kzz")
remap("n", "<C-j>", "15jzz")
remap("n", "n", "nzzzv")
remap("n", "N", "Nzzzv")

remap("n", "n", "nzzzv")
remap("n", "N", "Nzzzv")

remap("n", "Y", "y$")
remap("n", "J", "mzJ`z")

remap("n", "<leader>ts", ':lua require("nvim-highlight-colors").toggle()<Cr>')

remap("n", "=ap", ":lua vim.lsp.buf.format()<Cr>")

-- remap for quotes
remap("n", "ciq", 'ci"')
remap("n", "ciQ", "ci'")
remap("n", "cinq", 'f"lci"')


remap("n", "viq", 'vi"')
remap("n", "viQ", "vi'")

remap("n", "yiq", 'yi"')
remap("n", "yiQ", "yi'")

-- not copy when deleting
remap("n", "x", '"_x')
remap("v", "<Del>", '"_x')

-- plugin
remap("n", "<leader>hc", ":CellularAutomaton make_it_rain<Cr>")

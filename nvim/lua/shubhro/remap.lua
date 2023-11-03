local remap = vim.keymap.set

vim.g.mapleader = " "

remap("v", "K", ":m '<-2<CR>gv=gv")
remap("v", "J", ":m '>+1<CR>gv=gv")

remap("i", "jj", "<Esc>")

-- select all
remap("n", "<C-a>", "ggVG")

remap("n", "<C-k>", "15kzz")
remap("n", "<C-j>", "15jzz")
remap("n", "n", "nzzzv")
remap("n", "N", "Nzzzv")

remap("n", "n", "nzzzv")
remap("n", "N", "Nzzzv")

remap("n", "Y", "y$")
remap("n", "J", "mzJ`z")
remap("n", "H", "0i<Cr><Esc>k")
remap("n", "L", "O<Esc>j")

remap("n", "<leader>ts", ':lua require("nvim-highlight-colors").toggle()<Cr>')

remap("n", "=ap", ":lua vim.lsp.buf.format()<Cr>")

-- remap for quotes
remap("n", "ciq", 'ci"')
remap("n", "ciQ", "ci'")
remap("n", "cinq", '0f";;lci"')
remap("n", "viq", 'vi"')
remap("n", "viQ", "vi'")
remap("n", "yiq", 'yi"')
remap("n", "yiQ", "yi'")

-- brackets
remap("n", "cic", "0f{lci{")
remap("n", "cis", "ci[")

-- not copy when deleting
remap("x", "<leader>p>", "\"_dP")
remap("n", "x", '"_x')

-- remap("n", "xl", 'V_d')
remap("v", "<Del>", '"_x')
remap("v", "x", '"_x')

-- lazy
remap("n", ":w", ':w<cr>')
-- remap("n", ":wa", ':wa<cr>')
remap("n", ":W", ':w<cr>')
remap("n", ":q<cr>", ':q<cr>')
remap("n", ":Q<cr>", ':q<cr>')
remap("n", ":qa", ':qa<cr>')
remap("n", ":Qa", ':qa<cr>')
remap("n", ":so", ':so')
remap("n", ":So", ':so')

-- plugin
remap("n", "<leader>hc", ":CellularAutomaton make_it_rain<Cr>")

-- show / hide numbers
remap('n', '<leader>sn', ':set invnumber<CR>', { noremap = true, silent = true })
remap('n', '<leader>srn', ':set invnumber <Cr> :set invrelativenumber<CR>',
    { noremap = true, silent = true })


-- replace all occurances of the current word under the cursor
remap("n", "<leader>hw", ":%s/\\<<C-r><C-w>\\>")

-- SPLITS
remap("n", "<C-down>", ":vertical resize -5<cr>")
remap("n", "<C-up>", ":vertical resize +5<cr>")
remap("n", "<C-left>", ":horizontal resize -5<cr>")
remap("n", "<C-right>", ":horizontal resize +5<cr>")

-- MACROS
-- remap("n", "@x", "0cisxjj")

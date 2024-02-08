local remap = vim.keymap.set

vim.g.mapleader = " "

-- plugin
remap("n", "<leader>hc", ":CellularAutomaton make_it_rain<Cr>")
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

remap("v", "K", ":m '<-2<CR>gv=gv")
remap("v", "J", ":m '>+1<CR>gv=gv")
remap("i", "jj", "<Esc>")

-- NORMAL MODE
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

-- remap for quotes
remap("n", "ciq", "ci'")
remap("n", "ciQ", 'ci"')
remap("n", "cinq", '0f";;lci"')
remap("n", "viq", 'vi"')
remap("n", "viQ", "vi'")
remap("n", "yiq", 'yi"')
remap("n", "yiQ", 'yi"')

-- brackets
remap("n", "cic", "0f{lci{")
remap("n", "cis", "ci[")

-- not copy when deleting
remap("x", "<leader>p>", "\"_dP")
remap("v", "x", '"_x')

-- lazy
remap("n", ":w", ":w<cr>")
-- remap("n", ":wa", ":wa<cr>")
remap("n", ":W", ":w<cr>")
-- remap("n", ":q<cr>", ":q<cr>")
-- remap("n", ":Q", ":q<cr>")
remap("n", ":qa!", ":qa!<cr>")
remap("n", ":Qa", ":qa<cr>")
remap("n", ":QA", ":qa<cr>")
remap("n", ":so", ":so<Cr>")
remap("n", ":So", ":so<Cr>")


-- show / hide relative numbers
remap("n", "<leader>sn", ":set invnumber<CR>", { noremap = true, silent = true })
remap("n", "<leader>srn", ":set invnumber <Cr> :set invrelativenumber<CR>",
    { noremap = true, silent = true })

-- signcolumn toggle
remap("n", "<leader>scy", ":set signcolumn=yes<Cr>")
remap("n", "<leader>scn", ":set signcolumn=no<Cr>")

-- replace all occurances of the current word under the cursor
remap("n", "<leader>hw", ":%s/\\<<C-r><C-w>\\>")

-- SPLITS
remap("n", "<C-down>", ":vertical resize -5<cr>")
remap("n", "<C-up>", ":vertical resize +5<cr>")
remap("n", "<C-left>", ":horizontal resize -5<cr>")
remap("n", "<C-right>", ":horizontal resize +5<cr>")

-- MACROS

-- EXPERIMENTAL
-- remap("n", ":please", "<A-q>treeeCR>")
-- remap("n", "i", ":highlight CursorLine guibg=bg guifg=bg<CR>i")
-- remap("n", "C", ":highlight CursorLine guibg=bg guifg=bg<CR>C")
-- remap("n", "A", ":highlight CursorLine guibg=bg guifg=bg<CR>A")
-- remap("n", "I", ":highlight CursorLine guibg=bg guifg=bg<CR>I")
-- remap("n", "a", ":highlight CursorLine guibg=bg guifg=bg<CR>a")

-- remap("i", "<esc>", "<esc>:highlight CursorLine guibg=bg guifg=#ffffff<Cr>")

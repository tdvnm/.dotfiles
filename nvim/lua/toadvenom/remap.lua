local remap = vim.keymap.set

vim.g.mapleader = " "

remap("v", "K", ":m '<-2<CR>gv=gv")
remap("v", "J", ":m '>+1<CR>gv=gv")
remap("i", "jj", "<Esc>")

-- clear buffer
vim.keymap.set("n", "<leader>bo", "<cmd>%bd|e#<cr>", { desc = "Close all buffers but the current one" })

-- NORMAL MODE
remap("n", "<C-k>", "<C-u>zz")
remap("n", "<C-j>", "<C-d>zz")
remap("n", "n", "nzzzv")
remap("n", "N", "Nzzzv")

remap("n", "n", "nzzzv")
remap("n", "N", "Nzzzv")

remap("n", "Y", "y$")
remap("n", "J", "mzJ`z")
remap("n", "H", "0i<Cr><Esc>k")
remap("n", "L", "O<Esc>j")

-- remap for quotes
remap("n", "ciq", 'ci"')
remap("n", "ciQ", "ci'")
remap("n", "cinq", '0f";;lci"')
remap("n", "viq", 'vi"')
remap("n", "viQ", "vi'")
remap("n", "yiq", 'yi"')
remap("n", "yiQ", 'yi"')

-- brackets
remap("n", "cic", "0f{lci{")
remap("n", "cis", "ci[")

-- not copy when deleting
remap("x", "<leader>p>", '"_dP')
remap("v", "x", '"_x')

-- show / hide relative numbers
remap("n", "<leader>sn", ":set invnumber<CR>", { noremap = true, silent = true })
remap("n", "<leader>srn", ":set invnumber <Cr> :set invrelativenumber<CR>", { noremap = true, silent = true })

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

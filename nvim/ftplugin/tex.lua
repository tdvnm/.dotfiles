-- nocal map = require("utils").map

local remap = vim.keymap.set
-- Format document
-- remap("i", "<leader>s", "<esc>:w<CR>i")
remap("n", "<leader>ss", "<C-w>j<C-left><C-left><C-left><C-w>k")

-- INSERT
remap("i", "$", "$$<esc>i")

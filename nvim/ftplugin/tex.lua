-- local map = require("utils").map

local remap = vim.keymap.set
-- Format document
remap("n", "<leader>s", ":w<CR>")
remap("n", "<leader>ss", "<C-w>j<C-left><C-left><C-left><C-w>k")

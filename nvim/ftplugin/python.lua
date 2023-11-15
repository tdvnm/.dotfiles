local remap = vim.keymap.set
-- Format document

remap("n", "<leader>q", ":vs <CR> :term python3 % <CR> i")

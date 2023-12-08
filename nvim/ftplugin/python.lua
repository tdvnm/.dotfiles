local remap = vim.keymap.set
-- Format document

remap("n", "<leader>q", ":vs <Cr> :term python3 % <CR> i")

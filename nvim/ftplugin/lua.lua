local remap = vim.keymap.set

remap("n", "<leader>q", ":vs <CR> :term lua % <CR> i")

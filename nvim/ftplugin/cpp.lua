local remap = vim.keymap.set

remap("n", "<leader>q", ":vs <CR> :term cum % <CR> i ./a.out <CR>", { noremap = true, silent = true })

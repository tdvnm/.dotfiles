vim.keymap.set("n", "<leader>tb", ":lua require'dap'.toggle_breakpoint()<Cr>")


local dap = require('dap')
dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = '~/.local/share/nvim/mason/bin/OpenDebugAD7'
}

-- vim.api.nvim_create_user_command('FTermOpen', require('FTerm').open, { bang = true })

-- vim.api.nvim_create_user_command('FTermClose', require('FTerm').close, { bang = true })

-- vim.keymap.set('n', '<C-t>', ':FTermClose<Cr>')

-- vim.api.nvim_create_user_command('FTermToggle', require('FTerm').toggle, { bang = true })
require("FTerm").setup({
    border = "rounded",
    dimensions = {
        height = 0.75,
        width = 0.75,
    },
})

vim.api.nvim_create_user_command("FTermExit", require("FTerm").exit, { bang = true })
vim.keymap.set("n", "<A-q>", require("FTerm").toggle)
vim.keymap.set("t", "<A-q>", "<C-\\><C-n><cmd>lua require('FTerm').toggle()<CR>")

vim.api.nvim_create_user_command("LiveServer", function()
    require("FTerm").run("live-server")
end, { bang = true })

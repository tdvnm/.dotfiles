require("FTerm").setup({
    border = "rounded",
    dimensions = {
        height = 1,
        width = 0.50,
        x = 1,
        y = 0
    },
})

vim.api.nvim_create_user_command("FTermExit", require("FTerm").exit, { bang = true })
vim.keymap.set("n", "<A-q>", require("FTerm").toggle)
vim.keymap.set("t", "<A-q>", "<C-\\><C-n><cmd>lua require('FTerm').toggle()<CR>")

vim.api.nvim_create_user_command("LiveServer", function()
    require("FTerm").run("live-server")
end, { bang = true })

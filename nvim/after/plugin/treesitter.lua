-- treesitter highlighting with no plugin. neovim 0.12 ships the parsers for
-- c, lua, vim, vimdoc, query and markdown, so nothing is compiled or
-- downloaded. filetypes without a parser keep the normal regex highlighting.
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserTreesitter", {}),
    callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
    end,
})

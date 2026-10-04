-- LSP
-- lua-language-server, clangd and texlab are installed by nix (packages.nix)
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("*", { capabilities = capabilities })
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
})
vim.lsp.config("clangd", {
    cmd = { "clangd", "--background-index" },
})
vim.lsp.enable({ "lua_ls", "clangd", "texlab" })

-- LSP LINT / FORMATTING
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
    },
})

-- format with stylua (null-ls) when it handles the file, else with the server
local function format(bufnr)
    local has_null_ls = #vim.lsp.get_clients({
        bufnr = bufnr,
        name = "null-ls",
        method = "textDocument/formatting",
    }) > 0
    vim.lsp.buf.format({
        bufnr = bufnr,
        filter = function(client)
            return not has_null_ls or client.name == "null-ls"
        end,
    })
end

vim.keymap.set("n", "=ap", function()
    format(0)
end)

-- format on save, only where something can format. without the check every
-- save of a plain file printed "format request failed"
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("UserFormatOnSave", {}),
    callback = function(ev)
        if #vim.lsp.get_clients({ bufnr = ev.buf, method = "textDocument/formatting" }) > 0 then
            format(ev.buf)
        end
    end,
})

-- LSP COMPLETIONS
local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ["<S-tab>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<tab>"] = cmp.mapping.select_next_item(cmp_select),
        ["<Cr>"] = cmp.mapping.confirm({ select = true }),
        ["<C-e>"] = cmp.mapping.abort(),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
    }),
})

-- diagnostic
vim.diagnostic.config({
    virtual_text = false,
    float = { border = "rounded" },
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    end,
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    callback = function()
        vim.diagnostic.open_float(nil, { focus = false })
    end,
})

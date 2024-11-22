-- LSP
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- LSP INSTALLERS
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "clangd" },
})

-- LSP LINT / FORMATTING
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
    },
})

vim.keymap.set("n", "=ap", vim.lsp.buf.format)
vim.cmd("autocmd BufWritePre * lua vim.lsp.buf.format()")

-- LSP COMPLETIONS
local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ["<S-tab>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<tab>"] = cmp.mapping.select_next_item(cmp_select),
        ["<S-Cr>"] = cmp.mapping.confirm({ select = true }),
        ["<C-e>"] = cmp.mapping.abort(),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
    }, {
        -- { name = "buffer" },
    }),
})

-- LSP SETUP
local lsp = vim.lsp
--- servers
lspconfig.tsserver.setup({
    capabilities = capabilities,
})
lspconfig.svelte.setup({
    capabilities = capabilities,
})
lspconfig.lua_ls.setup({
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
})
lspconfig.pylyzer.setup({
    capabilities = capabilities,
})
lspconfig.cssls.setup({
    capabilities = capabilities,
})
lspconfig.texlab.setup({
    capabilities = capabilities,
})
lspconfig.clangd.setup({
    capabilities = capabilities,
    cmd = { "clangd", "--background-index" },
})

--- config
lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
    -- title = "Hover",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
})

-- diagnostic on hover
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

vim.diagnostic.config({})

-- Show line diagnostics automatically in hover window
vim.o.updatetime = 950
vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

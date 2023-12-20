vim.fn.sign_define("LspDiagnosticsSignInformation", { text = "", numhl = "LspDiagnosticsDefaultInformation" })

-- Customize the LSP error and warning highlight groups with transparent backgrounds
vim.cmd([[
  highlight LspDiagnosticsVirtualTextError guibg=#ff000022
  highlight LspDiagnosticsVirtualTextWarning guibg=#ffff0022
]])

local lsp = require("lsp-zero")
lsp.preset("recommended")

lsp.ensure_installed({
    "eslint",
    "html",
    "tsserver",
    "clangd",
})

-- Fix Undefined global 'vim'
lsp.configure("lua-language-server", {
    Lua = {
        diagnostics = {
            globals = { "vim" },
        },
    },
})

-- Function to apply the configuration
local applyConfig = function()
    -- Enable cursorline
    -- vim.wo.cursorline = true

    -- Customize the line number and current line number highlight groups
    -- vim.cmd([[
    -- highlight! LineNr guifg=NONE ctermfg=NONE
    -- highlight! CursorLineNr cterm=bold ctermfg=NONE guifg=NONE
    -- ]])

    -- Set sign column width
    -- vim.wo.signcolumn = "yes:1"
    --
end

-- Apply the configuration
applyConfig()

-- lsp.set_preferences({
--     sign_icons = {
--         -- error = "󰫢 ",
--         -- warn = "󰫢 ",
--         -- info = "󰫢 ",
--         -- hint = "󰫢 ",
--     },
-- })

local cmp = require("cmp")
cmp.setup {
    formatting = {
        format = function(entry, vim_item)
            -- Get the background color based on the entry's source name
            local bg_color = ''
            if entry.source.name == 'Error' then
                bg_color = 'red'
            elseif entry.source.name == 'Warning' then
                bg_color = 'yellow'
            end

            -- Set the background color with transparency
            vim_item.menu = string.format('%s%%#Normal#', bg_color)

            return vim_item
        end,
    },
    -- snippet = {
    --     expand = function(args)
    --         require('luasnip').lsp_expand(args.body)
    --     end
    -- },
    -- sources = cmp.config.sources({
    --     { name = "nvim_lsp" },
    --     { name = "luasnip" },
    -- }),
}
local lspkind = require("lspkind")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ["<S-tab>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<tab>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-/>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})
-- cmp_mappings["<Tab>"] = nil
-- cmp_mappings["<S-Tab>"] = nil

-- C++ SETUP
require("lspconfig").clangd.setup({
    on_attach = lsp.on_attach,
    capabilities = lsp.capabilities,
    flags = lsp.flags,
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
    -- format =
    formatting = {
        fields = { "abbr", "kind", "menu" }, -- removes "menu"
        format = lspkind.cmp_format({
            -- mode = 'symbol', -- show only symbol annotations
            maxwidth = 85,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(entry, vim_item)
                vim_item.menu = "" -- This disables the "macro_rules!" etc text in Rust
                return vim_item
            end,
        }),
    },
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function()
        vim.lsp.buf.definition()
    end, opts)
    vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover()
    end, opts)
    vim.keymap.set("n", "<leader>vws", function()
        vim.lsp.buf.workspace_symbol()
    end, opts)
    vim.keymap.set("n", "<leader>vd", function()
        vim.diagnostic.open_float()
    end, opts)
    vim.keymap.set("n", "[d", function()
        vim.diagnostic.goto_next()
    end, opts)
    vim.keymap.set("n", "]d", function()
        vim.diagnostic.goto_prev()
    end, opts)
    vim.keymap.set("n", "<leader>vca", function()
        vim.lsp.buf.code_action()
    end, opts)
    vim.keymap.set("n", "<leader>vrr", function()
        vim.lsp.buf.references()
    end, opts)
    vim.keymap.set("n", "<leader>vrn", function()
        vim.lsp.buf.rename()
    end, opts)
    vim.keymap.set("i", "<C-h>", function()
        vim.lsp.buf.signature_help()
    end, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,

})

-- local cmp_nvim_lsp = require "cmp_nvim_lsp"

-- require("lspconfig").clangd.setup {
--     on_attach = on_attach,
--     capabilities = cmp_nvim_lsp.default_capabilities(),
--     cmd = {
--         "clangd",
--         "--offset-encoding=utf-16",
--     },
-- }

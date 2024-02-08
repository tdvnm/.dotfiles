local builtin = require("telescope.builtin")

-- require("telescope").load_extension('harpoon')

vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>sg", builtin.git_files, {})
vim.keymap.set("n", "<leader>sw", function()
    builtin.grep_string({ search = vim.fn.input("Search Word: ") })
end)

-- vim.api.nvim_set_keymap("n", "<A-r>", ":Telescope file_browser<Cr>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<leader>fb", ":Telescope file_browser path=%:p:h select_buffer=true<Cr>",
-- { noremap = true })

require("telescope").setup({
    -- defaults = {
    prompt_prefix = "  ",
    defaults = {
        prompt_prefix = "  ",
        selection_caret = "󰫢 ",
        layout_strategy = "horizontal",
        layout_config = {
            preview_width = 0.6, -- Adjust the preview window width
            width = 0.80,        -- Adjust the results width
        },
    },
})

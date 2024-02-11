local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>sg", builtin.git_files, {})
vim.keymap.set("n", "<leader>sw", function()
    builtin.grep_string({ search = vim.fn.input("Search Word: ") })
end)

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

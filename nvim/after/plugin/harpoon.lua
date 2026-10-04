local ui = require("harpoon.ui")
local mark = require("harpoon.mark")

-- add and remove files
vim.keymap.set("n", "<leader>e", mark.add_file)
vim.keymap.set("n", "<leader>d", mark.rm_file)

vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

-- alt+1..7 jump to harpoon slots 1-7
for i = 1, 7 do
    vim.keymap.set("n", "<A-" .. i .. ">", function()
        ui.nav_file(i)
    end)
end

vim.api.nvim_create_autocmd({ "Filetype" }, {
    pattern = "harpoon",
    callback = function()
        vim.opt.cursorline = true
        vim.api.nvim_set_hl(0, "HarpoonWindow", { link = "Normal" })
        vim.api.nvim_set_hl(0, "HarpoonBorder", { link = "Normal" })
    end,
})

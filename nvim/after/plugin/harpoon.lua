local ui = require("harpoon.ui")
local mark = require("harpoon.mark")

-- add and remove files
vim.keymap.set("n", "<leader>e", mark.add_file)
vim.keymap.set("n", "<leader>d", mark.rm_file)

vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<A-1>", function()
	ui.nav_file(1)
end)
vim.keymap.set("n", "<A-2>", function()
	ui.nav_file(2)
end)
vim.keymap.set("n", "<A-3>", function()
	ui.nav_file(3)
end)
vim.keymap.set("n", "<A-4>", function()
	ui.nav_file(4)
end)
vim.keymap.set("n", "<A-5>", function()
	ui.nav_file(5)
end)
vim.keymap.set("n", "<A-6>", function()
	ui.nav_file(6)
end)
vim.keymap.set("n", "<A-7>", function()
	ui.nav_file(7)
end)

vim.api.nvim_create_autocmd({ "Filetype" }, {
	pattern = "harpoon",
	callback = function()
		vim.opt.cursorline = true
		vim.api.nvim_set_hl(0, "HarpoonWindow", { link = "Normal" })
		vim.api.nvim_set_hl(0, "HarpoonBorder", { link = "Normal" })
	end,
})

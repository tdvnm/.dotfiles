-- vim.opt.termguicolors = true
-- require("bufferline").setup {
--     options = {
--         numbers = function(opts)
--             return string.format('%s ', opts.ordinal)
--         end,
--         show_buffer_close_icons = false,
--         show_close_icon = false,
--         show_tab_indicators = false,
--         tab_size = 10,
--         diagnostics = "nvim_lsp",
--     },
-- };


-- vim.keymap.set('n', '<A-1>', '<Cmd>BufferLineGoToBuffer 1<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<A-2>', '<Cmd>BufferLineGoToBuffer 2<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<A-3>', '<Cmd>BufferLineGoToBuffer 3<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<A-4>', '<Cmd>BufferLineGoToBuffer 4<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<A-5>', '<Cmd>BufferLineGoToBuffer 5<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<A-6>', '<Cmd>BufferLineGoToBuffer 6<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<A-7>', '<Cmd>BufferLineGoToBuffer 7<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<A-8>', '<Cmd>BufferLineGoToBuffer 8<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<A-9>', '<Cmd>BufferLineGoToBuffer 9<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<A-0>', '<Cmd>BufferLineGoToBuffer 10<CR>', { noremap = true, silent = true })


-- vim.keymap.set('n', '<A-,>', '<Cmd>BufferLineMovePrev<CR>')
-- vim.keymap.set('n', '<A-.>', '<Cmd>BufferLineMoveNext<CR>')

-- vim.keymap.set('n', '<A-h>', '<Cmd>BufferLineCyclePrev<CR>')
-- vim.keymap.set('n', '<A-l>', '<Cmd>BufferLineCycleNext<CR>')


-- -- Set inactive highlight group
-- local function set_inactive_highlight()
--     vim.cmd('hi! BufferLineInactive guibg=#ff00ff guifg=#d0d0d0')
-- end

-- Remove inactive highlight group
-- local function remove_inactive_highlight()
--     vim.cmd('hi! BufferLineInactive guibg=NONE guifg=NONE')
-- end





-- local map = vim.api.nvim_set_keymap
-- local opts = { noremap = true, silent = true }

-- -- Move to previous/next
-- map("n", "<A-,>", "<Cmd>BufferPrevious<CR>", opts)
-- map("n", "<A-.>", "<Cmd>BufferNext<CR>", opts)
-- -- Re-order to previous/next
-- map("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", opts)
-- map("n", "<A->>", "<Cmd>BufferMoveNext<CR>", opts)
-- -- Goto buffer in position...
-- map("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", opts)
-- map("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", opts)
-- map("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", opts)
-- map("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", opts)
-- map("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", opts)
-- map("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", opts)
-- map("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", opts)
-- map("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", opts)
-- map("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", opts)
-- map("n", "<A-0>", "<Cmd>BufferLast<CR>", opts)
-- -- Pin/unpin buffer
-- map("n", "<A-p>", "<Cmd>BufferPin<CR>", opts)
-- -- Close buffer
-- map("n", "<A-c>", "<Cmd>BufferClose<CR>", opts)
-- -- Wipeout buffer
-- --                 :BufferWipeout
-- -- Close commands
-- --                 :BufferCloseAllButCurrent
-- --                 :BufferCloseAllButPinned
-- --                 :BufferCloseAllButCurrentOrPinned
-- --                 :BufferCloseBuffersLeft
-- --                 :BufferCloseBuffersRight
-- -- Magic buffer-picking mode
-- map("n", "<C-p>", "<Cmd>BufferPick<CR>", opts)
-- -- Sort automatically by...
-- map("n", "<Space>bb", "<Cmd>BufferOrderByBufferNumber<CR>", opts)
-- map("n", "<Space>bd", "<Cmd>BufferOrderByDirectory<CR>", opts)
-- map("n", "<Space>bl", "<Cmd>BufferOrderByLanguage<CR>", opts)
-- map("n", "<Space>bw", "<Cmd>BufferOrderByWindowNumber<CR>", opts)

-- -- :BarbarEnable - enables barbar (enabled by default)
-- -- :BarbarDisable - very bad command, should never be used
-- -- Set barbar's options
-- require("bufferline").setup({
-- 	-- Enable/disable animations
-- 	animation = false,

-- 	-- Enable/disable auto-hiding the tab bar when there is a single buffer
-- 	auto_hide = false,

-- 	-- Enable/disable current/total tabpages indicator (top right corner)
-- 	tabpages = true,

-- 	-- Enable/disable close button
-- 	-- closable = false,

-- 	-- Enables/disable clickable tabs
-- 	--  - left-click: go to buffer
-- 	--  - middle-click: delete buffer
-- 	-- clickable = true,

-- 	-- Enables / disables diagnostic symbols
-- 	-- diagnostics = {
-- 	--   -- you can use a list
-- 	--   {enabled = true, icon = 'ﬀ'}, -- ERROR
-- 	--   {enabled = false}, -- WARN
-- 	--   {enabled = false}, -- INFO
-- 	--   {enabled = true},  -- HINT

-- 	--   -- OR `vim.diagnostic.severity`
-- 	--   [vim.diagnostic.severity.ERROR] = {enabled = true, icon = 'ﬀ'},
-- 	--   [vim.diagnostic.severity.WARN] = {enabled = false},
-- 	--   [vim.diagnostic.severity.INFO] = {enabled = false},
-- 	--   [vim.diagnostic.severity.HINT] = {enabled = true},
-- 	-- },

-- 	-- Excludes buffers from the tabline
-- 	exclude_name = { "package.json" },

-- 	-- Hide inactive buffers and file extensions. Other options are `alternate`, `current`, and `visible`.
-- 	-- hide = {extensions = true, inactive = true},

-- 	-- Disable highlighting alternate buffers
-- 	highlight_alternate = false,

-- 	-- Disable highlighting file icons in inactive buffers
-- 	highlight_inactive_file_icons = false,

-- 	-- Enable highlighting visible buffers
-- 	highlight_visible = true,

-- 	-- Enable/disable icons
-- 	-- if set to 'numbers', will show buffer index in the tabline
-- 	-- if set to 'both', will show buffer index and icons in the tabline
-- 	icons = "both",

-- 	-- If set, the icon color will follow its corresponding buffer
-- 	-- highlight group. By default, the Buffer*Icon group is linked to the
-- 	-- Buffer* group (see Highlighting below). Otherwise, it will take its
-- 	-- default value as defined by devicons.
-- 	icon_custom_colors = false,

-- 	-- Configure icons on the bufferline.
-- 	icon_separator_active = "",
-- 	icon_separator_inactive = "",
-- 	icon_close_tab = "",
-- 	icon_close_tab_modified = "",
-- 	icon_pinned = "車",

-- 	-- If true, new buffers will be inserted at the start/end of the list.
-- 	-- Default is to insert after current buffer.
-- 	insert_at_end = false,
-- 	insert_at_start = false,

-- 	-- Sets the maximum padding width with which to surround each tab
-- 	maximum_padding = 1,

-- 	-- Sets the minimum padding width with which to surround each tab
-- 	minimum_padding = 1,

-- 	-- Sets the maximum buffer name length.
-- 	maximum_length = 30,

-- 	-- If set, the letters for each buffer in buffer-pick mode will be
-- 	-- assigned based on their name. Otherwise or in case all letters are
-- 	-- already assigned, the behavior is to assign letters in order of
-- 	-- usability (see order below)
-- 	semantic_letters = true,

-- 	-- New buffer letters are assigned in this order. This order is
-- 	-- optimal for the qwerty keyboard layout but might need adjustement
-- 	-- for other layouts.
-- 	letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",

-- 	-- Sets the name of unnamed buffers. By default format is "[Buffer X]"
-- 	-- where X is the buffer number. But only a static string is accepted here.
-- 	no_name_title = nil,
-- })

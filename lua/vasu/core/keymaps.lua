-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Window focus
vim.keymap.set("n", "]w", "<C-w>w", { desc = "Next window" })
vim.keymap.set("n", "[w", "<C-w>W", { desc = "Previous window" })

-- Split management
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })

-- Create splits
vim.keymap.set("n", "||", "<cmd>vsplit<CR>", { desc = "Vertical split" })
vim.keymap.set("n", "//", "<cmd>split<CR>", { desc = "Horizontal split" })
-- vim.keymap.set("n", "]s", "<cmd>vsplit<CR>", { desc = "Vertical split" })
-- vim.keymap.set("n", "[s", "<cmd>split<CR>", { desc = "Horizontal split" })

-- Resize splits
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { silent = true, desc = "Increase height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { silent = true, desc = "Decrease height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize +2<CR>", { silent = true, desc = "Decrease width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize -2<CR>", { silent = true, desc = "Increase width" })

-- Close splits / windows
vim.keymap.set("n", "]c", "<C-w>c", { desc = "Close current split" })
vim.keymap.set("n", "]o", "<C-w>o", { desc = "Close other splits (only this one)" })

-- Tab navigation
vim.keymap.set("n", "]t", "<cmd>tabnext<CR>", { silent = true, desc = "Next tab" })
vim.keymap.set("n", "[t", "<cmd>tabprevious<CR>", { silent = true, desc = "Previous tab" })
vim.keymap.set("n", "]tn", "<cmd>tabnew<CR>", { silent = true, desc = "New tab" })
vim.keymap.set("n", "]tc", "<cmd>tabclose<CR>", { silent = true, desc = "Close tab" })

-- Buffer navigation
vim.keymap.set("n", "]b", "<cmd>bnext<CR>", { silent = true, desc = "Next buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<CR>", { silent = true, desc = "Previous buffer" })
vim.keymap.set("n", "]B", "<cmd>blast<CR>", { silent = true, desc = "Last buffer" })
vim.keymap.set("n", "[B", "<cmd>bfirst<CR>", { silent = true, desc = "First buffer" })

-- Move buffer between windows
vim.keymap.set("n", "<leader>bh", "<C-w>h<C-w>r", { desc = "Move buffer left" })
vim.keymap.set("n", "<leader>bl", "<C-w>l<C-w>r", { desc = "Move buffer right" })
vim.keymap.set("n", "<leader>bj", "<C-w>j<C-w>r", { desc = "Move buffer down" })
vim.keymap.set("n", "<leader>bk", "<C-w>k<C-w>r", { desc = "Move buffer up" })

-- Switch focus between Neo-tree and editor
vim.keymap.set("n", "<leader>o", function()
	local current_buf = vim.api.nvim_get_current_buf()
	local current_ft = vim.api.nvim_get_option_value("filetype", { buf = current_buf })

	if current_ft == "neo-tree" then
		-- If in Neo-tree, move to a normal editor window
		vim.cmd "wincmd l"

		-- If still in Neo-tree, find first non-Neo-tree window
		local buf_after = vim.api.nvim_get_current_buf()
		local ft_after = vim.api.nvim_get_option_value("filetype", { buf = buf_after })

		if ft_after == "neo-tree" then
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
				if ft ~= "neo-tree" and ft ~= "toggleterm" then
					vim.api.nvim_set_current_win(win)
					break
				end
			end
		end
	else
		-- If in editor, focus Neo-tree or open it
		local tree_found = false
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
			if ft == "neo-tree" then
				vim.api.nvim_set_current_win(win)
				tree_found = true
				break
			end
		end

		if not tree_found then vim.cmd "Neotree toggle" end
	end
end, { desc = "Switch focus between Neo-tree and editor" })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

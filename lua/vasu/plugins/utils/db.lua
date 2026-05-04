-- lua/vasu/plugins/utils/db.lua

-- vim-dadbod configuration
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_show_database_icon = 1
vim.g.db_ui_force_echo_notifications = 1
vim.g.db_ui_win_position = "left"
vim.g.db_ui_winwidth = 40

-- Keymaps
vim.keymap.set("n", "<leader>du", "<cmd>DBUIToggle<cr>", { desc = "Database UI Toggle" })
vim.keymap.set("n", "<leader>db", "<cmd>DBUI<cr>", { desc = "Database UI Open" })
vim.keymap.set("n", "<leader>df", "<cmd>DBUIFindBuffer<cr>", { desc = "Database UI Find Buffer" })
vim.keymap.set("n", "<leader>dr", "<cmd>DBUIRenameBuffer<cr>", { desc = "Database UI Rename Buffer" })
vim.keymap.set("n", "<leader>dl", "<cmd>DBUILastQueryInfo<cr>", { desc = "Database UI Last Query" })

-- Autocmd for vim-dadbod-completion
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sql", "mysql", "plsql" },
	callback = function()
		require("cmp").setup.buffer {
			sources = {
				{ name = "vim-dadbod-completion" },
				{ name = "buffer" },
			},
		}
	end,
})

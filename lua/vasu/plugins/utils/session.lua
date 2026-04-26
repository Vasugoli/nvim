-- ── Keymaps (immediate — functions are lazy-loaded when called) ──────────────
vim.keymap.set("n", "<leader>wr", "<cmd>AutoSession search<CR>", { desc = "Session search" })
vim.keymap.set("n", "<leader>ws", "<cmd>AutoSession save<CR>", { desc = "Save session" })
vim.keymap.set("n", "<leader>wa", "<cmd>AutoSession toggle<CR>", { desc = "Toggle session autosave" })

-- ── Setup (deferred so vim.pack runtimepath is fully ready) ─────────────────
local session = require "auto-session"
session.setup {
	session_lens = {
		picker = "telescope", -- auto-detected; falls back to vim.ui.select
		mappings = {
			delete_session = { "i", "<C-d>" },
			alternate_session = { "i", "<C-s>" },
			copy_session = { "i", "<C-y>" },
		},
		picker_opts = {
			preset = "dropdown",
			preview = false,
			layout = { width = 0.4, height = 0.4 },
		},
		auto_save_enabled = true,
		auto_restore_enabled = true,
	},
}

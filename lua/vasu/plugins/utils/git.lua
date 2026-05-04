-- gitsigns.nvim
require("gitsigns").setup {
	signs = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "" },
		topdelete = { text = "" },
		changedelete = { text = "┃" },
		untracked = { text = "┆" },
	},
	signs_staged = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "" },
		topdelete = { text = "" },
		changedelete = { text = "┃" },
		untracked = { text = "┆" },
	},
	signs_staged_enable = true,
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = { follow_files = true },
	auto_attach = true,
	attach_to_untracked = true,
	current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
		virt_text_priority = 100,
		use_focus = true,
	},
	current_line_blame_formatter = "   <author> • <author_time:%R> • <summary>",
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil,
	max_file_length = 40000,
	preview_config = {
		border = "rounded",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns
		local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc }) end

		-- Navigation
		map("n", "]h", function()
			if vim.wo.diff then return "]h" end
			vim.schedule(function() gs.next_hunk() end)
			return "<Ignore>"
		end, "Next Hunk")

		map("n", "[h", function()
			if vim.wo.diff then return "[h" end
			vim.schedule(function() gs.prev_hunk() end)
			return "<Ignore>"
		end, "Prev Hunk")

		-- Actions
		map("n", "ghs", gs.stage_hunk, "Stage Hunk")
		map("n", "ghr", gs.reset_hunk, "Reset Hunk")
		map("v", "ghs", function() gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" } end, "Stage Hunk")
		map("v", "ghr", function() gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" } end, "Reset Hunk")
		map("n", "ghS", gs.stage_buffer, "Stage Buffer")
		map("n", "ghR", gs.reset_buffer, "Reset Buffer")
		map("n", "ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
		map("n", "ghp", gs.preview_hunk, "Preview Hunk")
		map("n", "ghb", function() gs.blame_line { full = true } end, "Blame Line")
		map("n", "gub", gs.toggle_current_line_blame, "Toggle Line Blame")
		map("n", "ghd", gs.diffthis, "Diff This")
		map("n", "ghD", function() gs.diffthis "~" end, "Diff This ~")
		map("n", "gtd", gs.toggle_deleted, "Toggle Deleted")

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns Select Hunk")
	end,
}

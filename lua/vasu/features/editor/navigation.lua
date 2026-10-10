-- lua/vasu/features/editor/navigation.lua
-- Fast file finders & motion jumps (fff.nvim, flash.nvim, yazi.nvim)

-- ── Flash (motion jump & treesitter selection) ──────────────────────────────
local ok_flash, flash = pcall(require, "flash")
if ok_flash then
	flash.setup({})
	vim.keymap.set({ "n", "x", "o" }, "s", function() flash.jump() end, { desc = "Flash" })
	vim.keymap.set({ "n", "x", "o" }, "S", function() flash.treesitter() end, { desc = "Flash Treesitter" })
	vim.keymap.set("o", "r", function() flash.remote() end, { desc = "Remote Flash" })
	vim.keymap.set({ "o", "x" }, "R", function() flash.treesitter_search() end, { desc = "Treesitter Search" })
	vim.keymap.set("c", "<c-s>", function() flash.toggle() end, { desc = "Toggle Flash Search" })
end

-- ── Yazi (terminal file manager) ─────────────────────────────────────────────
local ok_yazi, yazi = pcall(require, "yazi")
if ok_yazi then
	yazi.setup({})
	vim.keymap.set("n", "<c-up>", "<cmd>Yazi toggle<cr>", { desc = "Resume the last yazi session" })
	vim.keymap.set({ "n", "v" }, "<leader>-", "<cmd>Yazi<cr>", { desc = "Open yazi at the current file" })
	vim.keymap.set("n", "<leader>cd", "<cmd>Yazi cwd<cr>", { desc = "Open the file manager in nvim's working directory" })
end

-- ── FFF (fast file finder) ───────────────────────────────────────────────────
local ok_fff, fff = pcall(require, "fff")
if ok_fff then
	fff.setup {
		install = { timeout = 1200 },
		prompt_vim_mode = true,
		title = "Find Files",
		max_results = 100,
		max_threads = 4,
		lazy_sync = true,
		prompt = "🛸 ",
		layout = {
			width = 0.75,
			height = 0.85,
			prompt_position = "top",
			preview_position = "right",
			preview_size = 0.5,
			show_scrollbar = true,
		},
		preview = {
			enabled = true,
			max_lines = 100,
			max_size = 10 * 1024 * 1024,
			chunk_size = 8192,
			binary_file_threshold = 1024,
			line_numbers = false,
			wrap_lines = false,
			history = {
				enabled = true,
				db_path = vim.fn.stdpath "data" .. "/fff_queries",
				min_combo_count = 3,
				combo_boost_score_multiplier = 100,
			},
		},
		keymaps = {
			close = { "<C-c>", "<Esc>" },
			select = "<CR>",
			select_split = "<C-s>",
			select_vsplit = "<C-v>",
			select_tab = "<C-t>",
			move_up = { "<Up>", "<C-p>", "<C-k>" },
			move_down = { "<Down>", "<C-n>", "<C-j>" },
			preview_scroll_up = "<C-u>",
			preview_scroll_down = "<C-d>",
		},
		git = { status_text_color = true },
		hl = {
			border = "FloatBorder",
			normal = "Normal",
			cursor = "CursorLine",
			matched = "IncSearch",
			title = "Title",
			prompt = "Question",
			active_file = "Visual",
			frecency = "Number",
			debug = "Comment",
			git_staged = "FFFGitStaged",
			git_modified = "FFFGitModified",
			git_deleted = "FFFGitDeleted",
			git_renamed = "FFFGitRenamed",
			git_untracked = "FFFGitUntracked",
			git_ignored = "FFFGitIgnored",
		},
		frecency = {
			enabled = true,
			db_path = vim.fn.stdpath "cache" .. "/fff_nvim",
		},
		debug = {
			enabled = true,
			show_scores = true,
		},
	}

	vim.keymap.set("n", "<leader>ff", function() fff.find_files() end, { desc = "Open file picker" })
	vim.keymap.set("n", "<leader>lg", function()
		fff.live_grep { modes = { "fuzzy", "plain" } }
	end, { desc = "Live fffuzy grep word" })
	vim.keymap.set("n", "<leader>fg", function() fff.find_in_git_root() end, { desc = "Find files in git root" })
	vim.keymap.set("n", "<leader>fc", function()
		fff.find_files_in_dir(vim.fn.stdpath "config")
	end, { desc = "Find files in NVIM Config dir" })
end

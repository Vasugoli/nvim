-- nvim-telescope/telescope.nvim — fuzzy finder
local telescope = require "telescope"
local actions = require "telescope.actions"
local trouble = require "trouble.sources.telescope"
local builtin = require "telescope.builtin"
local keymap = vim.keymap.set

telescope.setup {
	defaults = {
		prompt_prefix = "🔭 ",
		selection_caret = "  ",
		path_display = { "smart" },
		sorting_strategy = "ascending",
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				prompt_position = "bottom",
				preview_width = 0.5,
			},
			width = 0.75,
			height = 0.85,
		},
		file_ignore_patterns = {
			"node_modules",
			".git/",
			"dist/",
			"build/",
		},
		mappings = {
			i = {
				["<C-k>"] = actions.move_selection_previous,
				["<C-j>"] = actions.move_selection_next,
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
				["<C-t>"] = trouble.open,
				["<C-u>"] = false,
				["<C-x>"] = actions.delete_buffer,
			},
			n = {
				["q"] = actions.close,
				["<C-t>"] = trouble.open,
			},
		},
	},
	pickers = {
		live_grep = {
			additional_args = function(_opts) return { "--hidden", "--no-ignore" } end,
			glob_pattern = "!{.git,node_modules,dist,build}/*",
		},
		grep_string = {
			word_match = "-w",
			only_sort_text = true,
		},
		find_files = {
			previewer = true,
			hidden = true,
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		},
		buffers = {
			previewer = false,
			sort_mru = true,
			sort_lastused = true,
		},
		help_tags = {
			previewer = true,
		},
		colorscheme = {
			enable_preview = true,
		},
		commands = {},
	},
	extensions = {
		notify = {
			enabled = true,
		},
	},
}

-- ── Keymaps ──────────────────────────────────────────────────────────────────

-- Live grep in files
keymap("n", "<leader>tg", builtin.live_grep, { desc = "Live grep in files" })

-- Live grep in current buffer's directory
-- keymap("n", "<leader>fb", function()
--     builtin.live_grep({
--         prompt_title = "Live Grep in Current Buffer",
--         search_dirs  = { vim.fn.expand("%:p:h") },
--     })
-- end, { desc = "Live grep in current directory" })

-- Live grep in Lua files
keymap("n", "<leader>fL", function()
	builtin.live_grep {
		prompt_title = "Live Grep in Lua Files",
		type_filter = "lua",
		additional_args = function() return { "--type", "lua" } end,
	}
end, { desc = "Live grep in Lua files" })

-- Live grep in JS/TS files
keymap("n", "<leader>fJ", function()
	builtin.live_grep {
		prompt_title = "Live Grep in JS/TS Files",
		additional_args = function() return { "--type", "js", "--type", "ts", "--type", "jsx", "--type", "tsx" } end,
	}
end, { desc = "Live grep in JS/TS files" })

-- Find todos
keymap("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

-- Notification history via telescope-notify extension (if available)
keymap("n", "<leader>hn", function()
	if pcall(telescope.load_extension, "notify") then
		telescope.extensions.notify.notify()
	else
		vim.notify("Telescope notify extension not available", vim.log.levels.WARN)
	end
end, { desc = "Notification history" })

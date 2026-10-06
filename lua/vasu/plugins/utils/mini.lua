-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
local ai = require "mini.ai"
ai.setup {
	-- Table with textobject id as fields, textobject specification as values.
	-- Also use this to disable builtin textobjects. See |MiniAi.config|.
	custom_textobjects = {
		-- Define 'k' as a custom textobject for the entire buffer
		k = function()
			local from = { line = 1, col = 1 }
			local to = {
				line = vim.fn.line "$",
				col = math.max(vim.fn.getline("$"):len(), 1),
			}
			return { from = from, to = to }
		end,
	},

	-- Module mappings. Use `''` (empty string) to disable one.
	mappings = {
		-- Main textobject prefixes
		around = "a",
		inside = "i",

		-- Next/last textobjects
		-- NOTE: These override built-in LSP selection mappings on Neovim>=0.12
		-- Map LSP selection manually to use it (see `:h MiniAi.config`)
		around_next = "ax",
		inside_next = "ix",
		around_last = "al",
		inside_last = "il",

		-- Move cursor to corresponding edge of `a` textobject
		goto_left = "g[",
		goto_right = "g]",
	},

	-- Number of lines within which textobject is searched
	n_lines = 500,

	-- How to search for object (first inside current line, then inside
	-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
	-- 'cover_or_nearest', 'next', 'prev', 'nearest'.
	search_method = "cover_or_next",

	-- Whether to disable showing non-error feedback
	-- This also affects (purely informational) helper messages shown after
	-- idle time if user input is required.
	silent = false,
}

local miniSplitJoin = require "mini.splitjoin"
miniSplitJoin.setup {
	mappings = { toggle = "" }, -- Disable default mapping
}
vim.keymap.set({ "n", "x" }, "mj", function() miniSplitJoin.join() end, { desc = "Join arguments" })
vim.keymap.set({ "n", "x" }, "mk", function() miniSplitJoin.split() end, { desc = "Split arguments" })

local move = require "mini.move"
move.setup( -- No need to copy this inside `setup()`. Will be used automatically.
	{
		-- Module mappings. Use `''` (empty string) to disable one.
		mappings = {
			-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
			left = "<M-h>",
			right = "<M-l>",
			down = "<M-j>",
			up = "<M-k>",

			-- Move current line in Normal mode
			line_left = "<M-h>",
			line_right = "<M-l>",
			line_down = "<M-j>",
			line_up = "<M-k>",
		},

		-- Options which control moving behavior
		options = {
			-- Automatically reindent selection during linewise vertical move
			reindent_linewise = true,
		},
	}
)

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
local surround = require "mini.surround"
surround.setup {
	-- Add custom surroundings to be used on top of builtin ones. For more
	-- information with examples, see `:h MiniSurround.config`.
	custom_surroundings = nil,

	-- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
	highlight_duration = 300,

	-- Module mappings. Use `''` (empty string) to disable one.
	-- INFO:
	-- saiw surround with no whitespace
	-- saw surround with whitespace
	mappings = {
		add = "sa", -- Add surrounding in Normal and Visual modes
		delete = "ds", -- Delete surrounding
		find = "sf", -- Find surrounding (to the right)
		find_left = "sF", -- Find surrounding (to the left)
		highlight = "sh", -- Highlight surrounding
		replace = "sr", -- Replace surrounding
		update_n_lines = "sn", -- Update `n_lines`

		suffix_last = "l", -- Suffix to search with "prev" method
		suffix_next = "n", -- Suffix to search with "next" method
	},

	-- Number of lines within which surrounding is searched
	n_lines = 20,

	-- Whether to respect selection type:
	-- - Place surroundings on separate lines in linewise mode.
	-- - Place surroundings on each line in blockwise mode.
	respect_selection_type = false,

	-- How to search for surrounding (first inside current line, then inside
	-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
	-- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
	-- see `:h MiniSurround.config`.
	search_method = "cover",

	-- Whether to disable showing non-error feedback
	silent = false,
}

-- Commenting module. Supports both `gc` and `gb` mappings (like vim-commentary),
local miniComment = require "mini.comment"
miniComment.setup()

-- Bracketed some useful keymaps. See `:h MiniBracketed` for more details.
local miniBracketed = require "mini.bracketed"
miniBracketed.setup()

local miniNotify = require "mini.notify"

-- Level icons for notification formatting
local level_icons = {
	ERROR = " ",
	WARN = " ",
	INFO = " ",
	DEBUG = " ",
	TRACE = "✎ ",
}

miniNotify.setup {
	content = {
		-- Show level icon + message, collapse newlines to single line
		format = function(notif)
			local icon = level_icons[notif.level] or " "
			local msg = notif.msg:gsub("\n", " ")
			return icon .. msg
		end,
		-- Newest notification on top — ts_update is the correct field (see :h MiniNotify-specification)
		sort = function(notif_arr)
			table.sort(notif_arr, function(a, b) return (a.ts_update or 0) > (b.ts_update or 0) end)
			return notif_arr
		end,
	},
	window = {
		-- Top-right corner — defaults from docs are already NE/columns/0
		-- Override only border and zindex; let mini handle row/col/width automatically
		config = function()
			return {
				anchor = "NE",
				col = vim.o.columns,
				row = 1,
				border = "rounded",
				zindex = 999,
			}
		end,
		winblend = 15,
		max_width_share = 0.4,
	},
	lsp_progress = {
		enable = true,
		duration_last = 1000,
	},
}

-- make_notify() controls per-level duration and highlight groups
-- ERROR/WARN stay longer (5s default), INFO shorter, DEBUG/TRACE hidden
vim.notify = MiniNotify.make_notify {
	ERROR = { duration = 6000, hl_group = "DiagnosticError" },
	WARN = { duration = 5000, hl_group = "DiagnosticWarn" },
	INFO = { duration = 3000, hl_group = "DiagnosticInfo" },
	DEBUG = { duration = 0, hl_group = "DiagnosticHint" },
	TRACE = { duration = 0, hl_group = "DiagnosticOk" },
}

-- History keymap — show all past notifications in a scratch buffer
vim.keymap.set("n", "<leader>hn", function() MiniNotify.show_history() end, { desc = "Notification history" })
-- Align text by pattern. See `:h MiniAlign` for more details.
-- local miniAlign = require "mini.align"
-- miniAlign.setup()

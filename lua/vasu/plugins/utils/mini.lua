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
miniComment.setup {
	options = {
		custom_commentstring = function()
			return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
		end,
	},
}

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

-- Auto pairs. See `:h MiniPairs` for more details.
local miniPairs = require "mini.pairs"
miniPairs.setup {
	mappings = {
		-- Disable default mapping for <BS> in insert mode
		["<BS>"] = false,
	},
}

-- Sessions Management. See `:h MiniSessions` for more details.
local miniSessions = require "mini.sessions"

-- Decode URL-encoded session filenames (e.g. C%3A%5CDeveloper -> C:\Developer)
local function session_label(filename)
	return (filename:gsub("%.vim$", ""):gsub("%%(%x%x)", function(h)
		return string.char(tonumber(h, 16))
	end))
end

miniSessions.setup {
	-- Auto-load latest global session when Neovim opens without file arguments
	autoread = true,

	-- Automatically write current session before leaving it
	autowrite = true,

	-- Directory for global sessions
	directory = vim.fn.stdpath "data" .. "/sessions",

	-- File name for local session (stored in cwd). Empty = disable local sessions
	file = "",

	-- Whether to force possibly harmful actions (e.g. loss of unsaved buffer)
	force = { read = false, write = true, delete = false },

	-- Hook functions for the lifecycle
	hooks = {
		pre  = { read = nil, write = nil, delete = nil },
		post = {
			read = function()
				local label = session_label(vim.fn.fnamemodify(vim.v.this_session, ":t"))
				vim.notify("󰦛  Session restored: " .. label, vim.log.levels.INFO)
			end,
			write  = nil,
			delete = nil,
		},
	},

	-- Print session info on write / delete
	verbose = { read = false, write = true, delete = true },
}

-- ── MiniSessions Keymaps (<leader>w = workspace/session) ─────────────────────
local map = vim.keymap.set

-- Write / overwrite current session
map("n", "<leader>ws", function()
	local name = vim.v.this_session ~= "" and vim.fn.fnamemodify(vim.v.this_session, ":t") or nil
	miniSessions.write(name)
end, { desc = "Session: save current" })

-- Save with a new name (prompted)
map("n", "<leader>wS", function()
	vim.ui.input({ prompt = "Session name: " }, function(name)
		if name and name ~= "" then miniSessions.write(name) end
	end)
end, { desc = "Session: save as…" })

-- Search / load a session (pick from list — shows clean names)
map("n", "<leader>wr", function()
	local names = vim.tbl_keys(miniSessions.detected)
	if #names == 0 then
		vim.notify("No sessions found", vim.log.levels.WARN)
		return
	end
	table.sort(names)
	vim.ui.select(names, {
		prompt = "Load session:",
		format_item = session_label,
	}, function(choice)
		if choice then miniSessions.read(choice) end
	end)
end, { desc = "Session: search / load" })

-- Delete a session (pick from list — shows clean names)
map("n", "<leader>wd", function()
	local names = vim.tbl_keys(miniSessions.detected)
	if #names == 0 then
		vim.notify("No sessions found", vim.log.levels.WARN)
		return
	end
	table.sort(names)
	vim.ui.select(names, {
		prompt = "Delete session:",
		format_item = session_label,
	}, function(choice)
		if choice then miniSessions.delete(choice) end
	end)
end, { desc = "Session: delete" })

-- List all sessions (decoded names + modify time)
map("n", "<leader>wl", function()
	local lines = {}
	for name, info in pairs(miniSessions.detected) do
		table.insert(lines, string.format("  • %s  (%s)", session_label(name), info.modify_time))
	end
	if #lines == 0 then
		vim.notify("No sessions detected", vim.log.levels.INFO)
	else
		table.sort(lines)
		vim.notify("Sessions:\n" .. table.concat(lines, "\n"), vim.log.levels.INFO)
	end
end, { desc = "Session: list all" })


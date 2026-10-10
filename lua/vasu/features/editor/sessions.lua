-- lua/vasu/features/editor/sessions.lua
-- Session management powered by mini.sessions

local miniSessions = require "mini.sessions"

-- Decode URL-encoded session filenames (e.g. C%3A%5CDeveloper -> C:\Developer)
local function session_label(filename)
	return (filename:gsub("%.vim$", ""):gsub("%%(%x%x)", function(h)
		return string.char(tonumber(h, 16))
	end))
end

miniSessions.setup {
	-- Auto-reading handled manually below to avoid "no detected sessions" warning
	autoread = false,

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
		pre = { read = nil, write = nil, delete = nil },
		post = {
			read = function()
				local label = session_label(vim.fn.fnamemodify(vim.v.this_session, ":t"))
				vim.notify("󰦛  Session restored: " .. label, vim.log.levels.INFO)
			end,
			write = nil,
			delete = nil,
		},
	},

	-- Print session info on write / delete
	verbose = { read = false, write = true, delete = true },
}

-- Auto-load latest session ONLY when one exists (avoids startup warning when empty)
vim.api.nvim_create_autocmd("VimEnter", {
	nested = true,
	callback = function()
		if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == "" then
			local detected = miniSessions.detected
			if detected and vim.tbl_count(detected) > 0 then
				miniSessions.read()
			end
		end
	end,
	desc = "Auto-read session only if sessions are detected",
})

-- ── MiniSessions Keymaps (<leader>w = workspace/session) ─────────────────────
local map = vim.keymap.set

-- Write / overwrite current session (prompts for name if no active session)
map("n", "<leader>ws", function()
	if vim.v.this_session ~= "" then
		local name = vim.fn.fnamemodify(vim.v.this_session, ":t")
		miniSessions.write(name)
	else
		vim.ui.input({ prompt = "No active session. Save as: ", default = vim.fn.fnamemodify(vim.fn.getcwd(), ":t") }, function(name)
			if name and name ~= "" then
				miniSessions.write(name)
			end
		end)
	end
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

-- lua/vasu/features/ui/statusline.lua
-- Heirline statusline configuration

local conditions = require "heirline.conditions"
local devicons = require "nvim-web-devicons"

local function get_hl(name)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
	if not ok then return nil end
	local fg = hl.fg and string.format("#%06x", hl.fg) or "NONE"
	local bg = hl.bg and string.format("#%06x", hl.bg) or "NONE"
	return { fg = fg, bg = bg }
end

local colors = {
	bg = get_hl("Normal").bg,
	fg = get_hl("Normal").fg,
	dim = get_hl("Comment").fg,
	blue = get_hl("Function").fg,
	green = get_hl("String").fg,
	purple = get_hl("Statement").fg,
	red = get_hl("Error").fg,
	orange = get_hl("DiagnosticWarn").fg,
	yellow = get_hl("DiagnosticWarn").fg,
	cyan = get_hl("Identifier").fg,
}

local Align = { provider = "%=" }

--------------------------------------------------
-- MODE
--------------------------------------------------
local ViMode = {
	init = function(self) self.mode = vim.fn.mode(1) end,
	static = {
		names = {
			n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE",
			["\22"] = "V-BLOCK", c = "COMMAND", R = "REPLACE", t = "TERMINAL",
		},
		icons = {
			n = "󰋜", i = "󰏫", v = "󰈈", V = "󰈈",
			["\22"] = "󰈈", c = "󰘳", R = "󰛔", t = "",
		},
		colors = {
			n = "blue", i = "green", v = "purple", V = "purple",
			["\22"] = "purple", c = "orange", R = "red", t = "cyan",
		},
	},
	provider = function(self)
		local m = self.mode:sub(1, 1)
		return " " .. (self.icons[m] or "") .. " " .. (self.names[self.mode] or self.mode) .. " "
	end,
	hl = function(self)
		local m = self.mode:sub(1, 1)
		return { fg = colors.bg, bg = colors[self.colors[m]], bold = true }
	end,
	update = "ModeChanged",
}

--------------------------------------------------
-- FILE
--------------------------------------------------
local File = {
	init = function(self)
		self.name = vim.fn.expand "%:t"
		self.ext = vim.fn.expand "%:e"
		self.icon = devicons.get_icon(self.name, self.ext, { default = true })
	end,
	provider = function(self)
		if self.name == "" then return " 󰈤 [No Name] " end
		return " " .. (self.icon or "󰈤") .. " " .. self.name .. (vim.bo.modified and " ●" or "") .. " "
	end,
	hl = { fg = colors.fg },
}

--------------------------------------------------
-- GIT BRANCH
--------------------------------------------------
local Git = {
	condition = conditions.is_git_repo,
	init = function(self) self.status = vim.b.gitsigns_status_dict end,
	provider = function(self) return "  " .. self.status.head .. " " end,
	hl = { fg = colors.purple },
}

--------------------------------------------------
-- GIT DIFF
--------------------------------------------------
local GitDiff = {
	condition = conditions.is_git_repo,
	init = function(self) self.status = vim.b.gitsigns_status_dict end,
	provider = function(self)
		local parts = {}
		if self.status.added and self.status.added > 0 then table.insert(parts, " " .. self.status.added) end
		if self.status.changed and self.status.changed > 0 then table.insert(parts, " " .. self.status.changed) end
		if self.status.removed and self.status.removed > 0 then table.insert(parts, " " .. self.status.removed) end
		if #parts == 0 then return "" end
		return " " .. table.concat(parts, "  ") .. " "
	end,
	hl = { fg = colors.dim },
}

--------------------------------------------------
-- DIAGNOSTICS
--------------------------------------------------
local Diagnostics = {
	condition = conditions.has_diagnostics,
	static = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
	init = function(self)
		local sev = vim.diagnostic.severity
		self.errors = #vim.diagnostic.get(0, { severity = sev.ERROR })
		self.warnings = #vim.diagnostic.get(0, { severity = sev.WARN })
		self.info = #vim.diagnostic.get(0, { severity = sev.INFO })
		self.hints = #vim.diagnostic.get(0, { severity = sev.HINT })
	end,
	provider = function(self)
		return " "
			.. (self.errors > 0 and self.error .. self.errors .. " " or "")
			.. (self.warnings > 0 and self.warn .. self.warnings .. " " or "")
			.. (self.info > 0 and self.info .. self.info .. " " or "")
			.. (self.hints > 0 and self.hint .. self.hints .. " " or "")
	end,
	hl = { fg = colors.red },
	update = { "DiagnosticChanged", "BufEnter" },
}

--------------------------------------------------
-- CENTERED LSP (NEON CAPSULE)
--------------------------------------------------
local LSP = {
	condition = function()
		for _, c in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
			if c.name ~= "copilot" then return true end
		end
		return false
	end,
	provider = function()
		local names, seen = {}, {}
		local blacklist = { ["copilot"] = true, ["github copilot"] = true, ["null-ls"] = true, ["stylua"] = true }
		local rename = { lua_ls = "LuaLS", pyright = "Pyright", tsserver = "TS", gopls = "Go", clangd = "C/C++", rust_analyzer = "Rust" }
		for _, client in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
			local name = client.name:lower()
			if not blacklist[name] then
				local display = rename[name] or client.name
				if not seen[display] then
					table.insert(names, display)
					seen[display] = true
				end
			end
		end
		if #names == 0 then return "" end
		return "󰅩 " .. table.concat(names, ", ") .. " "
	end,
	hl = { fg = colors.cyan, bold = true },
}

--------------------------------------------------
-- DAP STATUS
--------------------------------------------------
local DAP = {
	condition = function()
		local dap = package.loaded["dap"]
		return dap and dap.session() ~= nil
	end,
	provider = function()
		local dap = package.loaded["dap"]
		if not dap then return "" end
		local status = dap.status()
		if status == "" then return "" end
		return "  " .. status .. " "
	end,
	hl = { fg = colors.red, bold = true },
}

local node_version
if vim.fn.executable "node" == 1 then
	local cmd = vim.fn.has "win32" == 1 and "node -v 2>nul" or "node -v 2>/dev/null"
	local handle = io.popen(cmd)
	if handle then
		local result = handle:read "*a"
		handle:close()
		node_version = result and result:match "v(%d+)"
	end
end

--------------------------------------------------
-- PROJECT CAPSULE
--------------------------------------------------
local ProjectCapsule = {
	provider = function()
		local parts = {}
		local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
		table.insert(parts, "󰉋 " .. cwd)

		local venv = os.getenv "VIRTUAL_ENV"
		if venv then
			local name = vim.fn.fnamemodify(venv, ":t")
			table.insert(parts, "󰌠 " .. name)
		end

		if node_version then
			table.insert(parts, "󰎙 v" .. node_version)
		end

		return " " .. table.concat(parts, " | ") .. " "
	end,
	hl = { fg = colors.dim },
}

--------------------------------------------------
-- CLOCK
--------------------------------------------------
local Clock = {
	provider = function() return "  " .. os.date "%H:%M:%S" .. " " end,
	hl = { fg = colors.yellow },
}

--------------------------------------------------
-- RULER
--------------------------------------------------
local Ruler = { provider = " %l:%c  %P ", hl = { fg = colors.yellow } }

--------------------------------------------------
-- SCROLLBAR
--------------------------------------------------
local ScrollBar = {
	static = { sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" } },
	provider = function(self)
		local curr = vim.api.nvim_win_get_cursor(0)[1]
		local total = math.max(vim.api.nvim_buf_line_count(0), 1)
		local i = math.floor((curr - 1) / total * #self.sbar) + 1
		return self.sbar[i]
	end,
	hl = { fg = colors.blue },
}

--------------------------------------------------
-- START SCREEN DETECTION & STATUSLINE SETUP
--------------------------------------------------
local function is_start_screen()
	local buf = vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_is_valid(buf) then return false end
	local ft = vim.bo[buf].filetype
	local bt = vim.bo[buf].buftype
	local name = vim.api.nvim_buf_get_name(buf)

	if vim.tbl_contains({ "snacks_dashboard", "alpha", "dashboard", "starter" }, ft) then
		return true
	end

	if name == "" and ft == "" and bt == "" and not vim.bo[buf].modified then
		local count = vim.api.nvim_buf_line_count(buf)
		if count <= 1 then
			local lines = vim.api.nvim_buf_get_lines(buf, 0, 1, false)
			return not lines[1] or lines[1] == ""
		end
	end

	return false
end

local MainStatusline = {
	condition = function() return not is_start_screen() end,
	ViMode,
	File,
	Git,
	GitDiff,
	Diagnostics,
	Align,
	LSP,
	Align,
	DAP,
	ProjectCapsule,
	Clock,
	Ruler,
	ScrollBar,
}

require("heirline").setup {
	statusline = MainStatusline,
	opts = { colors = colors },
}

local function update_laststatus()
	vim.o.laststatus = is_start_screen() and 0 or 3
end

local group = vim.api.nvim_create_augroup("VasuStatuslineToggle", { clear = true })
vim.api.nvim_create_autocmd({ "UIEnter", "BufEnter", "BufReadPost", "BufNewFile", "TextChanged", "InsertEnter" }, {
	group = group,
	callback = update_laststatus,
	desc = "Dynamically toggle statusline visibility on start screen",
})

update_laststatus()

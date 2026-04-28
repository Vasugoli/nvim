-- lua/chadrc.lua
-- This file is used by NvChad UI to override default settings

local M = {}

M.base46 = {
	theme = "chadracula-evondev", -- default theme
	transparency = true,
}

M.ui = {
	cmp = {
		lspkind_text = true,
		style = "default", -- default/flat_light/flat_dark/atom/atom_colored
		format_colors = {
			lsp = true,
		},
	},

	statusline = {
		enabled = false,
		theme = "default", -- default/vscode/vscode_colored/minimal
		-- default/round/block/arrow separators work only for default statusline theme
		-- round and block will work for minimal theme only
		separator_style = "default",
		order = nil,
		modules = nil,
	},

	tabufline = {
		enabled = true,
		lazyload = true,
		treeOffsetFt = "neo-tree",
		order = {
			"treeOffset",
			"buffers",
			"tabs",
			"btns",
		},
		modules = nil,
		bufwidth = 32,
	},
	lsp = {
		signature = true,
	},
	term = {
		startinsert = true,
		base46_colors = true,
		winopts = { number = false, relativenumber = false },
		sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
		float = {
			relative = "editor",
			row = 0.3,
			col = 0.25,
			width = 0.5,
			height = 0.4,
			border = "single",
		},
	},

	nvdash = {
		load_on_startup = false,
	},
	colorify = {
		enabled = true,
		mode = "virtual", -- fg, bg, virtual
		virt_text = "󱓻 ",
		highlight = {
			hex = true,
			lspvars = true,
		},
	},
}

return M

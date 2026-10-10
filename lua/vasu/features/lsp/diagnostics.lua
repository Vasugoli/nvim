-- lua/vasu/features/lsp/diagnostics.lua
-- Diagnostic display: Trouble & Tiny-inline-diagnostic

local trouble_loaded = false
local function ensure_trouble()
	if trouble_loaded then return end
	trouble_loaded = true
	pcall(function()
		require("trouble").setup({ focus = true })
	end)
end

local function trouble_cmd(cmd)
	return function()
		ensure_trouble()
		vim.cmd(cmd)
	end
end

vim.keymap.set("n", "<leader>xw", trouble_cmd("Trouble diagnostics toggle"),
	{ desc = "Open trouble workspace diagnostics" })
vim.keymap.set("n", "<leader>xd", trouble_cmd("Trouble diagnostics toggle filter.buf=0"),
	{ desc = "Open trouble document diagnostics" })
vim.keymap.set("n", "<leader>xq", trouble_cmd("Trouble quickfix toggle"),
	{ desc = "Open trouble quickfix list" })
vim.keymap.set("n", "<leader>xl", trouble_cmd("Trouble loclist toggle"),
	{ desc = "Open trouble location list" })

local ok_tid, tid = pcall(require, "tiny-inline-diagnostic")
if ok_tid then
	tid.setup({
		preset = "modern",
		transparent_bg = false,
		transparent_cursorline = true,
		hi = {
			error = "DiagnosticError",
			warn = "DiagnosticWarn",
			info = "DiagnosticInfo",
			hint = "DiagnosticHint",
			arrow = "NonText",
			background = "CursorLine",
			mixing_color = "Normal",
		},
		options = {
			show_source = { enabled = false, if_many = false },
			use_icons_from_diagnostic = false,
			set_arrow_to_diag_color = false,
			add_messages = true,
			throttle = 20,
			softwrap = 30,
			multilines = {
				enabled = false,
				always_show = false,
				trim_whitespaces = false,
				tabstop = 4,
			},
			show_all_diags_on_cursorline = false,
			enable_on_insert = false,
			enable_on_select = false,
			overflow = { mode = "wrap", padding = 0 },
			break_line = { enabled = false, after = 30 },
			format = nil,
			virt_texts = { priority = 2048 },
			severity = {
				vim.diagnostic.severity.ERROR,
				vim.diagnostic.severity.WARN,
				vim.diagnostic.severity.INFO,
				vim.diagnostic.severity.HINT,
			},
		},
		disabled_ft = {},
	})
end

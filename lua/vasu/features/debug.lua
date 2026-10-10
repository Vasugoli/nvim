-- lua/vasu/features/debug.lua
-- DAP (Debug Adapter Protocol) stack
-- Plugins: mfussenegger/nvim-dap, rcarriga/nvim-dap-ui,
--          nvim-neotest/nvim-nio, jay-babu/mason-nvim-dap.nvim, leoluz/nvim-dap-go

local loaded = false

local function ensure_dap()
	if loaded then
		return
	end
	loaded = true

	local dap = require("dap")
	local dapui = require("dapui")

	-- ── mason-nvim-dap ────────────────────────────────────────────────────────────
	pcall(function()
		require("mason-nvim-dap").setup({
			automatic_installation = true,
			handlers = {},
			ensure_installed = {
				"delve", -- Go debugger
			},
		})
	end)

	-- ── dapui ────────────────────────────────────────────────────────────────────
	dapui.setup({
		icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
		controls = {
			icons = {
				pause = "⏸",
				play = "▶",
				step_into = "⏎",
				step_over = "⏭",
				step_out = "⏮",
				step_back = "b",
				run_last = "▶▶",
				terminate = "⏹",
				disconnect = "⏏",
			},
		},
	})

	-- Auto-open / close dapui with dap events
	dap.listeners.after.event_initialized["dapui_config"] = dapui.open
	dap.listeners.before.event_terminated["dapui_config"] = dapui.close
	dap.listeners.before.event_exited["dapui_config"] = dapui.close

	-- ── dap-go ───────────────────────────────────────────────────────────────────
	pcall(function()
		require("dap-go").setup({
			delve = {
				-- On Windows, delve must run attached or it crashes.
				detached = vim.fn.has("win32") == 0,
			},
		})
	end)
end

local function with_dap(fn)
	return function(...)
		ensure_dap()
		return fn(...)
	end
end

-- ── Keymaps (deferred: only initializes stack on first press) ────────────────
vim.keymap.set("n", "<F5>", with_dap(function() require("dap").continue() end),
	{ desc = "Debug: Start/Continue" })
vim.keymap.set("n", "<F1>", with_dap(function() require("dap").step_into() end),
	{ desc = "Debug: Step Into" })
vim.keymap.set("n", "<F2>", with_dap(function() require("dap").step_over() end),
	{ desc = "Debug: Step Over" })
vim.keymap.set("n", "<F3>", with_dap(function() require("dap").step_out() end),
	{ desc = "Debug: Step Out" })
vim.keymap.set("n", "<leader>b", with_dap(function() require("dap").toggle_breakpoint() end),
	{ desc = "Debug: Toggle Breakpoint" })
vim.keymap.set("n", "<leader>B", with_dap(function()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end), { desc = "Debug: Set Breakpoint" })
vim.keymap.set("n", "<F7>", with_dap(function() require("dapui").toggle() end),
	{ desc = "Debug: Toggle UI" })

return {
	ensure_setup = ensure_dap,
}

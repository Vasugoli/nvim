local neoscroll = require("neoscroll")

neoscroll.setup {
	mappings = {}, -- Handled manually below for fine-tuned speed and custom keys
	hide_cursor = true,
	stop_eof = true,
	respect_scrolloff = false,
	cursor_scrolls_alone = true,
	duration_multiplier = 1.0,
	easing = "linear",
	performance_mode = false,
	ignored_events = {
		"WinScrolled",
		"CursorMoved",
	},
}

-- Custom keybindings and durations with smooth auto-centering (zz)
local keymap = {
	-- Scroll full page -> recenter
	["<C-b>"] = function()
		neoscroll.ctrl_b({ duration = 350, post_hook = function() neoscroll.zz({ half_win_duration = 100 }) end })
	end,
	["<C-f>"] = function()
		neoscroll.ctrl_f({ duration = 350, post_hook = function() neoscroll.zz({ half_win_duration = 100 }) end })
	end,
	["<PageUp>"] = function()
		neoscroll.ctrl_b({ duration = 350, post_hook = function() neoscroll.zz({ half_win_duration = 100 }) end })
	end,
	["<PageDown>"] = function()
		neoscroll.ctrl_f({ duration = 350, post_hook = function() neoscroll.zz({ half_win_duration = 100 }) end })
	end,

	-- Scroll half page -> recenter
	["<C-u>"] = function()
		neoscroll.ctrl_u({ duration = 250, post_hook = function() neoscroll.zz({ half_win_duration = 100 }) end })
	end,
	["<C-d>"] = function()
		neoscroll.ctrl_d({ duration = 250, post_hook = function() neoscroll.zz({ half_win_duration = 100 }) end })
	end,

	-- Scroll a few lines
	["<C-y>"] = function() neoscroll.scroll(-0.1, { move_cursor = false, duration = 150 }) end,
	["<C-e>"] = function() neoscroll.scroll(0.1, { move_cursor = false, duration = 150 }) end,

	-- Scroll cursor line to top / middle / bottom
	["zt"] = function() neoscroll.zt({ half_win_duration = 150 }) end,
	["zz"] = function() neoscroll.zz({ half_win_duration = 150 }) end,
	["zb"] = function() neoscroll.zb({ half_win_duration = 150 }) end,

	-- Scroll to top / bottom of buffer
	["gg"] = function()
		local count = vim.v.count
		if count > 0 then
			vim.cmd(tostring(count))
			neoscroll.zz({ half_win_duration = 150 })
		else
			local cur_line = vim.fn.line(".")
			if cur_line > 1 then
				neoscroll.scroll(-cur_line, { move_cursor = true, duration = 250 })
			end
		end
	end,
	["G"] = function()
		local count = vim.v.count
		if count > 0 then
			vim.cmd(tostring(count))
			neoscroll.zz({ half_win_duration = 150 })
		else
			local total = vim.fn.line("$")
			local cur_line = vim.fn.line(".")
			local dist = total - cur_line
			if dist > 0 then
				neoscroll.scroll(dist, { move_cursor = true, duration = 250 })
			end
		end
	end,

	-- Line by line movement (j / k)
	["j"] = function()
		local count = vim.v.count1
		neoscroll.scroll(count, { move_cursor = true, duration = 50 })
	end,
	["k"] = function()
		local count = vim.v.count1
		neoscroll.scroll(-count, { move_cursor = true, duration = 50 })
	end,
}

local modes = { "n", "v", "x" }
for key, func in pairs(keymap) do
	vim.keymap.set(modes, key, func)
end

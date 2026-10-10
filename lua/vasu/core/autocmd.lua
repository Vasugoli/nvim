local function augroup(name) return vim.api.nvim_create_augroup("vasu_autocmd_" .. name, { clear = true }) end

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = augroup "wrap_spell",
	pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = augroup "json_conceal",
	pattern = { "json", "jsonc", "json5" },
	callback = function() vim.opt_local.conceallevel = 0 end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup "auto_create_dir",
	callback = function(event)
		if event.match:match "^%w%w+:[\\/][\\/]" then return end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Notify on yank",
	group = vim.api.nvim_create_augroup("notify-yank", { clear = true }),
	callback = function()
		local ok, event = pcall(function() return vim.v.event end)
		if ok and event and event.regcontents then
			local num_lines = #event.regcontents
			local op = event.operator or "y"
			local message = string.format("Yanked %d line(s) [%s]", num_lines, op)
			-- Schedule the notification to avoid conflict with built-in echo
			vim.schedule(function() vim.notify(message, vim.log.levels.INFO, { title = "Yanked" }) end)
		end
	end,
})

-- Open Snacks Explorer if Neovim is started with a directory
vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		local arg = vim.fn.argv(0)
		if arg and vim.fn.isdirectory(arg) == 1 then
			vim.schedule(function()
				vim.cmd("cd " .. vim.fn.fnameescape(arg))
				local ok, Snacks = pcall(require, "snacks")
				if ok then Snacks.explorer() end
			end)
		end
	end,
})


---- Notification file save
vim.api.nvim_create_autocmd("BufWritePost", {
	callback = function() vim.notify("File saved: " .. vim.fn.expand "%", vim.log.levels.INFO) end,
})
-- Restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
	end,
})

-- Safety net: re-detect filetype if somehow empty
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	callback = function()
		if vim.bo.filetype == "" then vim.cmd "filetype detect" end
	end,
})

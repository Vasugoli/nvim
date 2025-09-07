-- line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
-- vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.wrap = true

-- backup and undo
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.opt.swapfile = false
vim.opt.backup = false
local home = os.getenv("HOME") or os.getenv("USERPROFILE") or ""
vim.opt.undodir = tostring(home) .. "/.vim/undodir"
vim.opt.undofile = true

-- search
vim.opt.inccommand = "split"

-- UI
vim.opt.background = "dark"
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- folding (for nvim-ufo)
-- vim.o.foldenable = true
-- vim.o.foldmethod = "manual"
-- vim.o.foldlevel = 99
-- vim.o.foldcolumn = "0"

-- window splits
-- vim.opt.splitright = true
-- vim.opt.splitbelow = true

-- misc
-- vim.opt.isfname:append("@-@")
-- vim.opt.updatetime = 50
-- vim.opt.colorcolumn = "80"
vim.opt.clipboard:append("unnamedplus")
-- vim.opt.mouse = "a"

-- -- winbar highlights
-- vim.cmd('highlight winbar1 guifg=#ffffff')
-- vim.cmd('highlight winbar2 guifg=#ff5189')

-- -- get full path of current file
-- local function get_full_path()
-- 	return vim.fn.expand('%:p')
-- end

-- -- get buffer count
-- local function get_buffer_count()
-- 	local buffers = vim.fn.execute('ls')
-- 	local count = 0
-- 	for line in buffers:gmatch('[^\r\n]+') do
-- 		if string.match(line, '^%s*%d+') then
-- 			count = count + 1
-- 		end
-- 	end
-- 	return tostring(count)
-- end

-- -- update winbar
-- local function update_winbar()
-- 	local buf_ft = vim.bo.filetype
-- 	if buf_ft == "alpha" or buf_ft == "NvimTree" or buf_ft == "toggleterm" then
-- 		vim.opt.winbar = nil
-- 	else
-- 		local full_path = get_full_path()
-- 		local buffer_count = get_buffer_count()
-- 		vim.opt.winbar = string.format("%%#winbar1#m %%#winbar2#(%s) %%#winbar1# %s", buffer_count, full_path)
-- 	end
-- end

-- -- Autocommand to update winbar on relevant events
-- vim.api.nvim_create_autocmd({"BufWinEnter", "BufFilePost", "BufEnter", "WinEnter"}, {
-- 	callback = update_winbar
-- })

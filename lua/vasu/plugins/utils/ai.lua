-- github/copilot.vim — AI completions
vim.g.copilot_filetypes = {
	cpp = false, -- disable for C++
	java = false, -- disable for Java
	c = false, -- disable for C
	go = false, -- disable for Go
}
vim.keymap.set("i", "<C-k>", 'copilot#Accept("\\<CR>")', {
	expr = true,
	replace_keycodes = false,
})
vim.g.copilot_no_tab_map = true

require("yazi").setup {}

vim.keymap.set("n", "<c-up>", "<cmd>Yazi toggle<cr>", {
	desc = "Resume the last yazi session",
})

vim.keymap.set({ "n", "v" }, "<leader>-", "<cmd>Yazi<cr>", {
	desc = "Open yazi at the current file",
})

vim.keymap.set("n", "<leader>cd", "<cmd>Yazi cwd<cr>", {
	desc = "Open the file manager in nvim's working directory",
})

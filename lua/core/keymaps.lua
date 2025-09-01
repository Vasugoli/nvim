vim.g.mapleader = " "

vim.keymap.set("n", "<leader>da", "<cmd>Alpha<CR>", { desc = "Open Alpha Dashboard" })

-- Line wrapping
vim.opt.wrap = false -- Initialize wrap to false

-- Function to toggle wrap
local function toggle_wrap()
    vim.opt.wrap = not vim.opt.wrap
    local status = vim.opt.wrap:get() and "enabled" or "disabled"
    print("Wrap " .. status)
end
vim.keymap.set("n", "<leader>tw", toggle_wrap, { desc = "Toggle Wrap" })


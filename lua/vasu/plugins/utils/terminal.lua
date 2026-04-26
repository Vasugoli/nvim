-- nvzone/floaterm

local status, floaterm = pcall(require, "floaterm")
if not status then
    return
end

floaterm.setup({
    border = true
})

-- Keymaps
vim.keymap.set({ "n", "t" }, "<leader>tt", "<cmd>FloatermToggle<CR>", { desc = "Toggle Floaterm" })

-- Floaterm usually handles its own window management and sidebar.
-- You can use Ctrl+h in the terminal to focus the sidebar.

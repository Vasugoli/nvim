-- nvzone/showkeys — on-screen key display
require("showkeys").setup({
    position = "bottom-right",
    maxkeys = 3,
    show_count = true,
    timeout = 1000,
    winopts = {border = "rounded", style = "minimal"}
})

-- Auto-start on launch (schedule so the UI is fully ready first)
vim.schedule(function() vim.cmd "ShowkeysToggle" end)

-- Toggle with <leader>sk
vim.keymap.set("n", "<leader>sk", "<cmd>ShowkeysToggle<CR>",
               {desc = "Toggle Showkeys"})


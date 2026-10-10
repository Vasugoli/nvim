-- nvzone/showkeys — on-screen key display
require("showkeys").setup({
    position = "bottom-right",
    maxkeys = 3,
    show_count = true,
    timeout = 1000,
    winopts = {border = "rounded", style = "minimal"}
})

-- Toggle with <leader>sk
vim.keymap.set("n", "<leader>sk", "<cmd>ShowkeysToggle<CR>",
               {desc = "Toggle Showkeys"})


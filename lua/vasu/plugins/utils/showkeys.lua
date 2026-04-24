-- nvzone/showkeys — on-screen key display
require("showkeys").setup({
    position = "bottom-right",
    maxkeys = 3,
    show_count = true,
    timeout = 1000,
    winopts = {border = "rounded", style = "minimal"}
})

-- Toggle with <leader>sk (showkeys does not auto-start on setup)
vim.keymap.set("n", "<leader>sk", "<cmd>ShowkeysToggle<CR>",
               {desc = "Toggle Showkeys"})

-- folke/which-key.nvim — interactive keymap popup
local wk = require("which-key")

wk.setup({
    style = "helix",
    border = "single",
    layout = {
        height = {min = 4, max = 25},
        width = {min = 20, max = 50},
        spacing = 3,
        align = "left"
    }
})

vim.keymap.set("n", "<leader>", function() wk.show({global = true}) end,
               {desc = "Buffer Local Keymaps (which-key)"})

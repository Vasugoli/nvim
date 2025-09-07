vim.g.mapleader = " "

vim.keymap.set("n", "<leader>da", "<cmd>Alpha<CR>", {
    desc = "Open Alpha Dashboard"
})

-- Telescope keymaps
vim.keymap.set('n', '<C-p>', function()
    require('telescope.builtin').find_files()
end, {})
vim.keymap.set('n', '<leader>fg', function()
    require('telescope.builtin').live_grep()
end, {})
vim.keymap.set('n', '<leader>fh', function()
    require('telescope.builtin').help_tags()
end, {})
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", {
    desc = "Fuzzy find recent files"
})
vim.keymap.set("n", "<leader>fw", function()
    local word = vim.fn.expand "<cWORD>"
    require("telescope.builtin").grep_string {
        search = word
    }
end, {
    desc = "Find Connected Words under cursor"
})
vim.keymap.set("n", "<leader>cb", function()
    require("telescope.builtin").buffers {
        show_all_buffers = true,
        sort_mru = true,
        ignore_current_buffer = false,
        previewer = true,
        initial_mode = "normal",
        theme = "tele_dropdown"
    }
end, {
    desc = "Choose Buffer (including hidden)"
})
vim.keymap.set("n", "<leader>nh", "<cmd>Telescope notify<CR>", {
    desc = "Notifications History"
})

-- github/copilot.vim — AI completions
vim.g.copilot_filetypes = {
    cpp = false, -- disable for C++
    c   = false, -- disable for C
}

-- olimorris/codecompanion.nvim — AI powered coding assistant
require("codecompanion").setup({
    strategies = {
        chat = {
            adapter = "copilot",
        },
        inline = {
            adapter = "copilot",
        },
    },
})

-- Keymaps for CodeCompanion
vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { desc = "AI Actions" })
vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI Chat" })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { desc = "AI Add to Chat" })

-- Expand 'cc' into 'CodeCompanion' in the command line
-- vim.cmd([[cabcc CodeCompanion]])

-- stevearc/dressing.nvim — UI for CodeCompanion actions
require("dressing").setup()

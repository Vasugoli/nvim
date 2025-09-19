return {
    { "github/copilot.vim" },
    {
        "olimorris/codecompanion.nvim",
        opts = {},
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            -- "mcphub-nvim/mcphub",
            -- "author/codecompanion_history.nvim", -- history extension
        },
        config = function()
            require("codecompanion").setup({
                extensions = {
                    -- mcphub = {
                    --     callback = "mcphub.extensions.codecompanion",
                    --     opts = {
                    --         make_vars = true,
                    --         make_slash_commands = true,
                   -- },
                    -- codecompanion_history = {
                    --     enabled = true, -- defaults to true
                        -- opts = {
                            -- history_file = vim.fn.stdpath("data") .. "/codecompanion_chats.json",
                            -- max_history = 10, -- maximum number of chats to keep
                        -- },
                    -- },
                },
            })
        end,
    },
}

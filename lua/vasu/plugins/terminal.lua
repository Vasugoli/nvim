return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            float_opts = {
                border = "curved", -- rounded corners
            },
        })

        -- Keymaps to open ToggleTerm in different orientations using the documented command
        vim.keymap.set("n", "<leader>tf", function()
            vim.cmd("ToggleTerm direction=float")
        end, { desc = "Toggle Floating Terminal" })
        vim.keymap.set("n", "<leader>th", function()
            vim.cmd("ToggleTerm direction=horizontal")
        end, { desc = "Toggle Horizontal Terminal" })
        vim.keymap.set("n", "<leader>tv", function()
            vim.cmd("ToggleTerm direction=vertical")
        end, { desc = "Toggle Vertical Terminal" })
        vim.keymap.set("n", "<leader>tt", function()
            vim.cmd("ToggleTerm direction=tab")
        end, { desc = "Toggle Tab Terminal" })
    end,
}

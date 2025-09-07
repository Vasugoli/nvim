return {{
    "nvzone/showkeys",
    cmd = "ShowkeysToggle",
    opts = {
        position = "bottom-right",
        maxkeys = 3,
        show_count = true,
        winopts = {
            focusable = false,
            relative = "editor",
            style = "minimal",
            border = "rounded",
            height = 1,
            row = 1,
            col = 0
        }
    }
}, {{
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        style = "helix",
        border = "single",
        layout = {
            height = { min = 4, max = 25 },
            width = { min = 20, max = 50 },
            spacing = 3,
            align = "left"
        }
    },
    keys = {{
        "<leader>",
        function()
            require("which-key").show({
                global = true
            })
        end,
        desc = "Buffer Local Keymaps (which-key)"
    }}
}}}

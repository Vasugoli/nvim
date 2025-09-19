return {
    "nvzone/showkeys",
    cmd = "ShowkeysToggle",
    -- event = "VeryLazy",
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
}

return {
    "rebelot/heirline.nvim",
    event = "BufEnter",
    config = function()
        require("heirline").setup({
            opts = {
                theme = "auto",
                colors = {
                    fg = "#abb2bf",
                    bg = "#282c34",
                    yellow = "#e0af68",
                    cyan = "#56b6c2",
                    darkblue = "#081633",
                    green = "#98c379",
                    orange = "#d19a66",
                    violet = "#a9a1e1",
                    magenta = "#c678dd",
                    blue = "#61afef",
                    red = "#e86671",
                },
                statusline = {
                    -- add statusline components here
                    {
                        provider = "file_info",
                        hl = { fg = "fg", bg = "bg" },
                    },
                    {
                        provider = "line_percentage",
                        hl = { fg = "fg", bg = "bg" },
                    },
                    {
                        provider = "position",
                        hl = { fg = "fg", bg = "bg" },
                    },
                },
            },
        })
    end,
}
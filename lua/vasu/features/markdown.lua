-- lua/vasu/features/markdown.lua
-- Markdown preview and rendering

local function setup_markdown()
    local ok, rm = pcall(require, "render-markdown")
    if not ok then return end
    rm.setup({
        restart_highlighter = true,
        heading = {
            sign = true,
            icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
            width = "block",
            right_pad = 1,
            backgrounds = {
                "Headline1Bg",
                "Headline2Bg",
                "Headline3Bg",
                "Headline4Bg",
                "Headline5Bg",
                "Headline6Bg",
            },
        },
        code = {
            sign = false,
            width = "block",
            right_pad = 1,
        },
        bullet = { enabled = true },
        checkbox = {
            enabled = true,
            unchecked = { icon = " 󰄱 " },
            checked   = { icon = " 󰱒 " },
        },
        anti_conceal = { ignore = { head_background = true } },
    })
end

if vim.bo.filetype == "markdown" then
    setup_markdown()
else
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown" },
        once = true,
        callback = setup_markdown,
    })
end

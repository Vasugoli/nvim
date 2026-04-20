require('cyberdream').setup {
    transparent = true, -- Enable this to disable setting the background color
    terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
    styles = {
        comments = {italic = false} -- Disable italics in comments
    }
}

-- Load the colorscheme here.
-- Like many other themes, this one has different styles, and you could load
-- any other, such as 'cyberdream', 'cyberdream-moon', or 'cyberdream-day'.
vim.cmd.colorscheme 'cyberdream'

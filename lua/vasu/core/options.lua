-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- Enable relative line numbers
opt.relativenumber = true
opt.number = true

-- line spacing
opt.linespace = 5

-- ui
opt.cursorline = true
opt.ruler = false

-- tabs & indentation
opt.tabstop = 4 -- 2 for 2 spaces
opt.shiftwidth = 4 -- 2 for 2 spaces
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
-- opt.backspace = "indent, eol, start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-") -- consider string-string as whole word

-- Make ShaDa safer on Windows
vim.opt.shada = "" -- disable shada by default
-- opt.shadafile = vim.fn.stdpath("data") .. "/shada/main.shada"
-- opt.shada = "!,'100,<50,s10,h"

-- opt.shadafile = "NONE"

-- mouse
opt.mouse = "a" -- Enable mouse mode

opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode

-- disable show mode you are in
opt.showmode = false

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- remove ~ from end of buffer
opt.fillchars = { eob = " " }

-- Disable in built file exploler and nvim netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.laststatus = 3

-- Ensure filetype detection is enabled
vim.cmd("filetype plugin indent on")

-- Safety net: re-detect filetype if somehow empty
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  callback = function()
    if vim.bo.filetype == "" then
      vim.cmd("filetype detect")
    end
  end,
})

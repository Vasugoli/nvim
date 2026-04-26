-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- NvChad base46 cache path
vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"

local opt = vim.opt

-- Enable relative line numbers
opt.relativenumber = true
opt.number = true

vim.g.editorconfig = false
-- ui
opt.cursorline = true
opt.ruler = false

-- tabs & indentation
opt.tabstop = 4         -- Render \t as 4 spaces
opt.shiftwidth = 4      -- Size of an indent (for > and <)
opt.softtabstop = 4     -- Makes backspace treat 4 spaces like a tab
opt.expandtab = false   -- Turn tabs into spaces
opt.autoindent = true   -- Copy indent from current line when starting a new one



-- shell
opt.shell = "nu"

-- cmd height
opt.cmdheight = 1
opt.showcmdloc = "statusline"

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

-- Helpful for searching
opt.inccommand = "split" -- Shows replacements in a live preview buffer

-- split windows
opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-") -- consider string-string as whole word

-- Make ShaDa safer on Windows
local shada_dir = vim.fn.stdpath("data") .. "/shada"
if vim.fn.isdirectory(shada_dir) == 0 then
    vim.fn.mkdir(shada_dir, "p")
end
opt.shadafile = shada_dir .. "/main.shada"
opt.shada = "!,'100,<50,s10,h"

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

-- Fold options
opt.foldcolumn = '0' -- '0' is not bad
opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldopen = "all"

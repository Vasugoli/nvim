-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- NvChad base46 cache path
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"

local opt = vim.opt
local o = vim.o
local g = vim.g

-------------------------------------- options ------------------------------------------
o.laststatus = 3
o.showmode = false
o.splitkeep = "screen"

o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "number"

-- Indenting
o.expandtab = true
o.shiftwidth = 4
o.smartindent = true
o.tabstop = 4
o.softtabstop = 4

opt.fillchars = { eob = " " }
o.ignorecase = true
o.smartcase = true
o.mouse = "a"

-- Numbers
o.relativenumber = true
o.number = true
o.numberwidth = 2
o.ruler = false

-- disable nvim intro
opt.shortmess:append "sI"

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true

opt.termguicolors = true
opt.signcolumn = "yes"
-- Helpful for searching
opt.inccommand = "split" -- Shows replacements in a live preview buffer
opt.iskeyword:append "-" -- consider string-string as whole word

-- Make ShaDa safer on Windows
local shada_dir = vim.fn.stdpath "data" .. "/shada"
if vim.fn.isdirectory(shada_dir) == 0 then vim.fn.mkdir(shada_dir, "p") end
opt.shadafile = shada_dir .. "/main.shada"
opt.shada = "!,'100,<50,s10,h"

opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
-- interval for writing swap file to disk, also used by gitsigns
o.updatetime = 250

o.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- remove ~ from end of buffer
opt.fillchars = { eob = " " }
-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
-- opt.whichwrap:append "<>[]hl"

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH


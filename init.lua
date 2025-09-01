-- core settings
require("core.lazy")
require("core.options")
require("core.keymaps")
require("core.autocmd")


-- Plugin setup
local opts = {}
require("lazy").setup("plugins", opts)

-- Telescope keymaps
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})



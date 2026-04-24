-- lua/sethy/pack.lua
-- native 0.12 vimpack plugin manager

-- early pack hooks
require("vasu.plugins.pack-hooks")

-- Plugins
vim.pack.add({
    -- Core
    { src = "https://github.com/nvim-lua/plenary.nvim" }, --enabled (used by telescope & git_worktree.nvim)

    -- Plugins
    { src = "https://github.com/dmtrKovalenko/fff.nvim" }, --enabled

    -- all telescope
    { src = "https://github.com/nvim-telescope/telescope.nvim", branch = "master" },--enabled

    { src = "https://github.com/windwp/nvim-autopairs" }, --enabled
    -- statusline
    { src = "https://github.com/rebelot/heirline.nvim" }, --enabled
    -- File explorer
    { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", branch = "v3.x" }, --enabled
    { src = "https://github.com/mikavilpas/yazi.nvim" }, --enabled

    { src = "https://github.com/rmagatti/auto-session" }, -- enabled

    -- folding
    -- { src = "https://github.com/kevinhwang91/nvim-ufo" }, --enabled
    -- { src = "https://github.com/kevinhwang91/promise-async" }, --nvim-ufo dependency
    -- markdown previewer
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" }, --enabled

    { src = "https://github.com/MunifTanjim/nui.nvim" },

    { src = "https://github.com/folke/snacks.nvim" }, --enabled
    { src = "https://github.com/echasnovski/mini.nvim" }, --enabled

    { src = "https://github.com/folke/todo-comments.nvim" }, --enabled
    { src = "https://github.com/numToStr/Comment.nvim" }, --enabled
    { src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" }, -- enabled

    -- git
    { src = "https://github.com/f-person/git-blame.nvim" }, --enabled
    { src = "https://github.com/lewis6991/gitsigns.nvim" }, --enabled
    { src = "https://github.com/tpope/vim-fugitive" }, --enabled

    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" }, --enabled
    { src = "https://github.com/windwp/nvim-ts-autotag" }, --enabled

    -- Wilder
    { src = "https://github.com/gelguy/wilder.nvim" },
    { src = "https://github.com/romgrk/fzy-lua-native" },

    -- completions cmp
    { src = "https://github.com/hrsh7th/nvim-cmp" }, --enabled
    -- completions dependency
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/hrsh7th/cmp-buffer" },
    { src = "https://github.com/hrsh7th/cmp-path" },
    { src = "https://github.com/hrsh7th/cmp-cmdline" },
    { src = "https://github.com/f3fora/cmp-spell" },
    { src = "https://github.com/L3MON4D3/LuaSnip", version = "v2.4.1" },
    { src = "https://github.com/saadparwaiz1/cmp_luasnip" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/onsails/lspkind.nvim" },
    -- Formatting
    { src = "https://github.com/nvimtools/none-ls.nvim" },

    -- LSP stack
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },

    -- Highlight colors
    { src = "https://github.com/NvChad/nvim-colorizer.lua" }, --enabled

    -- icons
    { src = "https://github.com/nvim-tree/nvim-web-devicons" }, --enabled
    -- error line display
    { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" }, --enabled
    { src = "https://github.com/folke/trouble.nvim" }, --enabled

    -- colorschemes
    { src = "https://github.com/scottmckendry/cyberdream.nvim" }, --enabled
    -- { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
    -- { src = "https://github.com/folke/tokyonight.nvim" },
    -- { src = "https://github.com/catppuccin/nvim", name = "catppuccin-nvim" },

    -- Cursor animation
    { src = "https://github.com/sphamba/smear-cursor.nvim" },

    -- AI completions
    { src = "https://github.com/github/copilot.vim" },

    -- Centered scroll
    { src = "https://github.com/arnamak/stay-centered.nvim" },

    -- Jump / motion
    { src = "https://github.com/folke/flash.nvim" },

    -- Notification UI
    { src = "https://github.com/rcarriga/nvim-notify" },

    -- Key display + which-key
    { src = "https://github.com/nvzone/showkeys" },
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/folke/lazydev.nvim" }, --enabled

    -- DAP (debugger) stack
    { src = "https://github.com/mfussenegger/nvim-dap" },
    { src = "https://github.com/rcarriga/nvim-dap-ui" },
    { src = "https://github.com/nvim-neotest/nvim-nio" },
    { src = "https://github.com/jay-babu/mason-nvim-dap.nvim" },
    { src = "https://github.com/leoluz/nvim-dap-go" },
    -- Terminal
    { src = "https://github.com/akinsho/toggleterm.nvim" },
})

-- Custom packer commands
-- NOTE: pack add
vim.api.nvim_create_user_command("PackAdd", function(opts)
    vim.pack.add(opts.fargs)
end, { nargs = "+", desc = "Add plugins (PackAdd user/repo)", })

-- NOTE: pack update
vim.api.nvim_create_user_command("PackUpdate", function(opts)
    if opts.args ~= "" then
        -- update specific plugins
        local plugins = vim.split(opts.args, "%s+", { trimempty = true })
        vim.pack.update(plugins)
    else
        -- update all
        vim.pack.update()
    end
end, { desc = "Update all plugins or specific ones", nargs = "*", }
)

-- NOTE: pack del
vim.api.nvim_create_user_command("PackDel", function(opts)
    vim.pack.del(opts.fargs)
end, { nargs = "+", desc = "Delete plugins (space separated)" })

-- NOTE: pack nonactive - show all non active plugins on disk but removed from pack.lua
vim.api.nvim_create_user_command("PackCheck", function()
    local non_active = vim.iter(vim.pack.get())
        :filter(function(x) return not x.active end)
        :map(function(x) return x.spec.name end)
        :totable()

    if #non_active == 0 then
        vim.notify("🆗 No non-active plugins found!", vim.log.levels.INFO)
        return
    end

    vim.print("😴 Non-active plugins :")
    print(" ")
    -- vim.print(non_active)
    for _, name in ipairs(non_active) do
        print(name)
    end

    print(" ")

    local choice = vim.fn.confirm(
        "Delete ALL non-active plugins from disk?",
        "&Yes\n&No",
        2  -- default = No
    )

    if choice == 1 then
        vim.pack.del(non_active)
        vim.notify("🗑️  Deleted " .. #non_active .. " non-active plugin(s)", vim.log.levels.INFO)
        print("Non-active plugins deleted!")
        vim.api.nvim_exec_autocmds("User", { pattern = "PackChanged" })
    else
        vim.notify("Cancelled. No plugins were deleted!", vim.log.levels.INFO)
    end
end, { desc = "List non active plugins and select to delete"})


-- NOTE: Call plugins
-- This can be moved to init.lua @ vasu/plugins/

-- Core
require("vasu.plugins.lazydev")

-- Syntax & Highlighting
require("vasu.plugins.treesitter")

-- Themes
require("vasu.plugins.theme")

-- UI & Others
require("vasu.plugins.mini")
require("vasu.plugins.snacks") --
require("vasu.plugins.heirline")
require("vasu.plugins.ui.cursor")
require("vasu.plugins.utils.notify")
require("vasu.plugins.utils.showkeys")

-- File Management
require("vasu.plugins.neotree") --
require("vasu.plugins.yazi")
require("vasu.plugins.utils.telescope")
require("vasu.plugins.fff")

-- Editing Helpers
require("vasu.plugins.formatting")
-- require("vasu.plugins.nvim-ufo")
require("vasu.plugins.autopairs")
require("vasu.plugins.comment")
require("vasu.plugins.colorizer")
require("vasu.plugins.markdown")
-- nvim-ts-autotag is configured inside treesitter.lua
require("vasu.plugins.utils.centered")
require("vasu.plugins.utils.flash")
require("vasu.plugins.utils.ai")

-- Git
require("vasu.plugins.git")

-- Completion --
require("vasu.plugins.nvim-cmp")

-- LSP
require("vasu.plugins.lsp.mason") -- mason has to load before lspconfig
require("vasu.plugins.lsp.lspconfig")
require("vasu.plugins.lsp.debug")

require("vasu.plugins.trouble")
require("vasu.plugins.wilder")
require("vasu.plugins.session")
require("vasu.plugins.terminal")
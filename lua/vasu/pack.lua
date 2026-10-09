-- lua/vasu/pack.lua
-- native 0.12 vimpack plugin manager

-- early pack hooks
require "vasu.plugins.pack-hooks"

-- Plugins
vim.pack.add {
    -- File finder
    { src = "https://github.com/dmtrKovalenko/fff.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },

    -- statusline
    { src = "https://github.com/rebelot/heirline.nvim" },

    -- File explorer
    { src = "https://github.com/mikavilpas/yazi.nvim" },
    { src = "https://github.com/folke/snacks.nvim" }, -- File Explorer and few other modules

    -- folding
    -- { src = "https://github.com/kevinhwang91/nvim-ufo" },
    -- { src = "https://github.com/kevinhwang91/promise-async" },

    -- markdown previewer
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },

    -- Nui for elements UI
    { src = "https://github.com/MunifTanjim/nui.nvim" },

    -- MINI modules
    { src = "https://github.com/echasnovski/mini.nvim" },

    -- nvim-ts-context-commentstring
    { src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" },

    -- git
    { src = "https://github.com/lewis6991/gitsigns.nvim" },

    -- Treesitter
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/windwp/nvim-ts-autotag" },

    -- snippet engine
    { src = "https://github.com/L3MON4D3/LuaSnip", version = "v2.4.1" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/onsails/lspkind.nvim" },

    -- Formatting
    { src = "https://github.com/stevearc/conform.nvim.git" },

    -- blink.cmp completion UI
    { src = "https://github.com/neovim/nvim-lspconfig" },

    -- LSP stack
    { src = "https://github.com/saghen/blink.cmp", branch = "v1" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },

    -- icons
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },

    -- error line display
    { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
    { src = "https://github.com/folke/trouble.nvim" },

    -- AI completions
    { src = "https://github.com/github/copilot.vim" },
    { src = "https://github.com/olimorris/codecompanion.nvim" },

    -- Jump / motion & smooth scroll
    { src = "https://github.com/folke/flash.nvim" },
    { src = "https://github.com/karb94/neoscroll.nvim" },
    { src = "https://github.com/chrisgrieser/nvim-origami" },
    { src = "https://github.com/sphamba/smear-cursor.nvim" },

    -- Key display + which-key
    { src = "https://github.com/nvzone/showkeys" },
    -- { src = "https://github.com/folke/which-key.nvim" },

    -- DAP (debugger) stack
    { src = "https://github.com/mfussenegger/nvim-dap" },
    { src = "https://github.com/rcarriga/nvim-dap-ui" },
    { src = "https://github.com/nvim-neotest/nvim-nio" },
    { src = "https://github.com/jay-babu/mason-nvim-dap.nvim" },
    { src = "https://github.com/leoluz/nvim-dap-go" },

    -- NvChad UI stack
    { src = "https://github.com/nvchad/ui" },
    { src = "https://github.com/nvchad/base46" },
    { src = "https://github.com/nvzone/volt" },
    { src = "https://github.com/nvzone/minty" },
}

-- Custom packer commands
-- NOTE: pack add
vim.api.nvim_create_user_command(
    "PackAdd",
    function(opts) vim.pack.add(opts.fargs) end,
    { nargs = "+", desc = "Add plugins (PackAdd user/repo)" }
)

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
end, { desc = "Update all plugins or specific ones", nargs = "*" })

-- NOTE: pack del
vim.api.nvim_create_user_command(
    "PackDel",
    function(opts) vim.pack.del(opts.fargs) end,
    { nargs = "+", desc = "Delete plugins (space separated)" }
)

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

    vim.print "😴 Non-active plugins :"
    print " "
    -- vim.print(non_active)
    for _, name in ipairs(non_active) do
        print(name)
    end

    print " "

    local choice = vim.fn.confirm(
        "Delete ALL non-active plugins from disk?",
        "&Yes\n&No",
        2 -- default = No
    )

    if choice == 1 then
        vim.pack.del(non_active)
        vim.notify("🗑️  Deleted " .. #non_active .. " non-active plugin(s)", vim.log.levels.INFO)
        print "Non-active plugins deleted!"
        vim.api.nvim_exec_autocmds("User", { pattern = "PackChanged" })
    else
        vim.notify("Cancelled. No plugins were deleted!", vim.log.levels.INFO)
    end
end, { desc = "List non active plugins and select to delete" })


require "vasu.plugins.utils.ai"
require "vasu.plugins.utils.treesitter"
require "vasu.plugins.utils.snacks"
require "vasu.plugins.utils.mini"
require "vasu.plugins.utils.showkeys"
require "vasu.plugins.utils.yazi"
require "vasu.plugins.utils.markdown"
require "vasu.plugins.utils.fff"
require "vasu.plugins.utils.flash"
require "vasu.plugins.utils.git"
require "vasu.plugins.utils.trouble"
-- require "vasu.plugins.utils.centered" -- replaced by scrolloff=999
require "vasu.plugins.utils.origami"

require "vasu.plugins.ui.heirline"
require "vasu.plugins.ui.neoscroll"
require "vasu.plugins.ui.smear-cursor"
require "vasu.plugins.ui.nvchad"

require "vasu.plugins.lsp.formatting"
require "vasu.plugins.lsp.completions"
require "vasu.plugins.lsp.mason"
require "vasu.plugins.lsp.lspconfig"
require "vasu.plugins.lsp.debug"


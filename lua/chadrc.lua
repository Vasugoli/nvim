-- lua/chadrc.lua
-- This file is used by NvChad UI to override default settings

local M = {}

M.base46 = {
    theme = "chadracula-evondev", -- default theme
    transparency = true,
}

M.ui = {
    cmp = {
        lspkind_text = true,
        style = "default", -- default/flat_light/flat_dark/atom/atom_colored
        format_colors = {
            lsp = true,
        },
    },

    statusline = {
        enabled = false,
        theme = "default", -- default/vscode/vscode_colored/minimal
        -- default/round/block/arrow separators work only for default statusline theme
        -- round and block will work for minimal theme only
        separator_style = "default",
        order = nil,
        modules = nil,
    },

    tabufline = {
        enabled = true,
        lazyload = true,
        treeOffsetFt = "neo-tree",
        order = {
        	"treeOffset",
        	"buffers",
        	"tabs",
        	"btns"
        },
        modules = nil,
        bufwidth = 32,
    },
    lsp = {
        signature = true
    },

    nvdash = {
        load_on_startup = false,
	},
    colorify = {
        enabled = true,
        mode = "virtual", -- fg, bg, virtual
        virt_text = "󱓻 ",
        highlight = {
        	hex = true,
        	lspvars = true
        },
    },
}

return M

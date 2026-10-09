-- lua/vasu/plugins/lsp/nvim-cmp.lua
-- Using blink.cmp — nvim-cmp and all hrsh7th/* sources removed from pack.lua
-- NOTE: blink.cmp is loaded by vim.pack automatically — no packadd needed
-- Only need the boolean — luasnip itself is used internally by blink via preset
vim.cmd.packadd("blink.cmp")
local has_luasnip = pcall(require, "luasnip")

local ok, blink_cmp = pcall(require, "blink.cmp")
if not ok then
    vim.notify("blink.cmp not loaded: " .. tostring(blink_cmp), vim.log.levels.WARN)
    return
end

local nvchad_config = require("nvchad.blink.config")

-- Merge with your overrides on top
blink_cmp.setup(vim.tbl_deep_extend("force", nvchad_config, {
    fuzzy = {
        implementation = "prefer_rust_with_warning"
    },
    keymap = {
        preset = "default"
    },
    completion = {
        menu = {
            auto_show = true
        },
        documentation = {
            auto_show = true
        },
        ghost_text = {
            enabled = false,
            show_with_menu = false
        },
        accept = {
            auto_brackets = {
                enabled = true
            }
        }
    },
    cmdline = {
        enabled = true,
        keymap = {
            preset = "cmdline"
        },
        completion = {
            menu = {
                auto_show = true
            }
        }
    },
    sources = {
        default = {"lsp", "path", "buffer", "snippets"},
        providers = {
            lsp = {
                opts = {
                    tailwind_color_icon = "󱓻"
                }
            }
        }
    },
    appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono"
    },
    snippets = {
        -- blink handles luasnip integration internally via this preset
        preset = "luasnip"
    }
}))

-- Load luasnip vscode-style snippets if luasnip is available
if has_luasnip then
    local vscode_loader = require("luasnip.loaders.from_vscode")
    vscode_loader.lazy_load()
    vscode_loader.lazy_load({
        paths = {vim.fn.stdpath("config") .. "/snippets"}
    })
end

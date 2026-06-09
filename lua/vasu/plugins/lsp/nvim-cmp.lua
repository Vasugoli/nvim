local has_luasnip, luasnip = pcall(require, "luasnip")

pcall(vim.cmd.packadd, "blink.cmp")
local ok, blink_cmp = pcall(require, "blink.cmp")
if not ok then
	print("DEBUG blink.cmp error: " .. tostring(blink_cmp))
end
if ok then
	blink_cmp.setup({
		fuzzy = {
			implementation = "prefer_rust",
		},
		keymap = {
			preset = "default",
		},
		completion = {
			menu = {
				auto_show = true,
			},
			documentation = {
				auto_show = true,
			},
			ghost_text = {
				enabled = false,
				show_with_menu = false,
			},
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},
		},
		cmdline = {
			enabled = true,
			keymap = { preset = "cmdline" },
			completion = {
				menu = { auto_show = true },
			},
		},
		sources = {
			default = { "lsp", "path", "buffer", "snippets" },
			providers = {
				lsp = {
					opts = {
						tailwind_color_icon = "󱓻",
					},
				},
			},
		},
		appearance = {
			use_nvim_cmp_as_default = false,
			nerd_font_variant = "mono",
		},
		snippets = {
			preset = "luasnip",
		},
	})
end

if has_luasnip then
	local vscode_loader = require("luasnip.loaders.from_vscode")
	vscode_loader.lazy_load()
	vscode_loader.lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
end

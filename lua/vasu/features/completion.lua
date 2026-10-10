-- lua/vasu/features/completion.lua
-- Blink.cmp completion engine & LuaSnip snippets integration

local ok, blink_cmp = pcall(require, "blink.cmp")
if not ok then
	vim.notify("blink.cmp not loaded: " .. tostring(blink_cmp), vim.log.levels.WARN)
	return
end

-- Ensure base46 blink highlights are loaded
if vim.g.base46_cache then
	local blink_cache = vim.g.base46_cache .. "blink"
	if vim.fn.filereadable(blink_cache) == 1 then
		pcall(dofile, blink_cache)
	else
		pcall(function()
			require("base46").compile()
			if vim.fn.filereadable(blink_cache) == 1 then
				dofile(blink_cache)
			end
		end)
	end
end

local ok_icons, lsp_icons = pcall(require, "nvchad.icons.lspkind")
local nvchad_config = require("nvchad.blink.config")

local menu_components = {
	kind_icon = {
		ellipsis = false,
		text = function(ctx)
			local icons = ok_icons and lsp_icons or {}
			local icon = icons[ctx.kind] or ctx.kind_icon or "󰈚"
			return icon .. " "
		end,
		highlight = function(ctx)
			return "BlinkCmpKind" .. ctx.kind
		end,
	},
	label = {
		width = { fill = true, max = 60 },
	},
	label_description = {
		width = { max = 30 },
	},
	kind = {
		ellipsis = false,
		text = function(ctx)
			return ctx.kind
		end,
		highlight = function(ctx)
			return "BlinkCmpKind" .. ctx.kind
		end,
	},
}

-- Merge with your overrides on top
blink_cmp.setup(vim.tbl_deep_extend("force", nvchad_config, {
	fuzzy = {
		implementation = "prefer_rust_with_warning",
	},
	keymap = {
		preset = "default",
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
	},
	completion = {
		menu = {
			min_width = 40,
			max_height = 16,
			scrollbar = false,
			border = "single",
			winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
			draw = {
				padding = { 1, 1 },
				columns = {
					{ "kind_icon" },
					{ "label", "label_description", gap = 15 },
					{ "kind" },
				},
				components = menu_components,
			},
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
			window = {
				min_width = 35,
				max_width = 80,
				max_height = 20,
				border = "single",
				winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
			},
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
		keymap = {
			preset = "cmdline",
		},
		completion = {
			menu = {
				auto_show = true,
			},
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
		nerd_font_variant = "normal",
	},
	snippets = {
		preset = "luasnip",
	},
}))

-- Load luasnip vscode-style snippets on first InsertEnter
vim.api.nvim_create_autocmd("InsertEnter", {
	once = true,
	callback = function()
		local ok_loader, vscode_loader = pcall(require, "luasnip.loaders.from_vscode")
		if ok_loader then
			vscode_loader.lazy_load()
			vscode_loader.lazy_load({
				paths = { vim.fn.stdpath("config") .. "/snippets" },
			})
		end
	end,
})

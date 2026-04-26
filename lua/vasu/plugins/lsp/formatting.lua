local conform = require "conform"

conform.setup {
	formatters_by_ft = {
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		lua = { "stylua" },
		python = { "isort", "black" },
		cpp = { "clang-format" },
	},
	formatters = {
		["clang-format"] = {
			prepend_args = { "--style", "{IndentWidth: 4, UseTab: Always, TabWidth: 4}" },
		},
		["prettier"] = {
			prepend_args = { "--use-tabs", "true", "--tab-width", "4" },
		},
		["stylua"] = {
			prepend_args = { "--indent-type", "Tabs", "--indent-width", "4" },
		},
	},
	format_on_save = {
		lsp_fallback = true,
		async = false,
		timeout_ms = 3000,
	},
}

vim.keymap.set(
	{ "n", "v" },
	"<leader>cf",
	function()
		conform.format {
			lsp_fallback = true,
			async = false,
			timeout_ms = 1000,
			format_options = {
				tabSize = 4,
				insertSpaces = false,
			},
		}
	end,
	{ desc = "Format file or range (in visual mode)" }
)

-- import mason and mason_lspconfig
local mason = require "mason"
local mason_lspconfig = require "mason-lspconfig"
local mason_tool_installer = require "mason-tool-installer"

mason.setup {
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
}

mason_lspconfig.setup {
	automatic_enable = false,
	autoinstall = true,
	ensure_installed = {
		"lua_ls",
		"ts_ls",
		"html",
		"cssls",
		"tailwindcss",
		"marksman",
		"clangd", -- C / C++
		"pyright", -- Python
		"jdtls", -- Java
	},
}

mason_tool_installer.setup {
	ensure_installed = {
		"prettier",
		"stylua",
		"pylint",
		"isort",
		"black",
		"clang-format",
		"denols",
		"jdtls",
	},
}


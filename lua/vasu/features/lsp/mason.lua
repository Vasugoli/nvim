-- lua/vasu/features/lsp/mason.lua
-- Mason tool manager & LSP installer

local function setup_mason()
	local ok_mason, mason = pcall(require, "mason")
	if not ok_mason then return end
	local ok_mlsp, mason_lspconfig = pcall(require, "mason-lspconfig")
	local ok_mti, mason_tool_installer = pcall(require, "mason-tool-installer")

	mason.setup {
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	}

	if ok_mlsp then
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
	end

	if ok_mti then
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
	end
end

-- Defer Mason setup and tool checking to the event loop so it doesn't block startup
vim.schedule(setup_mason)

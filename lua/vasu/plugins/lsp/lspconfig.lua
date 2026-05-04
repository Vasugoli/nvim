-- lua/vasu/plugins/lsp/lspconfig.lua
-- Uses native vim.lsp.config / vim.lsp.enable (Neovim 0.11+ API)
-- nvim-lspconfig is only used for its bundled server definitions (cmd, root_dir, etc.)
-- The require("lspconfig") "framework" layer is intentionally NOT used.

local cmp_nvim_lsp = require "cmp_nvim_lsp"

-- ── Capabilities ─────────────────────────────────────────────────────────────
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Pass capabilities to every server globally
vim.lsp.config("*", {
	capabilities = capabilities,
})

-- ── On Attach ────────────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
	callback = function(ev)
		local opts = { buffer = ev.buf, silent = true }

		opts.desc = "Show LSP references"
		vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

		opts.desc = "Go to declaration"
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

		opts.desc = "Show LSP definitions"
		vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

		opts.desc = "Show LSP implementations"
		vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

		opts.desc = "Show LSP type definitions"
		vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

		opts.desc = "See available code actions"
		vim.keymap.set({ "n", "v" }, "<leader>ca", function() vim.lsp.buf.code_action() end, opts)

		opts.desc = "Smart rename"
		vim.keymap.set("n", "<leader>rn", function()
			-- local ok, renamer = pcall(require, "nvchad.lsp.rename")
			-- if ok then
			-- 	renamer()
			-- else
			-- 	vim.lsp.buf.rename()
			-- end
			require "nvchad.lsp.renamer"()
		end, opts)

		opts.desc = "Show buffer diagnostics"
		vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

		opts.desc = "Show line diagnostics"
		vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

		opts.desc = "Show documentation for what is under cursor"
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

		opts.desc = "Restart LSP"
		vim.keymap.set("n", "<leader>rs", ":lsp restart<CR>", opts)

		-- Inlay hints — enable if server supports it
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
		end
	end,
})

-- ── Diagnostics ──────────────────────────────────────────────────────────────
vim.diagnostic.config {
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅖 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
			[vim.diagnostic.severity.INFO] = "󰋼 ",
		},
	},
	virtual_text = true,
	underline = true,
	update_in_insert = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = true,
	},
}

vim.keymap.set("n", "<leader>lx", function()
	local current = vim.diagnostic.config().virtual_text
	vim.diagnostic.config { virtual_text = not current }
end, { desc = "Toggle LSP virtual text" })

-- ── LSP reference highlight ───────────────────────────────────────────────────
-- CursorHold fires after updatetime ms of inactivity — not on every cursor move
vim.api.nvim_create_autocmd("CursorHold", {
	group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true }),
	callback = function()
		local clients = vim.lsp.get_clients { bufnr = 0 }
		for _, client in ipairs(clients) do
			if client.server_capabilities.documentHighlightProvider then
				vim.lsp.buf.document_highlight()
				return
			end
		end
	end,
})

vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
	group = vim.api.nvim_create_augroup("LspReferenceClear", { clear = true }),
	callback = function() vim.lsp.buf.clear_references() end,
})

-- ── Server Configs ────────────────────────────────────────────────────────────
-- vim.lsp.config() sets config for a server name.
-- vim.lsp.enable() at the bottom starts them.
-- mason-lspconfig.setup{ automatic_enable = false } in mason.lua ensures
-- mason does NOT also start them — only one owner of server startup.

-- lua_ls
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			completion = { callSnippet = "Replace" },
		},
	},
})

-- ts_ls (TypeScript / JavaScript)
vim.lsp.config("ts_ls", {
	workspace_required = false,
	single_file_support = true,
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	init_options = {
		preferences = {
			includeCompletionsForModuleExports = true,
			includeCompletionsForImportStatements = true,
		},
	},
	settings = {
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayVariableTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
			},
		},
		javascript = {
			inlayHints = {
				includeInlayParameterNameHints = "none",
				includeInlayVariableTypeHints = false,
				includeInlayFunctionParameterTypeHints = false,
			},
		},
	},
})

-- cssls
vim.lsp.config("cssls", {
	single_file_support = true,
	filetypes = { "css", "scss", "less" },
	init_options = { provideFormatter = true },
	settings = {
		css = { lint = { unknownAtRules = "ignore" }, validate = true },
		scss = { lint = { unknownAtRules = "ignore" }, validate = true },
		less = { lint = { unknownAtRules = "ignore" }, validate = true },
	},
})

-- tailwindcss
vim.lsp.config("tailwindcss", {
	filetypes = {
		"html",
		"css",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"svelte",
		"vue",
		"astro",
	},
	init_options = {
		userLanguages = { astro = "html" },
	},
})

-- clangd (C / C++)
vim.lsp.config("clangd", {
	single_file_support = true,
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--function-arg-placeholders=1",
	},
	init_options = {
		usePlaceholders = true,
		completeUnimported = true,
		clangdFileStatus = true,
	},
})

-- pyright (Python)
vim.lsp.config("pyright", {
	single_file_support = true,
	filetypes = { "python" },
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "standard",
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "workspace",
				inlayHints = {
					variableTypes = true,
					functionReturnTypes = true,
					callArgumentNames = true,
					pytestParameters = true,
				},
			},
		},
	},
})

-- jdtls (Java)
vim.lsp.config("jdtls", {
	single_file_support = true,
	filetypes = { "java" },
	settings = {
		java = {
			inlayHints = {
				parameterNames = {
					enabled = "all",
				},
				variableTypes = {
					enabled = true,
				},
			},
		},
	},
})

-- ── Enable servers ────────────────────────────────────────────────────────────
-- This is the single place that starts servers.
-- mason-lspconfig must have automatic_enable = false (see mason.lua).
vim.lsp.enable {
	"lua_ls",
	"ts_ls",
	"html",
	"cssls",
	"tailwindcss",
	"marksman",
	"clangd",
	"pyright",
	"jdtls",
}

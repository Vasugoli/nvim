return {{
    "williamboman/mason.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("mason").setup()
    end
}, {
    "williamboman/mason-lspconfig.nvim",
    -- event = "VeryLazy",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("mason-lspconfig").setup({
            -- ensure_installed = {"lua_ls", "ts_ls"}
            auto_install = true
        })
    end
}, {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" }, -- load only when you open a file
    config = function()
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        vim.lsp.config.lua_ls = {
            cmd = { 'lua-language-server' },
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim' }
                    }
                }
            }
        }

        vim.lsp.config.ts_ls = {
            cmd = { 'typescript-language-server', '--stdio' },
            capabilities = capabilities
        }

        vim.lsp.config.tailwindcss = {
            cmd = { 'tailwindcss-language-server', '--stdio' },
            capabilities = capabilities
        }

        -- Enable LSP servers
        vim.lsp.enable({ 'lua_ls', 'ts_ls', 'tailwindcss' })

        vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
        vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, {})
    end
}}

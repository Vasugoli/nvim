return {
    "rebelot/heirline.nvim",
    event = "BufEnter",
    config = function()
        local conditions = require("heirline.conditions")
        local utils = require("heirline.utils")

        require("heirline").setup({
            statusline = {
                -- Git branch
                {
                    condition = conditions.is_git_repo,
                    provider = function()
                        return " " .. vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
                    end,
                    hl = { fg = "green", bold = true },
                },

                -- File info with icon
                {
                    provider = function()
                        local filename = vim.fn.expand("%:t")
                        if filename == "" then filename = "[No Name]" end
                        return " " .. filename
                    end,
                    hl = { fg = "cyan", bold = true },
                },

                -- File modified indicator
                {
                    condition = function()
                        return vim.bo.modified
                    end,
                    provider = " ●",
                    hl = { fg = "red" },
                },

                -- File readonly indicator
                {
                    condition = function()
                        return not vim.bo.modifiable or vim.bo.readonly
                    end,
                    provider = " ",
                    hl = { fg = "orange" },
                },

                -- Flexible space (pushes everything after to the right)
                { provider = "%=" },

                -- LSP diagnostics
                {
                    condition = conditions.has_diagnostics,
                    provider = function()
                        local diagnostics = vim.diagnostic.get(0)
                        local errors = #vim.tbl_filter(function(d) return d.severity == 1 end, diagnostics)
                        local warnings = #vim.tbl_filter(function(d) return d.severity == 2 end, diagnostics)
                        local info = #vim.tbl_filter(function(d) return d.severity == 3 end, diagnostics)
                        local hints = #vim.tbl_filter(function(d) return d.severity == 4 end, diagnostics)

                        local result = ""
                        if errors > 0 then result = result .. " E:" .. errors end
                        if warnings > 0 then result = result .. " W:" .. warnings end
                        if info > 0 then result = result .. " I:" .. info end
                        if hints > 0 then result = result .. " H:" .. hints end
                        return result
                    end,
                    hl = { fg = "red" },
                },

                -- LSP status (fixed deprecated function)
                {
                    condition = function()
                        return #vim.lsp.get_clients() > 0
                    end,
                    provider = function()
                        local clients = vim.lsp.get_clients({ bufnr = 0 })
                        if #clients > 0 then
                            return " LSP:" .. clients[1].name
                        end
                        return ""
                    end,
                    hl = { fg = "green" },
                },

                -- File type
                {
                    provider = function()
                        local ft = vim.bo.filetype
                        return ft ~= "" and " " .. ft or ""
                    end,
                    hl = { fg = "blue" },
                },

                -- File encoding
                {
                    provider = function()
                        local enc = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
                        return " " .. enc:upper()
                    end,
                    hl = { fg = "violet" },
                },

                -- Line/column info
                {
                    provider = " %l:%c ",
                    hl = { fg = "yellow" },
                },

                -- Percentage through file
                {
                    provider = " %P ",
                    hl = { fg = "magenta", bold = true },
                },
            },
            opts = {
                theme = "auto",
                colors = {
                    fg = "#abb2bf",
                    bg = "#282c34",
                    yellow = "#e0af68",
                    cyan = "#56b6c2",
                    darkblue = "#081633",
                    green = "#98c379",
                    orange = "#d19a66",
                    violet = "#a9a1e1",
                    magenta = "#c678dd",
                    blue = "#61afef",
                    red = "#e86671",
                },
            },
        })
    end,
}
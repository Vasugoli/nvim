return {
    "rebelot/heirline.nvim",
    event = "BufEnter",
    config = function()
        local conditions = require("heirline.conditions")
        local utils = require("heirline.utils")

        -- Define colors
        local colors = {
            bg = "#1e1e2e",
            bright_bg = "#3c4043",
            bright_fg = "#e8e3e3",
            red = "#e27878",
            dark_red = "#b02a37",
            green = "#84a0c6",
            blue = "#8fbcbb",
            gray = "#a89984",
            orange = "#e39b7b",
            purple = "#d2a6ff",
            cyan = "#89ddff",
            diag_warn = "#ffa500",
            diag_error = "#f44747",
            diag_hint = "#4FC1FF",
            diag_info = "#FFCC66",
            git_del = "#ffa500",
            git_add = "#109868",
            git_change = "#ffaa00",
        }

        -- Separators
        local separators = {
            left = "",
            right = "",
            left_thin = "│",
            right_thin = "│",
        }

        -- Mode component with separators
        local ViMode = {
            init = function(self)
                self.mode = vim.fn.mode(1)
                if not self.once then
                    vim.api.nvim_create_autocmd("ModeChanged", {
                        pattern = "*:*o",
                        command = 'redrawstatus'
                    })
                    self.once = true
                end
            end,
            static = {
                mode_names = {
                    n = "NORMAL",
                    no = "N-PENDING",
                    nov = "N-PENDING",
                    noV = "N-PENDING",
                    ["no\22"] = "N-PENDING",
                    niI = "NORMAL",
                    niR = "NORMAL",
                    niV = "NORMAL",
                    nt = "NORMAL",
                    v = "VISUAL",
                    vs = "VISUAL",
                    V = "V-LINE",
                    Vs = "V-LINE",
                    ["\22"] = "V-BLOCK",
                    ["\22s"] = "V-BLOCK",
                    s = "SELECT",
                    S = "S-LINE",
                    ["\19"] = "S-BLOCK",
                    i = "INSERT",
                    ic = "INSERT",
                    ix = "INSERT",
                    R = "REPLACE",
                    Rc = "REPLACE",
                    Rx = "REPLACE",
                    Rv = "V-REPLACE",
                    Rvc = "V-REPLACE",
                    Rvx = "V-REPLACE",
                    c = "COMMAND",
                    cv = "COMMAND",
                    r = "PROMPT",
                    rm = "MORE",
                    ["r?"] = "CONFIRM",
                    ["!"] = "SHELL",
                    t = "TERMINAL",
                },
                mode_colors = {
                    n = "green",
                    i = "blue",
                    v = "orange",
                    V = "orange",
                    ["\22"] = "orange",
                    c = "purple",
                    s = "cyan",
                    S = "cyan",
                    ["\19"] = "cyan",
                    R = "red",
                    r = "red",
                    ["!"] = "red",
                    t = "bright_bg",
                }
            },
            provider = function(self)
                return " " .. self.mode_names[self.mode] .. " "
            end,
            hl = function(self)
                local mode = self.mode:sub(1, 1)
                return { fg = "bright_bg", bg = self.mode_colors[mode] or "gray", bold = true }
            end,
            update = {
                "ModeChanged",
                pattern = "*:*",
                callback = vim.schedule_wrap(function()
                    vim.cmd("redrawstatus")
                end),
            },
        }

        -- Mode separator
        local ModeSeperator = {
            provider = separators.right,
            hl = function()
                local mode = vim.fn.mode(1):sub(1, 1)
                local mode_colors = {
                    n = "green",
                    i = "blue",
                    v = "orange",
                    V = "orange",
                    ["\22"] = "orange",
                    c = "purple",
                    s = "cyan",
                    S = "cyan",
                    ["\19"] = "cyan",
                    R = "red",
                    r = "red",
                    ["!"] = "red",
                    t = "bright_bg",
                }
                return { fg = mode_colors[mode] or "gray", bg = "bright_bg" }
            end,
        }

        -- Git branch with icon and separator
        local Git = {
            condition = conditions.is_git_repo,
            init = function(self)
                self.status_dict = vim.b.gitsigns_status_dict
                self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
            end,
            {
                provider = function(self)
                    return "  " .. (self.status_dict.head or "main")
                end,
                hl = { fg = "bright_fg", bg = "bright_bg", bold = true },
            },
            {
                condition = function(self)
                    return self.has_changes
                end,
                provider = " ",
                hl = { bg = "bright_bg" },
            },
            {
                provider = function(self)
                    local count = self.status_dict.added or 0
                    return count > 0 and ("+" .. count)
                end,
                hl = { fg = "git_add", bg = "bright_bg", bold = true },
            },
            {
                provider = function(self)
                    local count = self.status_dict.removed or 0
                    return count > 0 and ("-" .. count)
                end,
                hl = { fg = "git_del", bg = "bright_bg", bold = true },
            },
            {
                provider = function(self)
                    local count = self.status_dict.changed or 0
                    return count > 0 and ("~" .. count)
                end,
                hl = { fg = "git_change", bg = "bright_bg", bold = true },
            },
        }

        -- Git separator
        local GitSeparator = {
            condition = conditions.is_git_repo,
            provider = separators.right,
            hl = { fg = "bright_bg", bg = "bg" },
        }

        -- File info with icon
        local FileNameBlock = {
            init = function(self)
                self.filename = vim.api.nvim_buf_get_name(0)
            end,
            {
                provider = function(self)
                    local filename = vim.fn.fnamemodify(self.filename, ":t")
                    if filename == "" then return " [No Name]" end
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
        }

        -- LSP diagnostics with icons
        local Diagnostics = {
            condition = conditions.has_diagnostics,
            static = {
                error_icon = " ",
                warn_icon = " ",
                info_icon = " ",
                hint_icon = " ",
            },
            init = function(self)
                self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
                self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
                self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
                self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
            end,
            update = { "DiagnosticChanged", "BufEnter" },
            {
                provider = function(self)
                    return self.errors > 0 and (self.error_icon .. self.errors .. " ")
                end,
                hl = { fg = "diag_error" },
            },
            {
                provider = function(self)
                    return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
                end,
                hl = { fg = "diag_warn" },
            },
            {
                provider = function(self)
                    return self.info > 0 and (self.info_icon .. self.info .. " ")
                end,
                hl = { fg = "diag_info" },
            },
            {
                provider = function(self)
                    return self.hints > 0 and (self.hint_icon .. self.hints)
                end,
                hl = { fg = "diag_hint" },
            },
        }

        -- LSP status
        local LSPActive = {
            condition = function()
                return #vim.lsp.get_clients({ bufnr = 0 }) > 0
            end,
            provider = function()
                local names = {}
                for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
                    table.insert(names, server.name)
                end
                return " [" .. table.concat(names, " ") .. "]"
            end,
            hl = { fg = "green", bold = true },
        }

        -- File type with icon
        local FileType = {
            provider = function()
                return string.upper(vim.bo.filetype)
            end,
            hl = { fg = "blue", bold = true },
        }

        -- Position info
        local Ruler = {
            provider = " %l:%c %P ",
            hl = { fg = "yellow", bold = true },
        }

        -- Spacer
        local Align = { provider = "%=" }
        local Space = { provider = " " }

        -- Setup statusline
        require("heirline").setup({
            statusline = {
                ViMode,
                ModeSeperator,
                Git,
                GitSeparator,
                FileNameBlock,
                Space,
                Align,
                Diagnostics,
                Space,
                LSPActive,
                Space,
                FileType,
                Space,
                Ruler,
            },
            opts = {
                colors = colors,
            },
        })

        -- Set colors
        vim.api.nvim_set_hl(0, "StatusLine", { bg = colors.bright_bg, fg = colors.bright_fg })
    end,
}
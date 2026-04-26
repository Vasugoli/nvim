local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local devicons = require("nvim-web-devicons")

local function get_hl(name)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if not ok then return nil end
    local fg = hl.fg and string.format("#%06x", hl.fg) or "NONE"
    local bg = hl.bg and string.format("#%06x", hl.bg) or "NONE"
    return { fg = fg, bg = bg }
end

local colors = {
    bg = get_hl("Normal").bg,
    fg = get_hl("Normal").fg,
    dim = get_hl("Comment").fg,
    blue = get_hl("Function").fg,
    green = get_hl("String").fg,
    purple = get_hl("Statement").fg,
    red = get_hl("Error").fg,
    orange = get_hl("DiagnosticWarn").fg,
    yellow = get_hl("DiagnosticWarn").fg,
    cyan = get_hl("Identifier").fg
}

local Align = {provider = "%="}

local NeonSep = {
    -- example of a separator with a highlight from the colors table
    -- | ,  ,  ,  ,  ,  ,  ,
    provider = "|",
    hl = {fg = colors.cyan}
}

--------------------------------------------------
-- MODE
--------------------------------------------------
local ViMode = {
    init = function(self) self.mode = vim.fn.mode(1) end,
    static = {
        names = {
            n = "NORMAL",
            i = "INSERT",
            v = "VISUAL",
            V = "V-LINE",
            ["\22"] = "V-BLOCK",
            c = "COMMAND",
            R = "REPLACE",
            t = "TERMINAL"
        },
        icons = {
            n = "󰋜",
            i = "󰏫",
            v = "󰈈",
            V = "󰈈",
            ["\22"] = "󰈈",
            c = "󰘳",
            R = "󰛔",
            t = ""
        },
        colors = {
            n = "blue",
            i = "green",
            v = "purple",
            V = "purple",
            ["\22"] = "purple",
            c = "orange",
            R = "red",
            t = "cyan"
        }
    },
    provider = function(self)
        local m = self.mode:sub(1, 1)
        return " " .. (self.icons[m] or "") .. " " ..
                   (self.names[self.mode] or self.mode) .. " "
    end,
    hl = function(self)
        local m = self.mode:sub(1, 1)
        return {fg = colors.bg, bg = colors[self.colors[m]], bold = true}
    end,
    update = "ModeChanged"
}

--------------------------------------------------
-- FILE
--------------------------------------------------
local File = {
    init = function(self)
        self.name = vim.fn.expand("%:t")
        self.ext = vim.fn.expand("%:e")
        self.icon = devicons.get_icon(self.name, self.ext, {default = true})
    end,
    provider = function(self)
        if self.name == "" then return " 󰈤 [No Name] " end
        return " " .. (self.icon or "󰈤") .. " " .. self.name ..
                   (vim.bo.modified and " ●" or "") .. " "
    end,
    hl = {fg = colors.fg}
}

--------------------------------------------------
-- GIT BRANCH
--------------------------------------------------
local Git = {
    condition = conditions.is_git_repo,
    init = function(self) self.status = vim.b.gitsigns_status_dict end,
    provider = function(self) return "  " .. self.status.head .. " " end,
    hl = {fg = colors.purple}
}

--------------------------------------------------
-- GIT DIFF
--------------------------------------------------
local GitDiff = {
    condition = conditions.is_git_repo,
    init = function(self) self.status = vim.b.gitsigns_status_dict end,
    provider = function(self)
        local parts = {}
        if self.status.added and self.status.added > 0 then
            table.insert(parts, " " .. self.status.added)
        end
        if self.status.changed and self.status.changed > 0 then
            table.insert(parts, " " .. self.status.changed)
        end
        if self.status.removed and self.status.removed > 0 then
            table.insert(parts, " " .. self.status.removed)
        end
        if #parts == 0 then return "" end
        return " " .. table.concat(parts, "  ") .. " "
    end,
    hl = {fg = colors.dim}
}

--------------------------------------------------
-- DIAGNOSTICS
--------------------------------------------------
local Diagnostics = {
    condition = conditions.has_diagnostics,
    static = {error = " ", warn = " ", info = " ", hint = "󰌵 "},
    init = function(self)
        self.errors = #vim.diagnostic.get(0, {
            severity = vim.diagnostic.severity.ERROR
        })
        self.warnings = #vim.diagnostic.get(0, {
            severity = vim.diagnostic.severity.WARN
        })
        self.info = #vim.diagnostic.get(0, {
            severity = vim.diagnostic.severity.INFO
        })
        self.hints = #vim.diagnostic.get(0, {
            severity = vim.diagnostic.severity.HINT
        })
    end,
    provider = function(self)
        return " " ..
                   (self.errors > 0 and self.error .. self.errors .. " " or "") ..
                   (self.warnings > 0 and self.warn .. self.warnings .. " " or
                       "") ..
                   (self.info > 0 and self.info .. self.info .. " " or "") ..
                   (self.hints > 0 and self.hint .. self.hints .. " " or "")
    end,
    hl = {fg = colors.red},
    update = {"DiagnosticChanged", "BufEnter"}
}

--------------------------------------------------
-- CENTERED LSP (NEON CAPSULE)
--------------------------------------------------
local LSP = {
    condition = function()
        for _, c in ipairs(vim.lsp.get_clients({bufnr = 0})) do
            if c.name ~= "copilot" then return true end
        end
        return false
    end,
    provider = function()
        local names, seen = {}, {}
        local blacklist = {
            ["copilot"] = true,
            ["github copilot"] = true,
            ["null-ls"] = true,
            ["stylua"] = true
        }
        local rename = {
            ["lua_ls"] = "LuaLS",
            ["pyright"] = "Pyright",
            ["tsserver"] = "TS",
            ["gopls"] = "Go",
            ["clangd"] = "C/C++",
            ["rust_analyzer"] = "Rust"
        }
        for _, client in ipairs(vim.lsp.get_clients({bufnr = 0})) do
            local name = client.name:lower()
            if not blacklist[name] then
                local display = rename[name] or client.name
                if not seen[display] then
                    table.insert(names, display)
                    seen[display] = true
                end
            end
        end
        if #names == 0 then return "" end
        return "󰅩 " .. table.concat(names, ", ") .. " "
    end,
    hl = {fg = colors.cyan, bold = true}
}

--------------------------------------------------
-- DAP STATUS
--------------------------------------------------
local DAP = {
    condition = function()
        local dap = package.loaded["dap"]
        return dap and dap.session() ~= nil
    end,
    provider = function()
        local dap = package.loaded["dap"]
        if not dap then return "" end
        local status = dap.status()
        if status == "" then return "" end
        return "  " .. status .. " "
    end,
    hl = {fg = colors.red, bold = true}
}

--------------------------------------------------
-- SEARCH COUNT
--------------------------------------------------
local SearchCount = {
    condition = function()
        return vim.v.hlsearch ~= 0
    end,
    init = function(self)
        local ok, search = pcall(vim.fn.searchcount)
        if ok and search.total then
            self.search = search
        end
    end,
    provider = function(self)
        local search = self.search
        if not search or not search.current then return "" end
        return string.format(" [%d/%d] ", search.current, math.min(search.total, search.maxcount))
    end,
    hl = { fg = get_hl("accent").fg, bold = true },
}

--------------------------------------------------
-- MACRO RECORDING
--------------------------------------------------
local MacroRec = {
    condition = function()
        return vim.fn.reg_recording() ~= ""
    end,
    provider = " ",
    hl = { fg = get_hl("accent").fg, bold = true },
    utils.surround({ "[", "]" }, nil, {
        provider = function()
            return vim.fn.reg_recording()
        end,
        hl = { fg = get_hl("accent").fg, bold = true },
    }),
    update = {
        "RecordingEnter",
        "RecordingLeave",
    }
}

--------------------------------------------------
-- SHOW CMD
--------------------------------------------------
local ShowCmd = {
    condition = function()
        return true
    end,
    provider = " :%3.5(%S%) ",
    hl = { fg = colors.yellow, bold = true },
}


--------------------------------------------------
-- PROJECT CAPSULE
--------------------------------------------------
local ProjectCapsule = {
    provider = function()
        local parts = {}
        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        table.insert(parts, "󰉋 " .. cwd)

        local venv = os.getenv("VIRTUAL_ENV")
        if venv then
            local name = vim.fn.fnamemodify(venv, ":t")
            table.insert(parts, "󰌠 " .. name)
        end

        if vim.fn.executable("node") == 1 then
            local handle = io.popen("node -v 2>/dev/null")
            if handle then
                local result = handle:read("*a")
                handle:close()
                local major = result and result:match("v(%d+)")
                if major then
                    table.insert(parts, "󰎙 v" .. major)
                end
            end
        end

        return " " .. table.concat(parts, " | ") .. " "
    end,
    hl = {fg = colors.dim}
}

--------------------------------------------------
-- CLOCK
--------------------------------------------------
local Clock = {
    provider = function() return "  " .. os.date("%H:%M:%S") .. " " end,
    hl = {fg = colors.yellow}
}

--------------------------------------------------
-- RULER
--------------------------------------------------
local Ruler = {provider = " %l:%c  %P ", hl = {fg = colors.yellow}}

--------------------------------------------------
-- SCROLLBAR
--------------------------------------------------
local ScrollBar = {
    static = {sbar = {"▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"}},
    provider = function(self)
        local curr = vim.api.nvim_win_get_cursor(0)[1]
        local total = math.max(vim.api.nvim_buf_line_count(0), 1)
        local i = math.floor((curr - 1) / total * #self.sbar) + 1
        return self.sbar[i]
    end,
    hl = {fg = colors.blue}
}

--------------------------------------------------
-- STATUSLINE
--------------------------------------------------
require("heirline").setup({
    statusline = {
        ViMode, File, Git, GitDiff, Diagnostics, SearchCount,
        Align, LSP, Align,
        DAP, MacroRec, ProjectCapsule, Clock, Ruler, ScrollBar
    },
    opts = {colors = colors}
})

vim.api.nvim_set_hl(0, "StatusLine", {bg = "NONE"})


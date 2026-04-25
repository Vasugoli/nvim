-- folke/snacks.nvim — swiss-army UI toolkit
-- ── Setup ────────────────────────────────────────────────────────────────────
require("snacks").setup({
    bigfile = {enabled = true},
    quickfile = {enabled = true},
    statuscolumn = {enabled = true},
    words = {enabled = true},
    terminal = {enabled = true},

    dashboard = {
        -- Explicitly define sections to avoid the built-in 'startup' section
        -- which calls require('lazy.stats') — a lazy.nvim internal not available here.
        sections = {
            {section = "header"}, {section = "keys", gap = 1, padding = 1},
            {section = "recent_files", limit = 8, padding = 1},
            {section = "projects", limit = 8, padding = 1}
        },
        preset = {
            header = table.concat({
                [[                                                                       ]],
                [[                                                                     ]],
                [[       ████ ██████           █████      ██                     ]],
                [[      ███████████             █████                             ]],
                [[      █████████ ███████████████████ ███   ███████████   ]],
                [[     █████████  ███    █████████████ █████ ██████████████   ]],
                [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
                [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
                [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
                [[                                                                       ]]
            }, "\n"),
            keys = {
                {
                    icon = "󰈞 ",
                    key = "f",
                    desc = "Find File",
                    action = ":lua Snacks.dashboard.pick('files')"
                },
                {
                    icon = "󰜄 ",
                    key = "n",
                    desc = "New File",
                    action = ":ene | startinsert"
                }, {
                    icon = "󱎸 ",
                    key = "t",
                    desc = "Find Text",
                    action = ":lua Snacks.dashboard.pick('live_grep')"
                }, {
                    icon = "󰋚 ",
                    key = "r",
                    desc = "Recent Files",
                    action = ":lua Snacks.dashboard.pick('oldfiles')"
                }, {
                    icon = "󰒓 ",
                    key = "c",
                    desc = "Config",
                    action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})"
                }, {
                    icon = "󱁤 ",
                    key = "s",
                    desc = "Session Search",
                    action = ":AutoSession search"
                }, {
                    icon = "󰒲 ",
                    key = "L",
                    desc = "Lazy",
                    action = ":Lazy",
                    enabled = package.loaded.lazy ~= nil
                }, {
                    icon = "󰿅 ",
                    key = "q",
                    desc = "Quit",
                    action = function()
                        vim.cmd("silent! qa!")
                    end
                }
            }
        }
    },

    notifier = {
        enabled = false,
        timeout = 3000,
        border = "rounded",
        width = {min = 40, max = 0.4},
        height = {min = 1, max = 0.6},
        margin = {top = 0, right = 1, bottom = 0},
        padding = true,
        sort = {"level", "added"},
        level = vim.log.levels.TRACE,
        icons = {error = " ", warn = " ", info = " ", debug = " ", trace = " "}
    },

    notifications_history = {
        enabled = false,
        border = "rounded",
        zindex = 100,
        width = 0.6,
        height = 0.6,
        minimal = false,
        title = " Notification History ",
        title_pos = "center",
        ft = "markdown",
        bo = {filetype = "snacks_notif_history", modifiable = false},
        wo = {winhighlight = "Normal:SnacksNotifierHistory"},
        keys = {q = "close"}
    },

    picker = {
        ui_select = true,
        layout = {preset = "default"},
        sources = {
            files = {follow = true, hidden = false},
            buffers = {current = false},
            grep = {glob = true}
        }
    },

    styles = {notification = {wo = {wrap = true}}},

    indent = {enabled = true, animate = {enabled = false}}
})

-- Override vim.ui.select to use snacks picker
vim.ui.select = function(items, options, on_choice)
    return Snacks.picker.pick({
        items = items,
        format = options.format_item or tostring,
        prompt = options.prompt or "Select:",
        on_choice = on_choice
    })
end

-- ── VeryLazy toggles & debug globals ─────────────────────────────────────────
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        _G.dd = function(...) Snacks.debug.inspect(...) end
        _G.bt = function() Snacks.debug.backtrace() end
        vim.print = _G.dd

        Snacks.toggle.option("spell", {name = "spelling"}):map("<leader>us")
        Snacks.toggle.option("wrap", {name = "wrap"}):map("<leader>uw")
        Snacks.toggle.option("relativenumber", {name = "relative number"}):map(
            "<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.option("conceallevel", {
            off = 0,
            on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2
        }):map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", {
            off = "light",
            on = "dark",
            name = "dark background"
        }):map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
    end
})

-- ── Keymaps ──────────────────────────────────────────────────────────────────

-- Buffer management
vim.keymap.set("n", "<leader>x", function() Snacks.bufdelete() end,
               {desc = "Delete Buffer"})
vim.keymap.set("n", "<leader><leader>", function() Snacks.picker.buffers() end,
               {desc = "Find existing buffers"})

-- Git
vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end,
               {desc = "Lazygit"})
vim.keymap.set("n", "<leader>gb", function() Snacks.git.blame_line() end,
               {desc = "Git Blame Line"})
vim.keymap.set("n", "<leader>gB", function() Snacks.gitbrowse() end,
               {desc = "Git Browse"})
vim.keymap.set("n", "<leader>gf", function() Snacks.lazygit.log_file() end,
               {desc = "Lazygit Current File History"})
vim.keymap.set("n", "<leader>gl", function() Snacks.lazygit.log() end,
               {desc = "Lazygit Log (cwd)"})

-- File
vim.keymap.set("n", "<leader>cr", function() Snacks.rename.rename_file() end,
               {desc = "Rename File"})

-- Search / Picker
vim.keymap.set("n", "<leader>ls",
               function() Snacks.picker.lsp_workspace_symbols() end,
               {desc = "LSP Workspace Symbols"})
-- vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end,
--                {desc = "Search Files"})
vim.keymap.set("n", "<leader>fw", function() Snacks.picker.grep_word() end,
               {desc = "Search current Word"})
vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end,
               {desc = "Search Recent Files"})
vim.keymap.set("n", "<leader>fh", function() Snacks.picker.help() end,
               {desc = "Search Help"})
vim.keymap.set("n", "<leader>fk", function() Snacks.picker.keymaps() end,
               {desc = "Search Keymaps"})
vim.keymap.set("n", "<leader>fd", function() Snacks.picker.diagnostics() end,
               {desc = "Search Diagnostics"})
vim.keymap.set("n", "<leader>ss", function() Snacks.picker.pickers() end,
               {desc = "Search Select Picker"})
-- vim.keymap.set("n", "<leader>fc", function()
--     Snacks.picker.files({cwd = vim.fn.stdpath("config")})
-- end, {desc = "Search Neovim files"})
vim.keymap.set("n", "<leader>/", function() Snacks.picker.lines() end,
               {desc = "Search in current buffer"})
vim.keymap.set("n", "<leader>s/", function()
    local open_buffers = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
            local name = vim.api.nvim_buf_get_name(buf)
            if name ~= "" then table.insert(open_buffers, name) end
        end
    end
    Snacks.picker.grep({search_dirs = open_buffers})
end, {desc = "Search in Open Files"})

-- Word navigation
vim.keymap.set({"n", "t"}, "]]", function() Snacks.words.jump(vim.v.count1) end,
               {desc = "Next Reference"})
vim.keymap.set({"n", "t"}, "[[",
               function() Snacks.words.jump(-vim.v.count1) end,
               {desc = "Prev Reference"})

-- Neovim news
vim.keymap.set("n", "<leader>N", function()
    local news_file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1]
    if news_file then
        Snacks.win({
            file = news_file,
            width = 0.6,
            height = 0.6,
            wo = {
                spell = false,
                wrap = false,
                signcolumn = "yes",
                statuscolumn = " ",
                conceallevel = 3
            }
        })
    else
        vim.notify("News file not found", vim.log.levels.WARN)
    end
end, {desc = "Neovim News"})

-- Profiler
vim.keymap.set("n", "<leader>ps", function() Snacks.profiler.scratch() end,
               {desc = "Profiler Scratch Buffer"})

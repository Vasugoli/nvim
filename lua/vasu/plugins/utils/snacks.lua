return {
    "folke/snacks.nvim",
    priority = 1000,
    event = "VeryLazy",
    dependencies = {{
        "nvim-tree/nvim-web-devicons",
        opts = {
            -- globally enable different highlight colors per icon (default to true)
            color_icons = true,
            -- globally enable default icons (default to false)
            default = true,
            -- globally enable "strict" selection of icons - icon will be looked up in
            -- different tables, first by filename, and if not found by extension
            strict = true
        }
    }},
    keys = { -- Buffer management
    {
        "<leader>x",
        function()
            Snacks.bufdelete()
        end,
        desc = "Delete Buffer"
    }, {
        "<leader><leader>",
        function()
            Snacks.picker.buffers()
        end,
        desc = "Find existing buffers"
    }, -- Git functionality
    {
        "<leader>gg",
        function()
            Snacks.lazygit()
        end,
        desc = "Lazygit"
    }, {
        "<leader>gb",
        function()
            Snacks.git.blame_line()
        end,
        desc = "Git Blame Line"
    }, {
        "<leader>gB",
        function()
            Snacks.gitbrowse()
        end,
        desc = "Git Browse"
    }, {
        "<leader>gf",
        function()
            Snacks.lazygit.log_file()
        end,
        desc = "Lazygit Current File History"
    }, {
        "<leader>gl",
        function()
            Snacks.lazygit.log()
        end,
        desc = "Lazygit Log (cwd)"
    }, -- File operations
    {
        "<leader>cR",
        function()
            Snacks.rename.rename_file()
        end,
        desc = "Rename File"
    }, -- Terminal
    {
        "<c-/>",
        function()
            Snacks.terminal()
        end,
        desc = "Toggle Terminal"
    }, {
        "<c-_>",
        function()
            Snacks.terminal()
        end,
        desc = "which_key_ignore"
    }, -- Search functionality (matching telescope keymaps)
    {
        "<leader>ls",
        function()
            Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "LSP Workspace Symbols"
    }, {
        "<leader>ff",
        function()
            Snacks.picker.files()
        end,
        desc = "Search Files"
    }, --  {
    --     "<leader>fg",
    --     function()
    --         Snacks.picker.grep()
    --     end,
    --     desc = "Search by Grep"
    -- },
    {
        "<leader>fw",
        function()
            Snacks.picker.grep_word()
        end,
        desc = "Search current Word"
    }, {
        "<leader>fr",
        function()
            Snacks.picker.recent()
        end,
        desc = "Search Recent Files"
    }, {
        "<leader>fh",
        function()
            Snacks.picker.help()
        end,
        desc = "Search Help"
    }, {
        "<leader>fk",
        function()
            Snacks.picker.keymaps()
        end,
        desc = "Search Keymaps"
    }, {
        "<leader>fd",
        function()
            Snacks.picker.diagnostics()
        end,
        desc = "Search Diagnostics"
    }, {
        "<leader>ss",
        function()
            Snacks.picker.pickers()
        end,
        desc = "Search Select Picker"
    }, {
        "<leader>fc",
        function()
            Snacks.picker.files({
                cwd = vim.fn.stdpath("config")
            })
        end,
        desc = "Search Neovim files"
    }, {
        "<leader>/",
        function()
            Snacks.picker.lines()
        end,
        desc = "Search in current buffer"
    }, {
        "<leader>s/",
        function()
            local open_buffers = {}
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
                    local name = vim.api.nvim_buf_get_name(buf)
                    if name ~= "" then
                        table.insert(open_buffers, name)
                    end
                end
            end
            Snacks.picker.grep({
                search_dirs = open_buffers
            })
        end,
        desc = "Search in Open Files"
    }, -- Word navigation
    {
        "]]",
        function()
            Snacks.words.jump(vim.v.count1)
        end,
        desc = "Next Reference",
        mode = {"n", "t"}
    }, {
        "[[",
        function()
            Snacks.words.jump(-vim.v.count1)
        end,
        desc = "Prev Reference",
        mode = {"n", "t"}
    }, -- Notifications
    {
        "<leader>un",
        function()
            Snacks.notifier.hide()
        end,
        desc = "Dismiss All Notifications"
    }, --  {
    --     "<leader>hn",
    --     function()
    --         Snacks.notifier.show_history()
    --     end,
    --     desc = "Show Notification History"
    -- }, -- Utility
    {
        "<leader>N",
        desc = "Neovim News",
        function()
            local news_file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1]
            if news_file then
                Snacks.win {
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
                }
            else
                vim.notify("News file not found", vim.log.levels.WARN)
            end
        end
    }, {
        "<leader>ps",
        function()
            Snacks.profiler.scratch()
        end,
        desc = "Profiler Scratch Buffer"
    }},
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd -- Override print to use snacks for `:=` command

                -- Create some toggle mappings
                Snacks.toggle.option("spell", {
                    name = "spelling"
                }):map("<leader>us")
                Snacks.toggle.option("wrap", {
                    name = "wrap"
                }):map("<leader>uw")
                Snacks.toggle.option("relativenumber", {
                    name = "relative number"
                }):map("<leader>uL")
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
    end,
    opts = {
        bigfile = {
            enabled = true
        },
        dashboard = {
            preset = {
                header = table.concat({[[                                                                       ]],
                                       [[                                                                     ]],
                                       [[       ████ ██████           █████      ██                     ]],
                                       [[      ███████████             █████                             ]],
                                       [[      █████████ ███████████████████ ███   ███████████   ]],
                                       [[     █████████  ███    █████████████ █████ ██████████████   ]],
                                       [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
                                       [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
                                       [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
                                       [[                                                                       ]]},
                    "\n"),
                keys = {{
                    icon = "󰈞 ",
                    key = "f",
                    desc = "Find File",
                    action = ":lua Snacks.dashboard.pick('files')"
                }, {
                    icon = "󰜄 ",
                    key = "n",
                    desc = "New File",
                    action = ":ene | startinsert"
                }, {
                    icon = "󱎸 ",
                    key = "g",
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
                    action = ":qa"
                }}
            }
        },
        notifier = {
            enabled = false,
            timeout = 3000,
            border = "rounded",
            width = {
                min = 40,
                max = 0.4
            },
            height = {
                min = 1,
                max = 0.6
            },
            margin = {
                top = 0,
                right = 1,
                bottom = 0
            },
            padding = true,
            sort = {"level", "added"},
            level = vim.log.levels.TRACE,
            icons = {
                error = " ",
                warn = " ",
                info = " ",
                debug = " ",
                trace = " "
            }
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
            bo = {
                filetype = "snacks_notif_history",
                modifiable = false
            },
            wo = {
                winhighlight = "Normal:SnacksNotifierHistory"
            },
            keys = {
                q = "close"
            }
        },
        quickfile = {
            enabled = true
        },
        statuscolumn = {
            enabled = true
        },
        words = {
            enabled = true
        },
        picker = {
            ui_select = true,
            layout = {
                preset = "default"
            },
            sources = {
                files = {
                    follow = true,
                    hidden = false
                },
                buffers = {
                    current = false
                },
                grep = {
                    glob = true
                }
            }
        },
        styles = {
            notification = {
                wo = {
                    wrap = true
                }
            }
        },
        indent = {
            enabled = false,
            animate = {
                enabled = true
            }
        },
        terminal = {
            enabled = true
        }
    },
    config = function(_, opts)
        require("snacks").setup(opts)

        -- Set up vim.ui.select to use snacks picker (replaces telescope-ui-select)
        vim.ui.select = function(items, options, on_choice)
            return Snacks.picker.pick({
                items = items,
                format = options.format_item or tostring,
                prompt = options.prompt or "Select:",
                on_choice = on_choice
            })
        end
    end
}

return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        -- add any options here
    },
    dependencies = { -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim", -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify"},
    config = function()
        local noice = require("noice")
        local notify = require("notify")
        vim.notify = notify
        notify.setup({
            -- Animation style (see below for details)
            stages = "fade_in_slide_out",
            -- Function called when a new window is opened, use for changing win settings/config
            on_open = nil,
            -- Function called when a window is closed
            on_close = nil,
            -- Render function for notifications. See notify-render()
            render = "compact",
            -- Default timeout for notifications
            timeout = 3000,
            -- Max number of columns for messages
            max_width = nil,
            -- Max number of lines for a message
            max_height = nil,
            -- For stages that change opacity this is treated as the highlight behind the window
            background_colour = "#000000",
            -- Minimum width for notification windows
            minimum_width = 50,
            -- Icons for the different levels
            icons = {
                ERROR = "",
                WARN = "",
                INFO = "",
                DEBUG = "",
                TRACE = "✎"
            }
        })
        noice.setup {
            cmdline = {
                enabled = true,
                view = "cmdline_popup",
                opts = {}
            },
            messages = {
                enabled = true
            },
            completion = {
                enabled = true,
                view = "native",
                opts = {}
            },
            popupmenu = {
                enabled = true, -- This is important for completion menu
                backend = "cmp" -- Use cmp for popup menu
            },
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true
                }
            },
            -- routes = {
            --     {
            --         filter = {
            --             event = "msg_show",
            --             any = {{
            --                 find = "%d+L, %d+B"
            --             }, {
            --                 find = "; after #%d+"
            --             }, {
            --                 find = "; before #%d+"
            --             }}
            --         },
            --         view = "mini"
            --     },
            --     {
            --         filter = {
            --             event = "msg_show",
            --             kind = "search_count"
            --         },
            --         opts = {
            --             skip = true
            --         }
            --     },
            --     {
            --         filter = {
            --             event = "msg_show",
            --             find = "written"
            --         },
            --         opts = {
            --             skip = true
            --         }
            --     },
            --     {
            --         filter = {
            --             event = "msg_show",
            --             any = {{
            --                 find = "%d+ changes?"
            --             }, {
            --                 find = "%d+ lines? .ed"
            --             }, {
            --                 find = "Already at .* change"
            --             }}
            --         },
            --         opts = {
            --             skip = true
            --         }
            --     },
            --     {
            --         filter = {
            --             event = "msg_show",
            --             find = "%d+ lines yanked"
            --         },
            --         opts = {
            --             skip = true
            --         }
            --     },
            --     {
            --         filter = {
            --             event = "msg_show",
            --             find = "%d+ substitutions? on %d+ lines?"
            --         },
            --         view = "mini"
            --     },
            --     {
            --         filter = {
            --             event = "msg_show",
            --             min_height = 20
            --         },
            --         view = "split"
            --     },
            --     {
            --         filter = {
            --             event = "lsp",
            --             kind = "progress",
            --             find = "code_action"
            --         },
            --         opts = {
            --             skip = true
            --         }
            --     },
            --     {
            --         filter = {
            --             event = "notify",
            --             find = "No information available"
            --         },
            --         opts = {
            --             skip = true
            --         }
            --     }
            -- },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = false,
                lsp_doc_border = false
            }
        }

    end
}


-- rcarriga/nvim-notify — pretty notification UI
local notify = require("notify")

notify.setup({
    stages = "fade_in_slide_out",
    render = "compact",
    timeout = 2000,
    max_width = nil,
    max_height = nil,
    background_colour = "#000000",
    minimum_width = 50,
    icons = {ERROR = "", WARN = "", INFO = "", DEBUG = "", TRACE = "✎"}
})


vim.notify = notify

-- j-hui/fidget.nvim — LSP progress notifications
require("fidget").setup({
    -- Options related to LSP progress subsystem
    progress = {
        poll_rate = 0,                -- How and when to poll for progress messages
        suppress_on_insert = false,   -- Suppress new messages while in insert mode
        ignore_done_already = false,  -- Ignore new messages that are already complete
        ignore_empty_message = false, -- Ignore new messages that don't contain a message

        -- Clear notification group when LSP server detaches
        clear_on_detach = function(client_id)
            local client = vim.lsp.get_client_by_id(client_id)
            return client and client.name or "Unknown LSP"
        end,

        -- How to get a progress message's notification group key
        notification_group = function(msg)
            return msg.lsp_client.name
        end,
    },

    -- Options related to notification subsystem
    notification = {
        poll_rate = 10,               -- How often to update and render notifications
        filter = vim.log.levels.INFO, -- Minimum notifications level
        history_size = 128,           -- Number of removed messages to retain in history
        override_vim_notify = false,  -- Automatically override vim.notify() with Fidget
        redirect = function(msg, level, opts)
            if opts and opts.on_open then
                return nil
            end
            return vim.notify(msg, level, opts)
        end,

        -- Options related to how notifications are rendered as text
        view = {
            stack_upwards = true,    -- Display next notification above the previous one
            icon_separator = " ",     -- Separator between group name and icon
            group_separator = "---",  -- Separator between notification groups
            -- Highlight group used for group name
            group_separator_hl = "Comment",
        },

        -- Options related to the notification window and buffer
        window = {
            normal_hl = "Comment",    -- Base highlight group in the notification window
            winblend = 0,             -- Background color opacity in the notification window
            border = "none",          -- Border around the notification window
            zindex = 45,               -- Stacking priority of the notification window
            max_width = 0,            -- Maximum width of the notification window
            max_height = 0,           -- Maximum height of the notification window
            x_alignment = "right",    -- How to align the notification window horizontally
            y_alignment = "bottom",   -- How to align the notification window vertically
            align_bottom = true,      -- Whether to align the notification window to the bottom
        },
    },
})

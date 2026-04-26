-- nvim-neo-tree/neo-tree.nvim

-- ── Global toggle keymap ─────────────────────────────────────────────────────
vim.keymap.set("n", "<Leader>e", "<Cmd>Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
vim.keymap.set("n", "<Leader>eb", "<cmd>Neotree buffers<cr>", { desc = "Buffer explorer" })
vim.keymap.set("n", "<Leader>eg", "<cmd>Neotree git_status<cr>", { desc = "Git explorer" })

-- ── Setup ────────────────────────────────────────────────────────────────────
require("neo-tree").setup({
    sources = { "filesystem", "buffers", "git_status" },
    open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = false,
    source_selector = {
        winbar = true,
        statusline = false,
        content_layout = "center",
        tabs_layout = "equal",
        show_separator_on_edge = true,
        sources = {
            { source = "filesystem", display_name = " Files " },
            { source = "buffers", display_name = " Buffers " },
            { source = "git_status", display_name = " Git " },
        },
    },

    default_component_configs = {
        container = {
            enable_character_fade = true
        },
        indent = {
            indent_size = 2,
            padding = 1,
            -- indent guides
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            -- expander config
            with_expanders = true, -- Enable expanders for arrows
            expander_collapsed = "󰅂",
            expander_expanded = "󰅀",
            expander_highlight = "NeoTreeExpander",
        },
        icon = {
            folder_closed = "󰉋",
            folder_open = "󰝰",
            folder_empty = "󰉖",
            -- Using the blue circle icon from the target image
            default = "󰗚",
            highlight = "NeoTreeFileIcon"
        },
        name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
        },
        git_status = {
            symbols = {
                -- Cleaned up git symbols
                added     = "",
                modified  = "",
                deleted   = "✖",
                renamed   = "󰁕",
                -- Status type
                untracked = "",
                ignored   = "",
                unstaged  = "󰄱",
                staged    = "󰱒",
                conflict  = "",
            }
        },
    },
    window = {
        position = "left",
        width = 32,
        mapping_options = {
            noremap = true,
            nowait = true,
        },
        mappings = {
            ["<space>"] = "none",
            ["l"] = "open",
            ["<cr>"] = "open",
            ["o"] = "open",
            ["h"] = "close_node",
            ["/"] = "fuzzy_finder",
            ["a"] = { "add", config = { show_path = "none" } },
            ["d"] = "delete",
            ["r"] = "rename",
            ["x"] = "cut_to_clipboard",
            ["y"] = "copy_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["R"] = "refresh",
            ["q"] = "close_window",
            ["Y"] = {
                function(state)
                    local node = state.tree:get_node()
                    local path = node:get_id()
                    vim.fn.setreg("+", path, "c")
                    vim.notify("Copied path: " .. path)
                end,
                desc = "Copy Path to Clipboard",
            },
            ["O"] = {
                function(state)
                    local path = state.tree:get_node().path
                    -- Use Snacks or fallback to vim.ui.open
                    if _G.Snacks then
                        Snacks.open(path)
                    else
                        vim.ui.open(path)
                    end
                end,
                desc = "Open with System Application",
            },
            ["P"] = { "toggle_preview", config = { use_float = false } },
            ["1"] = function() vim.cmd("Neotree filesystem") end,
            ["2"] = function() vim.cmd("Neotree buffers") end,
            ["3"] = function() vim.cmd("Neotree git_status") end,
        }
    },
    filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = false,
        },
    },
})

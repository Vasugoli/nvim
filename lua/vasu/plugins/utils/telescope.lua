return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "folke/trouble.nvim",
        "folke/todo-comments.nvim",
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local trouble = require("trouble.sources.telescope")

        telescope.setup({
            defaults = {
                path_display = { "smart" },
                file_ignore_patterns = {
                    "node_modules",
                    ".git/",
                    "dist/",
                    "build/",
                },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        ["<C-t>"] = trouble.open,
                        ["<C-u>"] = false, -- Clear prompt
                        ["<C-d>"] = actions.delete_buffer,
                    },
                    n = {
                        ["q"] = actions.close,
                        ["<C-t>"] = trouble.open,
                    },
                },
            },
            pickers = {
                live_grep = {
                    additional_args = function(opts)
                        return {"--hidden", "--no-ignore"}
                    end,
                    glob_pattern = "!{.git,node_modules,dist,build}/*",
                },
                grep_string = {
                    theme = "ivy",
                    word_match = "-w",
                    only_sort_text = true,
                },
                find_files = {
                    theme = "dropdown",
                    previewer = false,
                    hidden = true,
                    find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                },
                buffers = {
                    theme = "dropdown",
                    previewer = false,
                    sort_mru = true,
                    sort_lastused = true,
                },
                help_tags = {
                    theme = "ivy",
                    previewer = true,
                },
                colorscheme = {
                    theme = "dropdown",
                    enable_preview = true,
                },
                commands = {
                    theme = "ivy",
                },
            },
            extensions = {
            },
        })

        -- telescope.load_extension("fzf")

        -- Keymaps
        local keymap = vim.keymap.set
        local builtin = require("telescope.builtin")

        -- File operations
        -- keymap("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
        -- keymap("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
        -- keymap("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })

        -- Search operations
        keymap("n", "<leader>fg", builtin.live_grep, { desc = "Live grep in files" })
        -- keymap("n", "<leader>fw", builtin.grep_string, { desc = "Find word under cursor" })
        keymap("n", "<leader>fb", function()
            builtin.live_grep({
                prompt_title = "Live Grep in Current Buffer",
                search_dirs = { vim.fn.expand("%:p:h") },
            })
        end, { desc = "Live grep in current directory" })

        -- Enhanced live grep with options
        keymap("n", "<leader>fS", function()
            builtin.live_grep({
                prompt_title = "Live Grep (Include Hidden)",
                additional_args = function()
                    return {"--hidden", "--no-ignore", "--follow"}
                end,
            })
        end, { desc = "Live grep (include hidden files)" })

        -- Search in specific file types
        keymap("n", "<leader>fL", function()
            builtin.live_grep({
                prompt_title = "Live Grep in Lua Files",
                type_filter = "lua",
                additional_args = function()
                    return {"--type", "lua"}
                end,
            })
        end, { desc = "Live grep in Lua files" })

        keymap("n", "<leader>fJ", function()
            builtin.live_grep({
                prompt_title = "Live Grep in JS/TS Files",
                additional_args = function()
                    return {"--type", "js", "--type", "ts", "--type", "jsx", "--type", "tsx"}
                end,
            })
        end, { desc = "Live grep in JS/TS files" })

        -- Other telescope functions
        keymap("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
        -- keymap("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
        -- keymap("n", "<leader>fk", builtin.keymaps, { desc = "Keymaps" })
        -- keymap("n", "<leader>fC", builtin.colorscheme, { desc = "Colorschemes" })
        -- keymap("n", "<leader>fm", builtin.marks, { desc = "Marks" })
        -- keymap("n", "<leader>fj", builtin.jumplist, { desc = "Jumplist" })
        -- keymap("n", "<leader>fq", builtin.quickfix, { desc = "Quickfix list" })
        -- keymap("n", "<leader>fl", builtin.loclist, { desc = "Location list" })

        -- Git operations
        -- keymap("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
        -- keymap("n", "<leader>gf", builtin.git_files, { desc = "Git files" })
        -- keymap("n", "<leader>gs", builtin.git_status, { desc = "Git status" })
        -- keymap("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })

        -- LSP operations
        -- keymap("n", "<leader>lr", builtin.lsp_references, { desc = "LSP references" })
        -- keymap("n", "<leader>ld", builtin.lsp_definitions, { desc = "LSP definitions" })
        -- keymap("n", "<leader>li", builtin.lsp_implementations, { desc = "LSP implementations" })
        -- keymap("n", "<leader>ls", builtin.lsp_document_symbols, { desc = "Document symbols" })
        -- keymap("n", "<leader>lw", builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })

        -- Noice integration keymaps
        keymap("n", "<leader>hn", function()
            if pcall(require, "telescope._extensions.notify") then
                require("telescope").extensions.notify.notify()
            else
                vim.notify("Telescope notify extension not available", vim.log.levels.WARN)
            end
        end, { desc = "Notification history" })

        keymap("n", "<leader>fN", function()
            if pcall(require, "noice") then
                require("noice").cmd("telescope")
            else
                vim.notify("Noice not available", vim.log.levels.WARN)
            end
        end, { desc = "Noice message history" })

        -- Search noice messages
        keymap("n", "<leader>fM", function()
            if not pcall(require, "noice") then
                vim.notify("Noice not available", vim.log.levels.WARN)
                return
            end

            local messages = {}
            local ok, history = pcall(require("noice").api.get_message_history)

            if not ok or not history then
                vim.notify("No message history available", vim.log.levels.INFO)
                return
            end

            for _, msg in ipairs(history) do
                if msg.content and msg.content ~= "" then
                    table.insert(messages, {
                        text = msg.content,
                        kind = msg.kind or "info",
                        time = msg.time or os.time(),
                    })
                end
            end

            if #messages == 0 then
                vim.notify("No messages in history", vim.log.levels.INFO)
                return
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Noice Message History",
                finder = require("telescope.finders").new_table({
                    results = messages,
                    entry_maker = function(entry)
                        return {
                            value = entry,
                            display = string.format("[%s] %s", entry.kind, entry.text),
                            ordinal = entry.text,
                        }
                    end,
                }),
                sorter = require("telescope.config").values.generic_sorter({}),
                previewer = require("telescope.previewers").new_buffer_previewer({
                    title = "Message Details",
                    define_preview = function(self, entry, status)
                        local content = {
                            "Kind: " .. entry.value.kind,
                            "Time: " .. os.date("%Y-%m-%d %H:%M:%S", entry.value.time),
                            "",
                            "Content:",
                            entry.value.text,
                        }
                        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, content)
                    end,
                }),
            }):find()
        end, { desc = "Search noice messages" })
    end,
}
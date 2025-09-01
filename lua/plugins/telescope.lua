return {
    "nvim-telescope/telescope.nvim",
    branch = "master", -- using master to fix issues with deprecated to definition warnings
    -- '0.1.x' for stable ver.
    dependencies = {"nvim-lua/plenary.nvim", {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make"
    }, "nvim-tree/nvim-web-devicons", "andrew-george/telescope-themes"},
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local builtin = require("telescope.builtin")

        telescope.load_extension("fzf")
        telescope.load_extension("themes")

        telescope.setup({
            defaults = {
                path_display = {"smart"},
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next
                    }
                }
            },
            extensions = {
                themes = {
                    enable_previewer = true,
                    enable_live_preview = true,
                    persist = {
						enabled = true,
                        path = vim.fn.stdpath("config") .. "/lua/colorscheme.lua"
                    }
                },
                fzf = {
					enable_previewer = true,
					enable_live_preview = true,
                    fuzzy = true, -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true, -- override the file sorter
                    case_mode = "smart_case" -- or "ignore_case" or "respect_case"
                },
				ui_select = {
					require("telescope.themes").get_dropdown()
				}
            }
        })

        -- Keymaps
        vim.keymap.set("n", "<leader>pr", "<cmd>Telescope oldfiles<CR>", {
            desc = "Fuzzy find recent files"
        })
        vim.keymap.set("n", "<leader>pWs", function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({
                search = word
            })
        end, {
            desc = "Find Connected Words under cursor"
        })

        vim.keymap.set("n", "<leader>ths", "<cmd>Telescope themes<CR>", {
            noremap = true,
            silent = true,
            desc = "Theme Switcher"
        })
    end
}

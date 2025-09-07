return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	event = "VeryLazy",
	config = function()
		local telescope = require "telescope"
		local actions = require "telescope.actions"
		local builtin = require "telescope.builtin"

		telescope.setup {
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
					},
				},
			},
			pickers = {
				buffers = {
					sort_mru = true,
					previewer = true,
					mappings = {
						i = {
							["<c-d>"] = "delete_buffer",
						},
						n = {
							["<c-d>"] = "delete_buffer",
						},
					},
				},
			},
			extensions = {
				ui_select = {},
			},
		}
	end,
}

return {
	{
		"zaldih/themery.nvim",
		lazy = false,
		config = function()
			require("themery").setup {
				themes = {
					"gruvbox",
					"catppuccin",
					"catppuccin-frappe",
					"catppuccin-macchiato",
					"catppuccin-mocha",
					"dracula",
					"rose-pine",
					"rose-pine-moon",
					"tokyonight",
					"tokyonight-moon",
					"tokyonight-night",
					"tokyonight-storm",
					"cyberdream",
					"cyberdream-light",
					"kanagawa",
					"nightfox",
					"onedark",
					"onelight",
					"onedark_vivid",
					"onedark_dark",
					"vaporwave",
					"onedark-darker",
					"onedark-cool",
					"onedark-deep",
					"onedark-warm",
					"github-theme",
					"github-theme-light",
					"github-theme-dark",
					"github-theme-dark_default",
					"github-theme-dark_dimmed",
					"github-theme-dark_high_contrast",
					"github-theme-light_default",
					"github-theme-light_high_contrast",
				},
				livePreview = true,
			}
			vim.keymap.set("n", "<leader>tc", "<cmd>Themery<CR>", {
				desc = "Pick Color Theme (Themery)",
			})
		end,
	},
	{
		"morhetz/gruvbox",
		lazy = true,
	},
	{
		"rose-pine/neovim",
		lazy = true,
		name = "rose-pine",
		variant = {
			"main",
			"moon",
		},
	},
	{
		"catppuccin/nvim",
		lazy = true,
		name = "catppuccin",
		flavors = {
			"frappe",
			"macchiato",
			"mocha",
		},
	},
	{
		"folke/tokyonight.nvim",
		lazy = true,
		style = {
			"storm",
			"moon",
			"night",
		},
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = true,
	},
	{
		"navarasu/onedark.nvim",
		lazy = true,
		style = {
			"dark",
			"darker",
			"cool",
			"deep",
			"warm",
		},
	},
	{
		"projekt0n/github-nvim-theme",
		lazy = true,
		name = "github-theme",
	},
	{
		"scottmckendry/cyberdream.nvim",
		lazy = true,
		name = "cyberdream",
		variant = {
			"dark",
			"light",
		},
	},
	{
		"olimorris/onedarkpro.nvim",
		lazy = true,
		theme = {
			"onedark",
			"onelight",
			"onedark_vivid",
			"onelight_vivid",
		},
	},
	{
		"Mofiqul/dracula.nvim",
		lazy = true,
	},
}

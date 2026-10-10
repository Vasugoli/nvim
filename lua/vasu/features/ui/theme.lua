-- lua/vasu/features/ui/theme.lua
-- NvChad Base46 theme, cheat sheet, and color tools

local status_base46, _ = pcall(require, "base46")
if not status_base46 then return end

-- Load base46 highlights
local function load_highlights()
	local cache_dir = vim.g.base46_cache
	if vim.fn.isdirectory(cache_dir) == 0 then vim.fn.mkdir(cache_dir, "p") end

	local files = vim.fn.readdir(cache_dir)
	if #files == 0 then
		-- Compile if cache is empty
		pcall(function() require("base46").compile() end)
		files = vim.fn.readdir(cache_dir)
	end

	for _, plugin in ipairs(files) do
		dofile(cache_dir .. plugin)
	end
end

pcall(load_highlights)

-- Setup NvChad UI components
pcall(require, "nvchad")

-- Keymaps for NvChad features
vim.keymap.set("n", "<leader>ct", function()
	require("nvchad.themes").open {
		style = "flat", -- flat/rounded/bordered
	}
end, { desc = "NvChad Theme Switcher" })

vim.keymap.set("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "NvChad CheatSheet" })

-- Minty (color picker & shades)
vim.keymap.set("n", "<leader>cp", "<cmd>Huefy<CR>", { desc = "Minty Color Picker" })
vim.keymap.set("n", "<leader>cs", "<cmd>Shades<CR>", { desc = "Minty Color Shades" })

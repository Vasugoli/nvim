-- lua/vasu/pack-hooks.lua
-- Early lifecycle hooks for vim.pack (builds & updates)

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(event)
		local data = event.data
		if not data or not data.spec or not data.spec.name then
			return
		end

		local name = data.spec.name
		local kind = data.kind
		local active = data.active

		-- only run on nvim-treesitter updates/installs
		if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
			if not active then pcall(vim.cmd.packadd, "nvim-treesitter") end
			pcall(vim.cmd, "TSUpdate")
		end

		-- FFF nvim binary build / download
		if name == "fff.nvim" and (kind == "install" or kind == "update") then
			if not active then pcall(vim.cmd.packadd, "fff.nvim") end
			pcall(function() require("fff.download").download_or_build_binary() end)
		end

		-- Blink.cmp fuzzy prebuilt download / build
		if name == "blink.cmp" and (kind == "install" or kind == "update") then
			if not active then pcall(vim.cmd.packadd, "blink.cmp") end
			pcall(function() require("blink.cmp.fuzzy.build").build() end)
		end
	end,
})

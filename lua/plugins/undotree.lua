return {
    "jiaoshijie/undotree",
    dependencies = {"nvim-lua/plenary.nvim"},
    config = function()
        require("undotree").setup({})
    end,
    keys = {
        {"<leader>u", function() require("undotree").toggle() end, desc = "Toggle Undotree"}
    }
}

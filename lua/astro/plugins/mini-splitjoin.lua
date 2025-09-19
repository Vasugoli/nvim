return {
    "echasnovski/mini.splitjoin",
    event = {"BufReadPost", "BufNewFile"},
    config = function()
        local miniSplitJoin = require("mini.splitjoin")
        miniSplitJoin.setup({
            mappings = {
                toggle = ""
            } -- Disable default mapping
        })
        vim.keymap.set({"n", "x"}, "mj", function()
            miniSplitJoin.join()
        end, {
            desc = "Join arguments"
        })
        vim.keymap.set({"n", "x"}, "mk", function()
            miniSplitJoin.split()
        end, {
            desc = "Split arguments"
        })
    end
}

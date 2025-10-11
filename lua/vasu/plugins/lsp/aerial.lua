return {
  "stevearc/aerial.nvim",
  event = "VeryLazy",
  keys = {
    { "<Leader>lS", function() require("aerial").toggle() end, desc = "Symbols outline" },
    { "]y", function() require("aerial").next(vim.v.count1) end, desc = "Next symbol" },
    { "[y", function() require("aerial").prev(vim.v.count1) end, desc = "Previous symbol" },
    { "]Y", function() require("aerial").next_up(vim.v.count1) end, desc = "Next symbol upwards" },
    { "[Y", function() require("aerial").prev_up(vim.v.count1) end, desc = "Previous symbol upwards" },
  },
  opts = {
    attach_mode = "global",
    backends = { "lsp", "treesitter", "markdown", "man" },
    layout = { min_width = 28 },
    show_guides = true,
    filter_kind = false,
    guides = {
      mid_item = "├ ",
      last_item = "└ ",
      nested_top = "│ ",
      whitespace = "  ",
    },
    keymaps = {
      ["[y"] = "actions.prev",
      ["]y"] = "actions.next",
      ["[Y"] = "actions.prev_up",
      ["]Y"] = "actions.next_up",
      ["{"] = false,
      ["}"] = false,
      ["[["] = false,
      ["]]"] = false,
    },
    on_attach = function(bufnr)
      vim.keymap.set("n", "]y", function() require("aerial").next(vim.v.count1) end,
        { desc = "Next symbol", buffer = bufnr })
      vim.keymap.set("n", "[y", function() require("aerial").prev(vim.v.count1) end,
        { desc = "Previous symbol", buffer = bufnr })
      vim.keymap.set("n", "]Y", function() require("aerial").next_up(vim.v.count1) end,
        { desc = "Next symbol upwards", buffer = bufnr })
      vim.keymap.set("n", "[Y", function() require("aerial").prev_up(vim.v.count1) end,
        { desc = "Previous symbol upwards", buffer = bufnr })
    end,
  },
}
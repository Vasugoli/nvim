return {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufEnter",
  main = "ibl",
  opts = {
    indent = {
      char = "┆",
      tab_char = "┆",
      highlight = "IblIndent",
    },
    scope = {
      enabled = true,
      char = "┃",
      show_start = true,
      show_end = true,
      show_exact_scope = true, -- IMPORTANT
      highlight = "IblScope",
    },
    exclude = {
      filetypes = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
      },
    },
  },
  config = function(_, opts)
    local hooks = require("ibl.hooks")

    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      -- Subtle indent lines
      vim.api.nvim_set_hl(0, "IblIndent", { fg = "#30363D" })

      -- Neon active scope
      vim.api.nvim_set_hl(0, "IblScope", {
        fg = "#39C5CF",
        bold = true,
      })
    end)

    require("ibl").setup(opts)
  end,
}
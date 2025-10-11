return {
  "arnamak/stay-centered.nvim",
  config = function()
    require("stay-centered").setup {
      centered_window_width = 120,
      autostart = true,
      filetypes = {
        "markdown",
        "text",
        "gitcommit",
        "lua",
        "python",
        "javascript",
        "typescript",
        "html",
        "css",
      },
      excluded_filetypes = {
        "TelescopePrompt",
        "Trouble",
        "dashboard",
      },
      disable_on_buftypes = { "terminal" },
      recenter_on_insert = false,
      recenter_on_switch = true,
      recenter_on_resize = true,
      recenter_on_hjkl = false,
      custom_centered_window_width = nil,
    }
  end,
}

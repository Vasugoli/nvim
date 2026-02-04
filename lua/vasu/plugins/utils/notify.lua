return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  config = function()
    local notify = require("notify")

    notify.setup({
      stages = "fade_in_slide_out",
      render = "compact",
      timeout = 2000,
      max_width = nil,
      max_height = nil,
      background_colour = "#000000",
      minimum_width = 50,
      icons = {
        ERROR = "",
        WARN  = "",
        INFO  = "",
        DEBUG = "",
        TRACE = "✎",
      },
    })

    vim.notify = require("notify")
  end,
}

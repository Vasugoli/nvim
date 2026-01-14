return {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufEnter",
  main = "ibl",
  config = function()
    require("ibl").setup({
      indent = { char = "│" },
      scope = { enabled = false },
    })
  end
}
local autopairs = {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" , "BufRead"},
  config = function()
    require("nvim-autopairs").setup({})
  end,
}
return autopairs

return {
  "github/copilot.vim",
  event = "InsertEnter",
  config = function()
    vim.g.copilot_filetypes = {
      cpp = false,   -- disable for C++
      c = false,     -- (optional) disable for C too
    }
  end,
}


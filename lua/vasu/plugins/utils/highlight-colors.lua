return {
  "brenoprata10/nvim-highlight-colors",
  event = { "BufReadPre", "BufNewFile" },
  cmd = "HighlightColors",
  keys = {
    { "<Leader>uz", function() vim.cmd.HighlightColors("Toggle") end, desc = "Toggle color highlight" }
  },
  opts = {
    enable_named_colors = false,
    virtual_symbol = "󱓻",
    exclude_buffer = function(bufnr)
      -- Check if buffer is valid and not too large
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return true
      end

      -- Check if buffer is too large (> 1MB)
      local size = vim.api.nvim_buf_get_offset(bufnr, vim.api.nvim_buf_line_count(bufnr))
      return size > 1024 * 1024
    end,
  },
}
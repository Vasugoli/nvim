return {
  "brenoprata10/nvim-highlight-colors",
  event = { "BufReadPost", "BufNewFile" }, -- load a bit later = faster startup
  cmd = { "HighlightColors" },
  keys = {
    { "<Leader>uz", "<cmd>HighlightColors Toggle<CR>", desc = "Toggle color highlight" }
  },
  opts = {
    enable_named_colors = false, -- faster, less noise
    enable_tailwind = true, -- if you use Tailwind (disable if not)
    render = "virtual", -- less intrusive, better UX
    virtual_symbol = "󱓻",

    ft = {
      "css",
      "scss",
      "html",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "lua",
      "vim",
      "yaml",
      "xml",
      "markdown",
      "svelte",
      "rust"
    },

    exclude_buffer = function(bufnr)
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return true
      end

      local name = vim.api.nvim_buf_get_name(bufnr)
      if name == "" then
        return true
      end

      local ok, stats = pcall(vim.loop.fs_stat, name)
      if ok and stats and stats.size > 1024 * 1024 then
        return true -- skip files > 1MB
      end

      return false
    end,
  },
}

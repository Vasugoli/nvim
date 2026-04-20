-- Show folded line count as virtual text: "󰁅  <N> lines"
local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (' 󰁂 %d'):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0

    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            table.insert(newVirtText, {chunkText, chunk[2]})
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- pad if truncate() returned fewer chars than requested
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix ..
                             (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end

    table.insert(newVirtText, {suffix, 'MoreMsg'})
    return newVirtText
end

require("ufo").setup({
    fold_virt_text_handler = handler,
    provider_selector = function(_, _, _) return {"treesitter", "indent"} end,
    open_fold_hl_timeout = 0, -- no highlight flash after opening
    close_fold_kinds_for_ft = {
        default = {} -- disable auto-closing for all filetypes
    }
})

vim.o.foldenable = true
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99

vim.keymap.set('n', 'zo', require('ufo').openAllFolds, {desc = "Open all folds"})
vim.keymap.set('n', 'zc', require('ufo').closeAllFolds, {desc = "Close all folds"})
vim.keymap.set('n', 'zio', function() vim.cmd("silent! foldopen") end, {desc = "Open current fold"})
vim.keymap.set('n', 'zic', function() vim.cmd("silent! foldclose") end, {desc = "Close current fold"})
vim.keymap.set('n', 'za', function()
    -- try to close; if fold is already open / doesn't exist, open instead
    local ok = pcall(vim.cmd, "foldclose")
    if not ok then pcall(vim.cmd, "foldopen") end
end, {desc = "Toggle current fold"})

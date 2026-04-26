-- Show folded line count as virtual text: " 󰁂 <N>"
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

require('ufo').setup({
    fold_virt_text_handler = handler,
    provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
    end
})



vim.keymap.set('n', 'zo', require('ufo').openAllFolds, {desc = "Open all folds"})
vim.keymap.set('n', 'zc', require('ufo').closeAllFolds, {desc = "Close all folds"})
vim.keymap.set('n', 'zio', function() vim.cmd("silent! foldopen") end, {desc = "Open current fold"})
vim.keymap.set('n', 'zic', function() vim.cmd("silent! foldclose") end, {desc = "Close current fold"})
vim.keymap.set('n', 'za', function()
    -- try to close; if fold is already open / doesn't exist, open instead
    local ok = pcall(vim.cmd, "foldclose")
    if not ok then pcall(vim.cmd, "foldopen") end
end, {desc = "Toggle current fold"})

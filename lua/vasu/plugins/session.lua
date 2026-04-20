-- rmagatti/auto-session — session management

-- Don't save/restore fold state — folds are computed fresh by nvim-ufo
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
-- Remove "folds" to prevent closed folds carrying over between sessions:
vim.o.sessionoptions = vim.o.sessionoptions:gsub(",folds", ""):gsub("folds,", ""):gsub("^folds$", "")

-- ── Keymaps (immediate — functions are lazy-loaded when called) ──────────────
vim.keymap.set("n", "<leader>wr", function()
    require("auto-session").search_session()
end, { desc = "Session search" })

vim.keymap.set("n", "<leader>ws", function()
    require("auto-session").SaveSession()
end, { desc = "Save session" })

vim.keymap.set("n", "<leader>wa", function()
    require("auto-session").toggle_auto_save()
end, { desc = "Toggle session autosave" })

-- ── Setup (deferred so vim.pack runtimepath is fully ready) ─────────────────
vim.schedule(function()
    local ok, session = pcall(require, "auto-session")
    if not ok then
        vim.notify("auto-session not installed — run :PackUpdate", vim.log.levels.WARN)
        return
    end

    session.setup({
        session_lens = {
            picker = "snacks", -- auto-detected; falls back to vim.ui.select
            mappings = {
                delete_session    = { "i", "<C-d>" },
                alternate_session = { "i", "<C-s>" },
                copy_session      = { "i", "<C-y>" },
            },
            picker_opts = {
                preset  = "dropdown",
                preview = false,
                layout  = { width = 0.4, height = 0.4 },
            },
            load_on_setup        = true,
            auto_restore_enabled = false,
        },
    })
end)

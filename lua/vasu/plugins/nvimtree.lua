-- nvim-tree/nvim-tree.lua — file explorer

local api = require("nvim-tree.api")

-- ── on_attach keymaps ────────────────────────────────────────────────────────
local function my_on_attach(bufnr)
    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true }
    end

    -- Open / Close (Neo-tree style)
    vim.keymap.set("n", "l",    api.node.open.edit,          opts("Open"))
    vim.keymap.set("n", "<CR>", api.node.open.edit,          opts("Open"))
    vim.keymap.set("n", "o",    api.node.open.edit,          opts("Open"))
    vim.keymap.set("n", "h",    api.node.navigate.parent_close, opts("Close Directory"))

    -- Search
    vim.keymap.set("n", "/",    api.live_filter.start, opts("Search"))
    vim.keymap.set("n", "<Esc>",api.live_filter.clear, opts("Clear Search"))

    -- File operations
    vim.keymap.set("n", "a", api.fs.create,    opts("Create"))
    vim.keymap.set("n", "d", api.fs.remove,    opts("Delete"))
    vim.keymap.set("n", "r", api.fs.rename,    opts("Rename"))
    vim.keymap.set("n", "x", api.fs.cut,       opts("Cut"))
    vim.keymap.set("n", "y", api.fs.copy.node, opts("Copy"))
    vim.keymap.set("n", "p", api.fs.paste,     opts("Paste"))

    -- Refresh & quit
    vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
    vim.keymap.set("n", "q", api.tree.close,  opts("Close Tree"))
end

-- ── Global toggle keymap ─────────────────────────────────────────────────────
vim.keymap.set("n", "<Leader>e", "<Cmd>NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })

-- ── Setup ────────────────────────────────────────────────────────────────────
local icons = {
    folder_closed = "󰉋",
    folder_open   = "󰝰",
    folder_empty  = "󰉖",
    default_file  = "󰈙",
    git = {
        unstaged  = "󰄱",
        staged    = "󰱒",
        unmerged  = "󰅖",
        renamed   = "󰁕",
        untracked = "󰎔",
        deleted   = "󰍵",
        ignored   = "󰿠",
    },
}

require("nvim-tree").setup({
    on_attach = my_on_attach,

    -- Performance
    disable_netrw       = true,
    hijack_netrw        = true,
    hijack_cursor       = false,
    sync_root_with_cwd  = false,
    respect_buf_cwd     = false,

    -- Expensive features disabled for speed
    update_focused_file  = { enable = false },
    filesystem_watchers  = { enable = false },
    diagnostics          = { enable = false },

    git = {
        enable       = true,
        ignore       = false,
        show_on_dirs = true,
        timeout      = 200,
    },

    view = {
        width          = 32,
        side           = "left",
        signcolumn     = "no",
        number         = false,
        relativenumber = false,
    },

    renderer = {
        highlight_git           = true,
        highlight_opened_files  = "none",
        indent_markers          = { enable = true },
        icons = {
            show   = { file = true, folder = true, git = true },
            glyphs = {
                default = icons.default_file,
                folder  = {
                    arrow_closed = "󰅂",
                    arrow_open   = "󰅀",
                    default      = icons.folder_closed,
                    open         = icons.folder_open,
                    empty        = icons.folder_empty,
                    empty_open   = icons.folder_empty,
                },
                git = icons.git,
            },
        },
    },

    actions  = { open_file = { quit_on_open = true } },
    filters  = { dotfiles = false, git_ignored = false },
})

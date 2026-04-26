-- nvim-treesitter/nvim-treesitter (main branch) — parser management + highlighting

local treesitter = require("nvim-treesitter")

-- ── Parser installation ───────────────────────────────────────────────────────
local ensure_installed = {
    "json", "javascript", "typescript", "tsx",
    "go", "yaml", "html", "css", "python", "http",
    "prisma", "markdown", "markdown_inline",
    "svelte", "graphql", "bash",
    "lua", "vim", "vimdoc", "query",
    "dockerfile", "gitignore",
    "c", "cpp", "java", "rust", "ron",
}

treesitter.install(ensure_installed)

-- ── Per-buffer highlighting + indentation via autocmd ────────────────────────
vim.api.nvim_create_autocmd("FileType", {
    pattern  = "*",
    callback = function(args)
        local buf = args.buf
        local ft  = vim.bo[buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)

        if not lang then return end

        -- load parser safely (parser may not be installed yet)
        local ok_add = pcall(vim.treesitter.language.add, lang)
        if not ok_add then return end

        -- start treesitter highlighting safely
        pcall(vim.treesitter.start, buf, lang)

        -- enable TS-based indentation for most filetypes
        -- skip yaml/markdown: their TS indent is notoriously buggy
        if ft ~= "yaml" and ft ~= "markdown" then
            vim.bo[buf].indentexpr  = "v:lua.require'nvim-treesitter'.indentexpr()"
            vim.bo[buf].smartindent = false
            vim.bo[buf].cindent     = false
        end
    end,
})

-- ── nvim-ts-autotag — auto-close & rename HTML/JSX/TSX tags ─────────────────
require("nvim-ts-autotag").setup({
    opts = {
        enable_close          = true,
        enable_rename         = true,
        enable_close_on_slash = false,
    },
    per_filetype = {
        ["html"]            = { enable_close = true },
        ["typescriptreact"] = { enable_close = true },
    },
})

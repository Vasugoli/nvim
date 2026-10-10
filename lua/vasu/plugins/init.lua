-- lua/vasu/plugins/init.lua
-- Core plugin configuration: UI, LSP, and utilities

-- ── UI ────────────────────────────────────────────────────────────────────────
require("vasu.plugins.ui.nvchad")
require("vasu.plugins.ui.heirline")
require("vasu.plugins.ui.neoscroll")
require("vasu.plugins.ui.smear-cursor")

-- ── Utilities & Editing Essentials ───────────────────────────────────────────
require("vasu.plugins.utils.treesitter")
require("vasu.plugins.utils.mini")
require("vasu.plugins.utils.snacks")
require("vasu.plugins.utils.fff")
require("vasu.plugins.utils.flash")
require("vasu.plugins.utils.git")
require("vasu.plugins.utils.origami")
require("vasu.plugins.utils.showkeys")
require("vasu.plugins.utils.trouble")
require("vasu.plugins.utils.yazi")

-- ── LSP Stack ─────────────────────────────────────────────────────────────────
require("vasu.plugins.lsp.completions")
require("vasu.plugins.lsp.formatting")
require("vasu.plugins.lsp.lspconfig")
require("vasu.plugins.lsp.mason")

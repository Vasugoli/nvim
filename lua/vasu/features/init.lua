-- lua/vasu/features/init.lua
-- Orchestrates feature initialization in order of dependency:
-- 1. UI          → essential UI, theme, statusline, effects
-- 2. Completion  → Blink.cmp + snippets (provides LSP capabilities)
-- 3. LSP Stack   → LSP servers, diagnostics, formatting, mason
-- 4. Editor      → Treesitter, Mini, Snacks, navigation, git, folds
-- 5. On-Demand   → AI, Markdown, DAP debugger

require("vasu.features.ui")
require("vasu.features.completion")
require("vasu.features.lsp")
require("vasu.features.editor")
require("vasu.features.ai")
require("vasu.features.markdown")
require("vasu.features.debug")

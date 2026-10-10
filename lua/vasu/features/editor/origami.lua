local origami = require("origami")

origami.setup {
	useLspFoldsWithTreesitterFallback = {
		enabled = true,
		foldmethodIfNeitherIsAvailable = "indent",
	},
	pauseFoldsOnSearch = true,
	foldtext = {
		enabled = true,
		padding = {
			character = " ",
			width = 2,
		},
		lineCount = {
			template = " 󰁂 %d", -- or "%d lines"
			hlgroup = "Comment",
		},
		diagnosticsCount = true, -- shows diagnostics inside fold
		gitsignsCount = true,    -- shows git changes inside fold (+3 ~1)
	},
	autoFold = {
		enabled = false, -- change to true if you want comments/imports auto-folded on open
		kinds = { "comment", "imports" },
	},
	foldKeymaps = {
		setup = false, -- overloads h, l, ^, $ for fold toggles
		closeOnlyOnFirstColumn = false,
	},
}

-- ─────────────────────────────────────────────────────────────────────────────
-- 📖 Fold Keymaps Cheat Sheet
-- ─────────────────────────────────────────────────────────────────────────────
--
--  Origami Smart Motions (Active via foldKeymaps.setup = true):
--    h   -> Fold block (when cursor is on/before 1st non-blank char)
--    l   -> Unfold block (when cursor is on a closed fold)
--    ^   -> Fold block recursively
--    $   -> Unfold block recursively
--
--  Current Fold Under Cursor:
--    za  -> Toggle fold
--    zc  -> Close fold
--    zo  -> Open fold
--    zA  -> Toggle fold recursively
--    zC  -> Close fold recursively
--    zO  -> Open fold recursively
--
--  Entire Buffer:
--    zM  -> Close all folds in file
--    zR  -> Open all folds in file
--    zm  -> Fold more (foldlevel - 1)
--    zr  -> Reduce folding (foldlevel + 1)
--
--  Fold Navigation:
--    [z  -> Jump to start of current fold
--    ]z  -> Jump to end of current fold
--    zj  -> Move down to next fold
--    zk  -> Move up to previous fold
-- ─────────────────────────────────────────────────────────────────────────────

local smear = require("smear_cursor")

smear.setup {
	-- Cursor trail animation settings
	stiffness = 0.6,               -- 0.6 = snappy, responsive tracking
	trailing_stiffness = 0.3,      -- 0.3 = smooth tail falloff
	distance_stop_animating = 0.1, -- stops animating quickly to save redraws
	hide_target_hack = false,
}

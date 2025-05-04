---
-- Sets up sidebar icons for custom unit statuses.
---

-- #textdomain wesnoth-Invasion_from_the_Unknown
local _ = wesnoth.textdomain "wesnoth-Invasion_from_the_Unknown"

local function register_taint_status_display(num, label)
	register_unit_status_display {
		id      = ("taint_%d"):format(num),
		icon    = ("misc/tainted-status-icon-%d.png"):format(num),
		tooltip = tostring( _ "%s: This unit is tainted by otherworldly corrosion."):format(tostring(label))
	}
end

register_taint_status_display(1, "taint I")

register_taint_status_display(2, "taint II")

register_taint_status_display(3, "taint III")

register_taint_status_display(4, "taint IV")

register_unit_status_display {
	id      = "dehydrated",
	icon    = "misc/dehydrated-status-icon.png",
	tooltip = _ "dehydrated: This unit is dehydrated.",
}


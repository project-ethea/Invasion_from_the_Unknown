---
-- Sets up sidebar icons for custom unit statuses.
---

-- #textdomain wesnoth-Invasion_from_the_Unknown
local _ = wesnoth.textdomain "wesnoth-Invasion_from_the_Unknown"

register_unit_status_display {
	id      = "dehydrated",
	icon    = "misc/dehydrated-status-icon.png",
	tooltip = _ "dehydrated: This unit is dehydrated.",
}

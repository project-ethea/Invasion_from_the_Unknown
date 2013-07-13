---
-- Sets up sidebar icons for custom unit statuses.
---

-- #textdomain wesnoth-Invasion_from_the_Unknown
local _ = wesnoth.textdomain "wesnoth-Invasion_from_the_Unknown"
local old_unit_status = wesnoth.theme_items.unit_status

function wesnoth.theme_items.unit_status()
	local u = wesnoth.get_displayed_unit()
	if not u then return {} end
	local s = old_unit_status()

	if u.status.dehydrated then
		table.insert(s, { "element", {
			image = "misc/dehydrated-status-icon.png",
			tooltip = _ "dehydrated: This unit is dehydrated."
		}})
	end

	return s
end

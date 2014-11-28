---
-- Checks for Wesnoth version compatibility
---

local function do_bug(msg, may_ignore)
	wesnoth.wml_actions.bug { message = msg, should_report = false, may_ignore = may_ignore }
end


local ver = wesnoth.game_config.version
local v = wesnoth.compare_versions

-- #textdomain wesnoth-Invasion_from_the_Unknown
local _ = wesnoth.textdomain "wesnoth-Invasion_from_the_Unknown"

if v(ver, '<', '1.11.17') then
	do_bug( _ "Invasion from the Unknown requires Wesnoth 1.11.17 or later.", false)
end

if v(ver, '>=', '1.13.0') then
	do_bug( _ "Invasion from the Unknown has not been tested with Wesnoth 1.13.x and there may be broken functionality. Please use version 1.12.0 or later.", false)
end

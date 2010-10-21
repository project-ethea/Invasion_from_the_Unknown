local helper = wesnoth.require "lua/helper.lua"

---
-- Installs mechanical "Door" units on *^Z\ and *^Z/ hexes
-- using the given owner side.
--
-- [setup_doors]
--     side=3
-- [/setup_doors]
---
function wesnoth.wml_actions.setup_doors(cfg)
	local locs = wesnoth.get_locations {
		terrain = "*^Z\\",
		{ "or", { terrain = "*^Z/" } },
	}

	for k, loc in ipairs(locs) do
		wesnoth.put_unit(loc[1], loc[2], {
			type = "Door",
			side = cfg.side,
			id = string.format("__door_X%dY%d", loc[1], loc[2]),
		})
	end
end

---
-- Sets up the standard recruits' costs across IftU scenarios. This
-- is really a campaign-specific function (might be reusable in UtBS).
--
-- [setup_recruitment_cost]
--     scenario_number=123
-- [/setup_recruitment_cost]
---
function wesnoth.wml_actions.setup_recruitment_cost(cfg)
	local sid = cfg.scenario_number

	if sid == 4 then
		wesnoth.wml_actions.disallow_recruit { side = 1, type = "Elvish Scout" }
		wesnoth.wml_actions.allow_recruit { side = 1, type = "Elvish Scout scenario4" }
	elseif sid < 19 and sid > 4 then
		local names = { "Elvish Hunter","Elvish Archer","Elvish Fighter","Elvish Shaman","Elvish Scout","Elvish Civilian" }
		local disallowed = "Elvish Civilian,Elvish Hunter,Elvish Archer,Elvish Shaman,Elvish Scout,Elvish Fighter,Elvish Scout scenario4"

		for i = 5, 18 do
			for k,s in ipairs(names) do
				disallowed = disallowed .. string.format(",%s scenario%d", s, i)
			end
		end

		wesnoth.wml_actions.disallow_recruit {
			side = 1,
			type = disallowed,
		}

		local allowed = ""

		for k,s in ipairs(names) do
			allowed = allowed .. string.format(",%s scenario%d", s, sid)
		end

		wesnoth.wml_actions.allow_recruit {
			side = 1,
			type = allowed,
		}
		
	end
end

---
-- Stores a list of unit ids matching a certain filter.
--
-- [store_unit_ids]
--     [filter]
--         ...
--     [/filter]
--     variable=ids_store
-- [/store_unit_ids]
---
function wesnoth.wml_actions.store_unit_ids(cfg)
	local filter = helper.get_child(cfg, "filter") or
		helper.wml_error "[store_unit_ids] missing required [filter] tag"
	local varid = cfg.variable or "units"
	local idx = 0
	if cfg.mode == "append" then
		idx = wesnoth.get_variable(var .. ".length")
	else
		wesnoth.set_variable(var)
	end

	for i, u in ipairs(wesnoth.get_units(filter)) do
		wesnoth.set_variable(string.format("%s[%d].id", varid, idx), u.id)
		idx = idx + 1
	end
end

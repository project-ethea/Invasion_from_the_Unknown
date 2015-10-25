---
-- Lua WML actions that are intended specifically for use in the Invasion from
-- the Unknown campaign.
---

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

--------
-- S4 --
--------

function wesnoth.wml_actions.deactivate_and_serialize_sides(cfg)
	local variable = cfg.variable or "sides"
	local array_index = 0

	wesnoth.set_variable(variable, {})

	for t, side_number in helper.get_sides(cfg) do
		-- wesnoth.message("WML", string.format("store side %u", side_number))
		local side_store = string.format("%s[%u]", variable, array_index)

		wesnoth.set_variable(side_store, {})

		wesnoth.wml_actions.store_side {
			variable = side_store, side = side_number
		}
		wesnoth.wml_actions.store_unit {
			kill = true,
			variable = side_store .. ".units", { "filter", { side = side_number } }
		}
		wesnoth.wml_actions.modify_side {
			controller = "null", income = -2, gold = 0, village_gold = 0,
			hidden = true, side = side_number
		}

		array_index = array_index + 1
	end
end

function wesnoth.wml_actions.unserialize_and_activate_sides(cfg)
	local variable = cfg.variable or helper.wml_error("[unserialize_and_activate_sides]: Missing variable!")

	local data_set = helper.get_variable_array(variable)

	for index, side_data in ipairs(data_set) do
		wesnoth.wml_actions.modify_side {
			side = side_data.side, gold = side_data.gold, village_gold = side_data.village_gold,
			income = side_data.income, controller = side_data.controller, hidden = side_data.hidden
		}

		local units = helper.get_variable_array(variable .. string.format("[%u].units", index - 1))

		for uindex, container in ipairs(units) do
			wesnoth.wml_actions.unstore_unit {
				variable = string.format("%s[%u].units[%u]", variable, index - 1, uindex - 1),
				find_vacant = true
			}
		end
	end
end

---------
-- S12 --
---------

function wesnoth.wml_actions.update_escape_objectives(cfg)
	local id = cfg.id or helper.wml_error("[update_escape_objectives]: Missing id")
	local completed = cfg.completed
	if completed == nil then completed = false end

	local objs = helper.get_variable_array("escape_objectives")

	for k, obj in ipairs(objs) do
		if id == obj.id then
			obj.active = true
			obj.completed = completed
			wesnoth.set_variable(("escape_objectives[%d]"):format(k - 1), obj)
			break
		end
	end

	wesnoth.fire_event("reset objectives")
end

----------
-- S21+ --
----------

function wesnoth.wml_actions.recall_all(cfg)
	local units = wesnoth.get_recall_units(cfg)

	for i, u in ipairs(units) do
		wesnoth.wml_actions.recall({ id = u.id })
	end
end

----------
-- S23B --
----------

function wesnoth.wml_actions.store_relative_location(cfg)
	local from_slf = helper.get_child(cfg, "from")
	local variable = cfg.variable or "location"
	local direction = cfg.direction or
		helper.wml_error "[store_relative_location] no direction specified!"
	local distance = math.max(1, (cfg.distance or 1))

	local p = wesnoth.get_locations(from_slf)[1] or
		helper.wml_error "[store_relative_location] missing or bad SLF!"

	local mapw, maph = wesnoth.get_map_size()

	for i = 1, distance do
		local q = wesnoth.get_locations({
			{ "filter_adjacent_location", {
				adjacent = "-" .. direction,
				x = p[1],
				y = p[2]
			} },
			-- Must exclude map borders since we want to use this information
			-- to place units.
			x = ("1-%d"):format(mapw),
			y = ("1-%d"):format(maph)
		})[1]

		-- Stop walking if we go off-map.
		if not q then
			break
		end

		p = q
	end

	wesnoth.set_variable(variable .. ".x", p[1])
	wesnoth.set_variable(variable .. ".y", p[2])
end

local function scroll(x, y)
	wesnoth.wml_actions.scroll { x = x, y = y }
end

function wesnoth.wml_actions.quake_heavy(cfg)
	local sound = cfg.sound

	if sound then
		wesnoth.play_sound(sound)
	end

	scroll( 20,   0)
	scroll(-40,   0)
	scroll( 20,  20)
	scroll(  0, -40)
	scroll(  0,  20)
end

-----------
-- S23Cx --
-----------

function wesnoth.wml_actions.quake_heavier(cfg)
	local sound = cfg.sound

	if sound then
		wesnoth.play_sound(sound)
	end

	scroll( 40,   0)
	scroll(-70,   0)
	scroll( 40,  40)
	scroll(  0, -80)
	scroll(  0,  40)
end

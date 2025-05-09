---
-- Lua WML actions that are intended specifically for use in the Invasion from
-- the Unknown campaign.
---

-- #textdomain wesnoth-Invasion_from_the_Unknown
local _ = wesnoth.textdomain "wesnoth-Invasion_from_the_Unknown"

local T = wml.tag

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
				disallowed = ("%s,%s scenario%d"):format(disallowed, s, i)
			end
		end

		wesnoth.wml_actions.disallow_recruit {
			side = 1,
			type = disallowed,
		}

		local allowed = ""

		for k,s in ipairs(names) do
			allowed = ("%s,%s scenario%d"):format(allowed, s, sid)
		end

		wesnoth.wml_actions.allow_recruit {
			side = 1,
			type = allowed,
		}

	end
end

local function is_loyal_upkeep(unit)
	return unit.upkeep == "loyal" or
		   unit.upkeep == "free" or
		   unit.canrecruit
end

function free_recruitment_hook(context)
	local unit = wesnoth.units.get(context.x1, context.y1) or
		wml.error("free_recruitment_hook(): Bad unit")

	if unit.side ~= 1 or is_loyal_upkeep(unit) then
		return
	end

	unit:add_modification("object", {
		duration = "scenario",
		T.effect {
			apply_to = "loyal"
		}
	})

	wprintf(W_INFO, "free_recruitment_hook(): Made loyal: '%s'", unit.id)
end

function wesnoth.wml_actions._free_recruitment()
	on_event("unit placed", free_recruitment_hook)
end

function wesnoth.wml_actions.light_up_rune(cfg)
	local locs = wesnoth.map.find(cfg)

	for i, loc in ipairs(locs) do
		local items = wesnoth.interface.get_items(loc.x, loc.y)

		wesnoth.interface.remove_item(loc.x, loc.y)
		for j, item in ipairs(items) do
			item.image = tostring(item.image):gsub(
				"scenery/rune(%d)%.png",
				"scenery/rune%1-glow.png")
			wesnoth.wml_actions.item(item)
		end

		wesnoth.current.map[loc] = wesnoth.map.replace_overlay("^Ii")
	end

	wesnoth.wml_actions.redraw {}
end

---
-- Plays incidental mood music.
--
-- Equivalent to mainline {INCIDENTAL_MUSIC}, except it doesn't play during
-- boss sequences.
---
function wesnoth.wml_actions.mood_music(cfg)
	local mus = cfg.name or
		wml.error("[mood_music] No track specified!")

	-- NOTE: Hardcoded for performance.
	if #wesnoth.units.find_on_map({
		id = "Goliath,Chaos Warlord,Mal Hekuba,Kalazar,Elyssa,Chaos Emperor,Argan,Tux"
	}) > 0 then
		return
	end

	wesnoth.wml_actions.music {
		name = mus,
		immediate = true,
		play_once = true
	}
end

---------
-- S18 --
---------

function wesnoth.wml_actions._18_setup_hive(cfg)
	local SPAWN_DISTANCE_NOMINAL = {
		EASY   = 12,
		NORMAL = 9,
		HARD   = 7
	}

	local function maybe_ignore_distance()
		return 0 == (mathx.random(100) % 3)
	end

	local max_distance = SPAWN_DISTANCE_NOMINAL[wesnoth.scenario.difficulty]
	local locs = wesnoth.map.find({ terrain = "*^Xp" }) or
		wml.error("[_iftu_setup_wesmere_hive] No locations!")
	local setup_locs = {}

	-- The API does not guarantee a specific sorting for locs, so we need to
	-- slowly check the distance from locations we've already selected for each
	-- candidate location to make sure to space spawns apart somewhat.

	for i, candidate in ipairs(locs) do
		local commit = true
		local ignore_distance = maybe_ignore_distance()
		if not ignore_distance then
			for j, sample in ipairs(setup_locs) do
				local dist = wesnoth.map.distance_between(candidate, sample)

				if dist < max_distance then
					wprintf(W_DBG, "ignore %s because within nominal range of %s and not ignoring distance right now", loc2str(candidate), loc2str(sample))
					commit = false
					break
				end
			end
		end
		if commit then
			local n = wml.variables["wesmere_hive.length"]
			table.insert(setup_locs, candidate)
			wml.variables[("wesmere_hive[%d]"):format(n)] = {
				x = candidate.x,
				y = candidate.y,
			}
		end
	end
end

-- Taint status effect functionality

local TAINT_LABEL = {
	male   = _ "tainted",
	female = _ "female^tainted",
	color  = "128, 64, 172",
}

local UNTAINT_LABEL = {
	male   = _ "untainted",
	female = _ "female^untainted",
	color  = "0, 255, 0",
}

local function taint_label(unit, untaint)
	local list = TAINT_LABEL
	if untaint then
		list = UNTAINT_LABEL
	end
	wesnoth.interface.float_label(
		unit.x,
		unit.y,
		list[unit.gender] or list["male"],
		list.color
	)
end

local function taint_level(unit)
	local level = 0
	if unit.status.taint_4 then
		level = 4
	elseif unit.status.taint_3 then
		level = 3
	elseif unit.status.taint_2 then
		level = 2
	elseif unit.status.taint_1 then
		level = 1
	end
	return level
end

local function taint_modifier_factory(level)
	local modifier = ("%d%%"):format(-level * 10)
	local image_func = ("BLEND(128, 64, 172, %.2f)"):format(level * 10.0 / 100.0)
	return {
		id = "wesmere_taint_mod",
		-- Safeguard just in case, but ideally these mods should be cleared by
		-- us and not Wesnoth since we don't let it manage statuses directly
		-- right now.
		duration = "scenario",
		T.effect {
			apply_to = "hitpoints",
			increase_total = modifier,
		},
		T.effect {
			apply_to = "attack",
			increase_damage = modifier,
		},
		T.effect {
			apply_to = "image_mod",
			add = image_func,
		}
	}
end

local function update_taint_mod_impl(unit, level)
	unit:remove_modifications({ id = "wesmere_taint_mod" }, "object")
	level = in_range(level, 0, 4)
	if level > 0 then
		unit:add_modification("object", taint_modifier_factory(level))
	end
end

local function apply_taint_impl(unit, taint_side)
	local level = taint_level(unit)

	--wprintf(W_DBG, "wanna apply taint %s (current %d)", unit.id, level)
	if level >= 4 then
		unit.side = taint_side
	elseif level == 3 then
		unit.status.taint_4 = true
		unit.status.taint_3 = nil
	elseif level == 2 then
		unit.status.taint_3 = true
		unit.status.taint_2 = nil
	elseif level == 1 then
		unit.status.taint_2 = true
		unit.status.taint_1 = nil
	else
		unit.status.taint_1 = true
	end

	update_taint_mod_impl(unit, level + 1)

	taint_label(unit)
end

local function remove_taint_impl(unit, full, silent)
	-- This code is a little more verbose than it needs to be so that other
	-- levels of taint always get cleared in case they end up stuck because of
	-- code being buggy or aborted early.
	local level = 0

	--wprintf(W_DBG, "wanna remove taint %s", unit.id)
	if full then
		unit.status.taint_4 = nil
		unit.status.taint_3 = nil
		unit.status.taint_2 = nil
		unit.status.taint_1 = nil
	elseif unit.status.taint_4 then
		unit.status.taint_4 = nil
		unit.status.taint_3 = true
		unit.status.taint_2 = nil
		unit.status.taint_1 = nil
		level = 3
	elseif unit.status.taint_3 then
		unit.status.taint_4 = nil
		unit.status.taint_3 = nil
		unit.status.taint_2 = true
		unit.status.taint_1 = nil
		level = 2
	elseif unit.status.taint_2 then
		unit.status.taint_4 = nil
		unit.status.taint_3 = nil
		unit.status.taint_2 = nil
		unit.status.taint_1 = true
		level = 1
	elseif unit.status.taint_1 then
		remove_taint_impl(unit, true, silent)
	end

	update_taint_mod_impl(unit, level)

	if not silent then
		taint_label(unit, true)
	end
end

function wesnoth.wml_actions._apply_taint(cfg)
	local units = wesnoth.units.find_on_map(cfg)
	local taint_side = cfg.taint_side or 2

	for i, unit in ipairs(units) do
		apply_taint_impl(unit, taint_side)
	end
end

function wesnoth.wml_actions._remove_taint(cfg)
	local full = cfg.full or false
	local silent = cfg.silent or false
	local units = wesnoth.units.find_on_map(cfg)

	for i, unit in ipairs(units) do
		remove_taint_impl(unit, full, silent)
	end
end

local TAINT_RANGE = 6

-- Public SUF function used in taint-utils.cfg

local function unit_loc_helper(id)
	local unit = wesnoth.units.get(id)
	return { unit.x, unit.y }
end

function wesmere_unit_within_hero_range(unit)
	local malin = unit_loc_helper("Mal Keshar")
	local elynia = unit_loc_helper("Elynia")
	local me = { unit.x, unit.y }
	--[[
	wprintf(W_DBG, "is %s close to malin or elynia?", unit.id)
	wprintf(W_DBG, "  dist to malin = %d", wesnoth.map.distance_between(me, malin))
	wprintf(W_DBG, "  dist to elynia = %d", wesnoth.map.distance_between(me, elynia))
	]]--
	return (
		wesnoth.map.distance_between(me, malin) <= TAINT_RANGE or
		wesnoth.map.distance_between(me, elynia) <= TAINT_RANGE
	)
end

function wesnoth.wml_actions._18_spawn_crawlers(cfg)
	local side = cfg.side or
		wml.error("no unit side specified")
	local parent_type = cfg.parent_type or
		wml.error("no parent unit type specified")
	local child_type = cfg.child_type or
		wml.error("no child unit type specified")
	local limit = math.max(1, cfg.count or 1)
	local max_distance = cfg.max_distance or 999999

	local player_locs = wesnoth.map.find({ T.filter { side = 1 }})

	local function unit_to_player_dist_helper(unit)
		local smallest = 999999
		for _, loc in ipairs(player_locs) do
			local here = { unit.x, unit.y }
			local player = { loc.x, loc.y }
			smallest = math.min(smallest, wesnoth.map.distance_between(here, player))
		end
		return smallest
	end

	local candidates = {}

	for i, u in ipairs(wesnoth.units.find_on_map({ side = side, type = parent_type })) do
		local d = unit_to_player_dist_helper(u)
		if d <= max_distance then
			table.insert(candidates, { d, u })
		end
	end

	if #candidates == 0 then
		wprintf(W_DBG, "[_18_spawn_crawlers] no parent unit locations available, did you kill everything?? >_<")
		return
	elseif #candidates > 1 then
		-- Make sure we start with units closer to the player
		table.sort(candidates, function(a, b) return a[1] < b[1] end)
	end

	local spawn_count = 0
	-- If we run out of parent units to select, we loop back over the list
	while spawn_count < limit do
		for i = 1, limit do
			if i > #candidates then
				break
			end
			wesnoth.wml_actions.unit {
				side = side,
				type = child_type,
				x = candidates[i][2].x,
				y = candidates[i][2].y,
				-- This is effectively a fake recruit action
				random_traits = true,
				generate_name = true,
				random_gender = true,
				-- Only supported by [unit], not .create()
				animate = true,
				moves = 0,
				attacks_left = 0,
			}
			spawn_count = spawn_count + 1
		end
	end
end

---------
-- S12 --
---------

function wesnoth.wml_actions.update_escape_objectives(cfg)
	local id = cfg.id or wml.error("[update_escape_objectives]: Missing id")
	local completed = cfg.completed
	if completed == nil then completed = false end

	local objs = wml.array_access.get("escape_objectives")

	for k, obj in ipairs(objs) do
		if id == obj.id then
			obj.active = true
			obj.completed = completed
			wml.variables[("escape_objectives[%d]"):format(k - 1)] = obj
			break
		end
	end

	wesnoth.game_events.fire("reset objectives")
end

----------
-- S21+ --
----------

function wesnoth.wml_actions.recall_all(cfg)
	local units = wesnoth.units.find_on_recall(cfg)

	for i, u in ipairs(units) do
		wesnoth.wml_actions.recall({ id = u.id })
	end
end

----------
-- S23B --
----------

function wesnoth.wml_actions.store_relative_location(cfg)
	local from_slf = wml.get_child(cfg, "from")
	local variable = cfg.variable or "location"
	local direction = cfg.direction or
		wml.error "[store_relative_location] no direction specified!"
	local distance = math.max(1, (cfg.distance or 1))

	local p = wesnoth.map.find(from_slf)[1] or
		wml.error "[store_relative_location] missing or bad SLF!"

	local mapw = wesnoth.current.map.playable_width
	local maph = wesnoth.current.map.playable_height

	for i = 1, distance do
		local q = wesnoth.map.find({
			{ "filter_adjacent_location", {
				adjacent = "-" .. direction,
				x = p.x,
				y = p.y
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

	wml.variables[variable .. ".x"] = p.x
	wml.variables[variable .. ".y"] = p.y
end

-------------------
-- GLOBAL EVENTS --
-------------------

on_event("post advance", function()
	local ecx = wesnoth.current.event_context
	local u = wesnoth.units.get(ecx.x1, ecx.y1) or
		wml.error("[hook_elvish_enchantress_adv_override] No unit at x1,y1 on post advance!")

	if u.side == 1 and u.type == "Elvish Enchantress" and not u.variables.nerfed_enchantress then
		u:add_modification("object", {
			wml.tag.effect {
				apply_to = "max_experience",
				increase = -30, -- Down to AMLA req for level 3 units
			},
			wml.tag.effect {
				apply_to = "remove_advancement",
				types = "Elvish Sylph"
			},
			wml.tag.effect {
				apply_to = "new_advancement",
				replace = false,
				-- AMLA_DEFAULT in mainline
				wml.tag.advancement {
					strict_amla = true,
					max_times = 100,
					id = "amla_default",
					description = wgettext("Max HP bonus +3, Max XP +20%", "wesnoth-help"),
					image = "icons/amla-default.png",
					wml.tag.effect {
						apply_to = "hitpoints",
						increase_total = 3,
						heal_full = true
					},
					wml.tag.effect {
						apply_to = "max_experience",
						increase = "20%"
					},
					wml.tag.effect {
						apply_to = "status",
						remove = "poisoned"
					},
					wml.tag.effect {
						apply_to = "status",
						remove = "slowed"
					}
				}
			}
		})

		-- Makes it impossible to readd the same [object] on subsequent level ups.
		u.variables.nerfed_enchantress = true

		wprintf(W_INFO, "Sylph advancement disabled for Enchantress '%s' at %d,%d", u.id, u.x, u.y)
	end
end)

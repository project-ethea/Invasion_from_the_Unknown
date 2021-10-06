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

---
-- Plays incidental mood music.
--
-- Equivalent to mainline {INCIDENTAL_MUSIC}, except it doesn't play during
-- boss sequences.
---
function wesnoth.wml_actions.mood_music(cfg)
	local mus = cfg.name or
		helper.wml_error("[mood_music] No track specified!")

	-- NOTE: Hardcoded for performance.
	if #wesnoth.get_units({
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
-- S12 --
---------

function wesnoth.wml_actions.update_escape_objectives(cfg)
	local id = cfg.id or helper.wml_error("[update_escape_objectives]: Missing id")
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

	wesnoth.fire_event("reset objectives")
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

	wml.variables[variable .. ".x"] = p[1]
	wml.variables[variable .. ".y"] = p[2]
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

-------------------
-- GLOBAL EVENTS --
-------------------

on_event("post advance", function()
	local ecx = wesnoth.current.event_context
	local u = wesnoth.get_unit(ecx.x1, ecx.y1) or
		helper.wml_error("[hook_elvish_enchantress_adv_override] No unit at x1,y1 on post advance!")

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

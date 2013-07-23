local helper = wesnoth.require "lua/helper.lua"

function safe_random(arg)
	wesnoth.fire("set_variable", {
		name = "temp_ats_lua_random",
		rand = arg,
	})

	local r = wesnoth.get_variable("temp_ats_lua_random")
	wesnoth.set_variable("temp_ats_lua_random")

	return r
end

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
-- Stores a list of unit ids matching a certain filter.
--
-- To store ids from recall lists, x and y must be either absent
-- or set to "recall" in the base filter (not subfilters!).
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
	local var = cfg.variable or "units"
	local idx = 0
	if cfg.mode == "append" then
		idx = wesnoth.get_variable(var .. ".length")
	else
		wesnoth.set_variable(var)
	end

	for i, u in ipairs(wesnoth.get_units(filter)) do
		wesnoth.set_variable(string.format("%s[%d].id", var, idx), u.id)
		idx = idx + 1
	end

	if (not filter.x or filter.x == "recall") and (not filter.y or filter.y == "recall") then
		for i, u in ipairs(wesnoth.get_recall_units(filter)) do
			wesnoth.set_variable(string.format("%s[%d].id", var, idx), u.id)
			idx = idx + 1
		end
	end
end

---
-- Removes the terrain overlay from every hex matching a given SLF.
--
-- [remove_terrain_overlays]
--     ... SLF ...
-- [/remove_terrain_overlays]
---
function wesnoth.wml_actions.remove_terrain_overlays(cfg)
	local locs = wesnoth.get_locations(cfg)

	for i, loc in ipairs(locs) do
		local locstr = wesnoth.get_terrain(loc[1], loc[2])
		wesnoth.set_terrain(loc[1], loc[2], string.gsub(locstr, "%^.*$", ""))
	end
end

---
-- Creates a unit that's initially hidden from view as if [hide_unit]
-- was used on it.
--
-- This is necessary since [unit] followed by [hide_unit] allows the unit
-- to be displayed for an instant.
--
-- The syntax is identical to [unit].
---

function wesnoth.wml_actions.hidden_unit(cfg)
	local u = wesnoth.create_unit(cfg)
	u.hidden = true
	wesnoth.put_unit(u)
end

---
-- Fades out the currently playing music and replaces
-- it with silence afterwards.
--
-- NOTE: A possible timing issue in the sound code causes
-- Wesnoth to emit some short (< 100 ms) noise at the end
-- of the sequence when replacing the music playlist. This
-- also normally occurs when quitting a scenario that uses
-- silence.ogg to return to the titlescreen. It's advised
-- to have some ambient noise playing at the same time
-- [fade_out_music] is used. Furthermore, it's not possible
-- to determine at this time whether music is enabled in
-- the first place, so the fade out delay will always occur
-- regardless of the user's preferences.
--
-- [fade_out_music]
--     duration= (optional int, defaults to 1000 ms)
-- [/fade_out_music]
---
function wesnoth.wml_actions.fade_out_music(cfg)
	local duration = cfg.duration

	if duration == nil then
		duration = 1000
	end

	local function set_music_volume(percentage)
		wesnoth.fire("volume", { music = percentage })
	end

	local delay_granularity = 10

	duration = math.max(delay_granularity, duration)
	local rem = duration % delay_granularity

	if rem ~= 0 then
		duration = duration - rem
	end

	local steps = duration / delay_granularity
	--wesnoth.message(string.format("%d steps", steps))

	for k = 1, steps do
		local v = helper.round(100 - (100*k / steps))
		--wesnoth.message(string.format("step %d, volume %d", k, v))
		set_music_volume(v)
		wesnoth.delay(delay_granularity)
	end

	wesnoth.set_music({
		name = "silence.ogg",
		immediate = true,
		append = false
	})

	set_music_volume(100)
end

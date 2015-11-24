---
-- Overrides for mainline Lua WML actions.
--
-- Workarounds for mainline WML action implementation bugs (either in Lua or
-- C++ actions) also belong here.
---

local function override_alert(msg)
	wesnoth.fire("wml_message", {
		logger = "info",
		message= "[IftU] overrides.lua: " .. msg
	})
end

---
-- Extend [remove_sound_source] to take a comma-separated list of sound
-- sources to remove.
---

local engine_rss = wesnoth.wml_actions.remove_sound_source

function wesnoth.wml_actions.remove_sound_source(cfg)
	local ids = cfg.id or helper.wml_error("[remove_sound_source]: No id list provided")
	for id in ids:gmatch("[^,]+") do
		engine_rss { id = id:match "^%s*(.-)%s*$" }
	end
end

---
-- Add an option to fall back to some other unit (e.g. Mal Keshar) whenever
-- nonsentient undead need to talk in events.
--
-- Because we don't need the entire feature-set in practice for this particular
-- use case, only the most basic SUF functionality is supported in this mode:
--
--     speaker=
--     id=
--     x,y=
--
-- Non-SUF tags like [option] or [text_input] are passed onto the engine
-- [message] implementation, although care should be taken to not make
-- certain assumptions about the final selected unit.
--
-- The fallback conditions are specified in a [fallback_if] tag, which contains
-- a full SUF which, if the unit matched by the [message] SUF matches, triggers
-- the fallback unit selection. [fallback_to] specifies the SUF for the
-- fallback unit.
--
-- Only the first unit matched by any of the SUFs is used.
--
-- If [fallback_to] does not match anything then we catch on fire and violently
-- explode on the player's face. The license says "no warranty", after all.
---

local engine_msg = wesnoth.wml_actions.message

function wesnoth.wml_actions.message(cfg)
	local fback_if_cfg = helper.get_child(cfg, "fallback_if")
	local fback_to_cfg = helper.get_child(cfg, "fallback_to")

	if not fback_if_cfg or not fback_to_cfg then
		engine_msg(cfg)
		return
	end

	if cfg.speaker == "narrator" then
		wprintf(W_WARN, "[message] has fallback information but speaker=narrator, fix this")
		engine_msg(cfg)
		return
	end

	wprintf(W_DBG, "[message] fallback check mode activated")

	cfg = helper.literal(cfg)

	local minisuf = {
		x = cfg.x,
		y = cfg.y,
		id = cfg.id
	}

	if cfg.speaker == "unit" then
		minisuf.x = wesnoth.current.event_context.x1
		minisuf.y = wesnoth.current.event_context.y1
	elseif cfg.speaker == "second_unit" then
		minisuf.x = wesnoth.current.event_context.x2
		minisuf.y = wesnoth.current.event_context.y2
	elseif cfg.speaker ~= nil then
		minisuf.speaker = cfg.speaker
	end

	local u = wesnoth.get_units(minisuf)[1]

	if not u then
		wprintf(W_ERR, "[message] root mini SUF in fallback check mode did not match anything, cannot show message (SUF too complex?)")
		return
	end

	if wesnoth.match_unit(u, fback_if_cfg) then
		wprintf(W_DBG, "[message] fallback triggered")
		u = wesnoth.get_units(fback_to_cfg)[1]

		if not u then
			wprintf(W_ERR, "[message] fallback SUF did not match anything, cannot show message")
			return
		end
	end

	-- We have a unit now, right?
	cfg.x, cfg.y = u.x, u.y
	cfg.id, cfg.speaker = nil, nil

	wprintf(W_DBG, "[message] engine call")

	engine_msg(cfg)
end

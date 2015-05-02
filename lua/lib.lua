---
-- Lua utilities library
---

---
-- Returns a pseudorandom value from a set.
--
-- This uses the same format and implementation as WML [set_variable], so that
-- the function is MP and replay-safe (unlike Lua's math.random).
---
function safe_random(arg)
	wesnoth.fire("set_variable", {
		name = "temp_iftu_lua_random",
		rand = arg,
	})

	local r = wesnoth.get_variable("temp_iftu_lua_random")
	wesnoth.set_variable("temp_iftu_lua_random")

	return r
end

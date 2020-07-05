local T = wml.tag

function wesnoth.wml_actions.intermission_prompt(cfg)
	local W = wesnoth.wml_actions

	-- #textdomain wesnoth-Invasion_from_the_Unknown
	local _ = wesnoth.textdomain "wesnoth-Invasion_from_the_Unknown"
	local L = wesnoth.textdomain "wesnoth-lib"

	local ep_count = 0

	local function e(text1, text2, selected)
		ep_count = ep_count + 1

		local disabled = ep_count > 3

		local lfmt = "%s"
		if disabled then
			lfmt = "<span color='#666'>" .. lfmt .. "</span>"
		end
		if selected then
			lfmt = "<b>" .. lfmt .. "</b>"
		end

		return T.row {
			grow_factor = 1,
			T.column {
				border = "all",
				border_size = 5,
				T.label {
					id = ("a%d"):format(ep_count),
					label = (selected and "<b>&#8594;</b>" or "") -- U+2192 RIGHTWARDS ARROW
				}
			},
			T.column {
				border = "all",
				border_size = 5,
				horizontal_grow = true,
				grow_factor = 1,
				T.label {
					id = ("e%d"):format(ep_count),
					label = lfmt:format(text2)
				}
			},
			T.column { T.spacer { width = 20 } },
			T.column {
				border = "all",
				border_size = 5,
				horizontal_alignment = "right",
				T.label {
					id = ("r%d"):format(ep_count),
					label = lfmt:format(text1)
				}
			}
		}
	end

	local function r(a, b, c)
		return ("%s %s&#8211;%s"):format(a, b, c) -- U+2013 EN DASH
	end

	local f = "%s\n%s"

	local list_grid = {
		e(r( _ "IftU", "S1", "S13"), f:format( _ "Invasion from the Unknown", _ "Episode I: Seeking the Light")),
		e("", _ "Intermission", true),
		e(r( _ "IftU", "S14", "S24"), f:format( _ "Invasion from the Unknown", _ "Episode II: Armageddon")),
		e(r( _ "AtS", "E1S1", "E1S13"), f:format( _ "After the Storm", _ "Episode I: Fear")),
		e(r( _ "AtS", "E2S0", "E2S12"), f:format( _ "After the Storm", _ "Episode II: Fate")),
		e(r( _ "AtS", "E3S0", "E3S12"), f:format( _ "After the Storm", _ "Final")),
		e("", _ "Epilogue")
	}

	local dd = {
		definition = "borderless",

		automatic_placement = false,
		x = 0,
		y = 0,
		width = "(screen_width)",
		height = "(screen_height)",

		T.helptip { id="tooltip_large" },
		T.tooltip { id="tooltip_large" },

		T.grid {
			T.row {
				T.column {
					border = "all",
					border_size = 10, -- src/storyscreen/render.cpp
					vertical_alignment = "top",
					horizontal_alignment = "left",
					T.label {
						id = "caption",
						definition = "default",
						label = ("<span color='#fff' font='20'>%s\n<span size='xx-small'>%s</span></span>"):
								format( _ "Invasion from the Unknown", _ "Intermission" )
					}
				}
			},
			T.row {
				T.column {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					T.grid(list_grid)
				}
			},
			T.row {
				T.column {
					border = "right",
					border_size = 15, -- src/storyscreen/render.cpp, part_ui::prepare_geometry()
					vertical_alignment = "bottom",
					horizontal_alignment = "right",

					T.grid {
						T.row {
							T.column {
								horizontal_grow = true,
								border = "all",
								border_size = 5,
								T.button {
									id = "ok",
									label = ("%s"):format( _ "Continue Playing")
								}
							}
						},
						T.row {
							T.column {
								horizontal_grow = true,
								border = "all",
								border_size = 5,
								T.button {
									id = "cancel",
									label = _ "Quit Game"
								}
							}
						}
					}
				}
			}
		}
	}

	-- why are you reading this go away

	local function preshow()
		wesnoth.set_dialog_canvas(1, {
			T.rectangle {
				x = 0,
				y = 0,
				w = "(width)",
				h = "(height)",
				fill_color = "0,0,0,255"
			}
		})

		wesnoth.set_dialog_markup(true, "caption")

		while ep_count > 0 do
			wesnoth.set_dialog_markup(true, ("a%d"):format(ep_count))
			wesnoth.set_dialog_markup(true, ("e%d"):format(ep_count))
			wesnoth.set_dialog_markup(true, ("r%d"):format(ep_count))
			ep_count = ep_count - 1
		end
	end

	W.endlevel(
		1 == math.abs(wesnoth.show_dialog(dd, preshow)) and {
			result = "victory",
			bonus = false,
			linger_mode = false,
			save = true,
			replay_save = false,
			carryover_percentage = 100,
			carryover_report = false,
		} or {
			result = "victory",
			next_scenario = "null",
			linger_mode = false,
			replay_save = false,
			carryover_report = false,
		}
	)
end

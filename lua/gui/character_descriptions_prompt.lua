--#textdomain wesnoth-Invasion_from_the_Unknown

local T = helper.set_wml_tag_metatable {}

function wesnoth.wml_actions.character_descriptions_prompt(cfg)
	local _ = wesnoth.textdomain "wesnoth-Invasion_from_the_Unknown"

	local main_window = {
		maximum_height = 400,
		maximum_width = 500,
		T.helptip { id="tooltip_large" }, -- mandatory field
		T.tooltip { id="tooltip_large" }, -- mandatory field

		T.grid {
			T.row {
				T.column {
					horizontal_alignment = "left",
					grow_factor = 1,
					border = "all",
					border_size = 5,
					T.label {
						definition = "title",
						label = _ "Character Descriptions"
					}
				}
			},
			T.row {
				T.column {
					horizontal_alignment = "left",
					border = "all",
					border_size = 5,
					T.scroll_label {
						label = _ "Do you wish to see brief descriptions of the characters when you select them on the map for the first time?"
					}
				}
			},
			T.row {
				T.column {
					T.spacer { height = 10 }
				}
			},
			T.row {
				grow_factor = 1,
				T.column {
					horizontal_alignment = "right",
					T.grid {
						T.row {
							T.column {
								border = "all",
								border_size = 5,
								horizontal_alignment = "right",
								T.button {
									id = "yes_button",
									return_value = 1,
									label = wgettext("Yes", "wesnoth-lib")
								}
							},
							T.column {
								border = "all",
								border_size = 5,
								horizontal_alignment = "right",
								T.button {
									id = "no_button",
									return_value = 2,
									label = wgettext("No", "wesnoth-lib")
								}
							}
						}
					}
				}
			}
		}
	}

	-- 1 on Yes, -1 on [Enter], 2 on No, -2 on [Escape].
	local result = math.abs(wesnoth.show_dialog(main_window))

	wesnoth.set_variable("character_1st_time_help", (result == 1))
end

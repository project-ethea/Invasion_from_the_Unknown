--#textdomain wesnoth-Invasion_from_the_Unknown
_ = wesnoth.textdomain "wesnoth-Invasion_from_the_Unknown"

helper = wesnoth.require "lua/helper.lua"
T = helper.set_wml_tag_metatable {}

function wesnoth.wml_actions.character_descriptions_prompt(cfg)
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
						label = _"Character Descriptions"
					}
				}
			},
			T.row {
				T.column {
					horizontal_alignment = "left",
					border = "all",
					border_size = 5,
					T.scroll_label {
						label = _"Do you wish to see brief descriptions of the characters when you select them on the map for the first time?"
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
					border = "all",
					border_size = 5,
					T.grid {
						T.row {
							T.column {
								horizontal_alignment = "right",
								T.button {
									id = "yes_button",
									return_value = 1,
									label = _"Yes"
								}
							},
							T.column {
								T.spacer { width = 10 }
							},
							T.column {
								horizontal_alignment = "right",
								T.button {
									id = "no_button",
									return_value = 2,
									label = _"No"
								}
							}
						}
					}
				}
			}
		}
	}

	local function set_var(var)
		wesnoth.set_variable("character_1st_time_help", var)
	end

	local function preshow()
		wesnoth.set_dialog_callback(function() set_var("true") end, "yes_button")
		wesnoth.set_dialog_callback(function() set_var("false") end, "no_button")
	end

	wesnoth.show_dialog(main_window, preshow, nil)				
end

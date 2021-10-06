--
-- Dialog for the campaign sequel teaser
--

local T = wml.tag

-- #textdomain wesnoth-Invasion_from_the_Unknown
local _ = wesnoth.textdomain "wesnoth-Invasion_from_the_Unknown"

local center_grid = {
	T.row {
		T.column {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			border = "top,bottom",
			border_size = 5,
			T.label {
				id = "text",
				text_alignment = "center",
				wrap = true,
			}
		}
	},
	T.row {
		grow_factor= 1,
		T.column {
			--vertical_alignment = "center",
			horizontal_alignment = "center",
			vertical_grow = true,
			border = "top,bottom",
			border_size = 50,
			T.label {
				id = "big_text",
				definition = "iftu_teaser_outro",
				--wrap = true,
			}
		}
	},
	T.row {
		T.column {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			border = "top,bottom",
			border_size = 5,
			T.button {
				id = "ok",
				definition = "iftu_beeg_button",
				label = _ "End Campaign",
			}
		}
	}
}

local teaser_dlg = {
	definition = "borderless",

	automatic_placement = false,
	x = 0, y = 0, width = "(screen_width)", height = "(screen_height)",

	T.helptip { id = "tooltip" },
	T.tooltip { id = "tooltip" },

	T.grid {
		T.row {
			T.column {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				T.grid(center_grid),
			}
		}
	}
}

local outro_text_attrs = {
	size = 64,
	family = "script",
	style = "",
}

local outro_text_canvas = {
	T.text {
		x = 0,
		y = 0,

		w = "(width)",
		h = "(text_height)",

		maximum_width = "(width)",
		-- NOTE:
		-- I don't know why these values specified in the widget def itself
		-- need to be repeated in the canvas elements, but whatevs. -- iris
		font_family = outro_text_attrs.family,
		font_size = outro_text_attrs.size,
		font_style = outro_text_attrs.style,
		color = "([215, 215, 215, 255])",
		text = "(text)",
		text_markup = "(text_markup)",
		text_alignment = "center",
	}
}

gui.add_widget_definition("label", "iftu_teaser_outro", {
	id = "iftu_teaser_outro",
	description = "gui2 sucks",

	T.resolution {
		min_width = 0,
		min_height = 0,

		default_width = 0,
		default_height = 0,

		max_width = 0,
		max_height = 0,

		text_font_family = outro_text_attrs.family,
		text_font_size = outro_text_attrs.size,
		text_font_style = outro_text_attrs.style,

		link_aware = false,

		T.state_enabled { T.draw(outro_text_canvas) },

		T.state_disabled { T.draw(outro_text_canvas) },
	}
})

-- FIXME: too much hardcoded stuff from data/gui/ below!

local beeg_button_size = {
	w = 168,
	h = 44,
	-- _GUI_BUTTON_FONT_SIZE @ data/gui/widget/button_default.cfg
	font_size = 16,
}

local function beeg_button_canvas_factory(state_name)
	-- GUI__FONT_COLOR_ENABLED__TITLE @ data/gui/macros/_initial.cfg
	local color = "186, 172, 125, 255"
	if state_name == "disabled" then
		-- GUI__FONT_COLOR_DISABLED__TITLE @ data/gui/macros/_initial.cfg
		color = "128, 128, 128, 255"
	end

	local path = "buttons/large-button.png"
	if state_name then
		if state_name ~= "disabled" then
			path = "buttons/large-button-" .. state_name .. ".png"
		else
			path = path .. "~GS()"
		end
	end

	return T.draw {
		-- _GUI_STATE @ data/gui/widget/button_default.cfg
		T.image {
			x = 0,
			y = 0,
			w = "(width)",
			h = "(height)",
			name = path,
		},

		-- GUI__CENTERED_TEXT @ data/gui/macros/_initial.cfg
		T.text {
			x = "(max((width - text_width) / 2, 0))",
			y = "(max((height - text_height - 2) / 2, 0))",
			w = "(text_width)",
			h = "(text_height)",
			font_size = beeg_button_size.font_size,
			font_style = "",
			color = color,
			text = "(text)",
			text_markup = "(text_markup)",
		},
	}
end

gui.add_widget_definition("button", "iftu_beeg_button", {
	id = "iftu_beeg_button",
	description = "gui2 still sucks",

	T.resolution {
		min_width = beeg_button_size.w,
		min_height = beeg_button_size.h,

		default_width = beeg_button_size.w,
		default_height = beeg_button_size.h,

		max_width = beeg_button_size.w,
		max_height = beeg_button_size.h,

		T.state_enabled { beeg_button_canvas_factory() },

		T.state_disabled { beeg_button_canvas_factory("disabled") },

		T.state_pressed { beeg_button_canvas_factory("pressed") },

		T.state_focused { beeg_button_canvas_factory("active") },
	}
})

function wesnoth.wml_actions.outro_teaser()
	wesnoth.show_dialog(teaser_dlg, function()
		wesnoth.set_dialog_canvas(1, {
			T.rectangle {
				x = 0,
				y = 0,
				w = "(width)",
				h = "(height)",
				fill_color = "0, 0, 0, 255"
			}
		})

		local text = ("<span font='24'>%s</span>"):format(
			_("And thus, the group embarked upon a new quest.\n\nA quest not for blood, but for knowledge.")
		)

		local big_text = ("%s\n<span font='120'>%s</span>"):format(
			_("Continued in..."), _("After the Storm")
		)

		wesnoth.set_dialog_markup(true,    "text")
		wesnoth.set_dialog_value(text,     "text")
		wesnoth.set_dialog_markup(true,    "big_text")
		wesnoth.set_dialog_value(big_text, "big_text")
	end)
end

-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration
local config = wezterm.config_builder()

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 16

config.hide_tab_bar_if_only_one_tab = true

config.window_decorations = "RESIZE"

config.window_close_confirmation = "NeverPrompt"

config.initial_cols = 200
config.initial_rows = 50

config.max_fps = 120
config.prefer_egl = true

config.colors = {
	background = "#011423",
	foreground = "#CBE0F0",
	cursor_border = "#47FF9C",
	cursor_bg = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#A277FF", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#A277FF", "#24EAF7", "#24EAF7" },
}

config.keys = {
	{
		key = "Backspace",
		mods = "CMD",
		action = wezterm.action.SendKey({ key = "u", mods = "CTRL" }),
	},
	{
		key = "LeftArrow",
		mods = "CMD",
		action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
	},
	{
		key = "RightArrow",
		mods = "CMD",
		action = wezterm.action.SendKey({ key = "e", mods = "CTRL" }),
	},
	{
		key = "LeftArrow",
		mods = "OPT",
		action = wezterm.action.SendKey({ key = "b", mods = "ALT" }),
	},
	{
		key = "RightArrow",
		mods = "OPT",
		action = wezterm.action.SendKey({ key = "f", mods = "ALT" }),
	},
}

config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = "Middle" } },
		action = "Nop",
		mods = "NONE",
	},
}

config.window_background_opacity = 0.85
config.macos_window_background_blur = 30

return config

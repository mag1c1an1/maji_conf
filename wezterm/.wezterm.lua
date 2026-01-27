-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.default_cursor_style = "BlinkingUnderline"
config.font = wezterm.font 'Hack Nerd Font'
config.font_size = 20
config.color_scheme = 'Mariana'
config.use_fancy_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE" -- disable title

config.initial_cols = 80
config.initial_rows = 120

config.window_padding = {
  left = 5,
  right = 5,
  top = 5,
  bottom = 2,
}

-- Finally, return the configuration to wezterm:
return config

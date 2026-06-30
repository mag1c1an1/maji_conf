-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.default_cursor_style = "BlinkingBar"
-- font
config.font = wezterm.font 'Hack Nerd Font'
config.font_size = 20
-- tab
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.window_decorations = "RESIZE" -- disable title
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
-- window size
config.initial_cols = 80
config.initial_rows = 100
config.window_padding = {
  left = 5,
  right = 5,
  top = 5,
  bottom = 2,
}

config.color_scheme = 'Everforest Dark Hard (Gogh)'

-- local theme = wezterm.plugin.require('https://github.com/neapsix/wezterm').dawn
-- config.colors = theme.colors()
--
-- config.color_scheme = 'Tokyo Night Storm'
-- render
config.animation_fps = 60
config.max_fps = 60

local act = wezterm.action

config.keys = {
  { key = '{', mods = 'SHIFT|ALT', action = act.MoveTabRelative(-1) },
  { key = '}', mods = 'SHIFT|ALT', action = act.MoveTabRelative(1) },
}



-- Finally, return the configuration to wezterm:
return config

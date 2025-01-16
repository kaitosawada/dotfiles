-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- tabを表示しない
config.hide_tab_bar_if_only_one_tab = true

-- colors
local border_color = "#7E56C2"
config.color_scheme = "duskfox"
config.colors = {
  split = border_color,
  tab_bar = {
    -- The color of the strip that goes along the top of the window
    -- (does not apply when fancy tab bar is in use)
    background = border_color,
  },
}
config.font_size = 16.0
config.font = wezterm.font_with_fallback {
  "Mononoki Nerd Font",
  "ヒラギノ丸ゴ ProN",
}
config.window_background_opacity = 0.5
config.macos_window_background_blur = 1
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true
config.window_decorations = "RESIZE"
config.window_frame = {
  border_left_width = "0.6cell",
  border_right_width = "0.6cell",
  border_bottom_height = "0.3cell",
  border_top_height = "0.3cell",
  border_left_color = border_color,
  border_right_color = border_color,
  border_bottom_color = border_color,
  border_top_color = border_color,
  active_titlebar_bg = border_color,
  inactive_titlebar_bg = border_color,
}
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- config.use_fancy_tab_bar = false

config.inactive_pane_hsb = {
  saturation = 0.4,
  brightness = 0.8,
}
config.keys = {
  {
    key = "t",
    mods = "CMD",
    action = wezterm.action { SpawnCommandInNewTab = {
      cwd = os.getenv("HOME"),
    } }
  },
  {
    key = "t",
    mods = "CMD|SHIFT",
    action = wezterm.action { SpawnCommandInNewTab = {} }
  },
}

-- default program
config.default_prog = { "/bin/zsh", "-l", "-c", "env PATH=$HOME/.nix-profile/bin:$PATH nvim -c \"startinsert\" $(mktemp).md" }

-- and finally, return the configuration to wezterm
return config

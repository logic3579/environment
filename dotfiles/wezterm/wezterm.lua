-- ~/.config/wezterm/wezterm.lua
local wezterm = require 'wezterm'
local config = {}

-- Colors & Appearance
config.colors = {
    scrollbar_thumb = '#cccccc',
}
--config.color_scheme = 'Solarized Dark'
config.color_scheme = 'IC_Green_PPL'
config.window_frame = {
    font = wezterm.font 'MesloLGLDZ Nerd Font',
}

-- Lauching Programs
config.default_prog = { 'bash', '--login' }
config.default_cwd = '~'
--config.set_environment_variables = {
--  prompt = '',
--}
config.launch_menu = {
    { label = 'MINGW64 / MSYS2', args = { '/d/software/Git/bin/bash', '--login' }, },
}

-- Fonts
config.font = wezterm.font 'MesloLGLDZ Nerd Font'
config.font_size = 17.0

-- Key / Mouse Binding
config.disable_default_key_bindings = true
config.leader = { key = 'Space', mods = 'CTRL|SHIFT', timeout_milliseconds = 3000 }
config.keys = {
    { key = 'F11',    mods = 'NONE',         action = wezterm.action.ToggleFullScreen },
    { key = 'c',      mods = 'CTRL|SHIFT',   action = wezterm.action.CopyTo('Clipboard') },
    { key = 'Insert', mods = 'SHIFT',        action = wezterm.action.PasteFrom('Clipboard') },
    -- tab manage
    { key = 'n',      mods = 'CTRL|SHIFT',   action = wezterm.action.SpawnWindow },
    { key = 't',      mods = 'CTRL|SHIFT',   action = wezterm.action.SpawnTab('CurrentPaneDomain') },
    { key = 'w',      mods = 'CTRL|SHIFT',   action = wezterm.action.CloseCurrentTab { confirm = false } },
    { key = '1',      mods = 'META',         action = wezterm.action { ActivateTab = 0 } },
    { key = '2',      mods = 'META',         action = wezterm.action { ActivateTab = 1 } },
    { key = '3',      mods = 'META',         action = wezterm.action { ActivateTab = 2 } },
    ---
    { key = 's',      mods = 'LEADER|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'v',      mods = 'LEADER|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'a',      mods = 'LEADER|CTRL',  action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' } },
}
--config.disable_default_mouse_bindings = true
config.mouse_bindings = {
    { event = { Up = { streak = 1, button = 'Left' } },    mods = 'NONE', action = wezterm.action.CopyTo('Clipboard') },
    { event = { Down = { streak = 1, button = 'Right' } }, mods = 'NONE', action = wezterm.action.PasteFrom('Clipboard') },
}

-- Window
config.initial_cols = 97
config.initial_rows = 23
config.window_background_opacity = 0.95
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.window_padding = { left = 0, right = 15, top = 0, bottom = 0 }
config.enable_scroll_bar = true


return config

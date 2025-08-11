local wezterm = require 'wezterm'
local config = {}

-- Operation system
local is_windows = wezterm.target_triple:find('windows') ~= nil
local is_linux = wezterm.target_triple:find('linux') ~= nil
local is_mac = wezterm.target_triple:find('darwin') ~= nil

-- Colors & Appearance
config.colors = {
    scrollbar_thumb = '#cccccc',
}
config.color_scheme = 'Solarized Dark - Patched'
-- config.color_scheme = 'IC_Green_PPL'
config.window_frame = {
    font = wezterm.font 'MesloLGLDZ Nerd Font',
}

-- Lauching Programs
config.default_cwd = '~'
if is_windows then
    config.default_prog = { '/d/Software/Git/bin/bash', '--login' }
    config.launch_menu = {
        { label = 'Bash', args = { '/d/Software/Git/bin/bash', '--login' } },
    }
else
    config.default_prog = { 'zsh', '--login' }
    config.launch_menu = {
        { label = 'Bash', args = { 'bash', '--login' } },
        { label = 'Fish', args = { 'fish' } },
        { label = 'Zsh',  args = { 'zsh', '--login' } },
    }
end
--config.set_environment_variables = {
--  prompt = '',
--}

-- Fonts
config.font = wezterm.font {
    family = 'MesloLGLDZ Nerd Font',
    weight = 'Regular'
}
config.font_size = 17.0

-- Key / Mouse Binding
config.disable_default_key_bindings = true
-- config.leader = { key = 'Space', mods = 'CTRL|SHIFT', timeout_milliseconds = 3000 }
local act = wezterm.action
config.keys = {
    -- global
    { key = 'o',          mods = 'CTRL|SHIFT', action = act.ShowLauncher },
    { key = 'Enter',      mods = 'SUPER',      action = act.ToggleFullScreen },
    { key = 'c',          mods = 'SUPER',      action = act.CopyTo('Clipboard') },
    { key = 'v',          mods = 'SUPER',      action = act.PasteFrom('Clipboard') },
    { key = 'Insert',     mods = 'SHIFT',      action = act.PasteFrom('Clipboard') },
    -- tab manage
    { key = 'n',          mods = 'SUPER',      action = act.SpawnWindow },
    { key = 't',          mods = 'SUPER',      action = act.SpawnTab('CurrentPaneDomain') },
    { key = 'w',          mods = 'SUPER',      action = act.CloseCurrentTab { confirm = false } },
    { key = '1',          mods = 'SUPER',      action = act.ActivateTab(0) },
    { key = '2',          mods = 'SUPER',      action = act.ActivateTab(1) },
    { key = '3',          mods = 'SUPER',      action = act.ActivateTab(2) },
    -- --- panel
    -- { key = 's',      mods = 'LEADER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    -- { key = 'v',      mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = "LeftArrow",  mods = "ALT",        action = act.SendString "\x1bb" },
    { key = "RightArrow", mods = "ALT",        action = act.SendString "\x1bf" },
    { key = 'z',          mods = 'CTRL',       action = act.SendKey { key = 'z', mods = 'CTRL' } },
}
--config.disable_default_mouse_bindings = true
config.mouse_bindings = {
    { event = { Up = { streak = 1, button = 'Left' } },    mods = 'NONE', action = act.CopyTo('Clipboard') },
    { event = { Down = { streak = 1, button = 'Right' } }, mods = 'NONE', action = act.PasteFrom('Clipboard') },
}

-- Window
config.initial_cols = 97
config.initial_rows = 23
config.window_background_opacity = 0.95
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.window_padding = { left = 0, right = 15, top = 0, bottom = 0 }
config.enable_scroll_bar = true

config.automatically_reload_config = true
return config

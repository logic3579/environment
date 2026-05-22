local wezterm = require 'wezterm'
local config = {}

-- Operation system
local is_windows = wezterm.target_triple:find('windows') ~= nil

-- Colors & Appearance
config.color_scheme = 'Solarized Dark - Patched'
config.window_frame = {
    font = wezterm.font 'MesloLGMDZ Nerd Font Mono',
}

-- Launching Programs
config.default_cwd = '~'
if is_windows then
    config.default_prog = { 'D:\\Software\\Git\\bin\\bash', '--login' }
    config.launch_menu = {
        { label = 'Bash', args = { 'D:\\Software\\Git\\bin\\bash', '--login' } },
    }
else
    config.default_prog = { 'zsh', '--login' }
    config.launch_menu = {
        { label = 'Bash', args = { 'bash', '--login' } },
        { label = 'Fish', args = { 'fish' } },
        { label = 'Zsh',  args = { 'zsh', '--login' } },
    }
end

-- Fonts
config.font = wezterm.font_with_fallback {
    'MesloLGMDZ Nerd Font Mono',
    'PingFang SC',
    'Apple Color Emoji',
}
config.font_size = 17.0

-- Key / Mouse Binding
local act = wezterm.action
config.keys = {
    -- global
    { key = 'o',          mods = 'CTRL|SHIFT',  action = act.ShowLauncher },
    { key = 'Enter',      mods = 'SUPER',       action = act.ToggleFullScreen },
    { key = 'c',          mods = 'SUPER',       action = act.CopyTo('Clipboard') },
    { key = 'v',          mods = 'SUPER',       action = act.PasteFrom('Clipboard') },
    { key = 'Insert',     mods = 'SHIFT',       action = act.PasteFrom('Clipboard') },
    -- tab manage
    { key = 'n',          mods = 'SUPER',       action = act.SpawnWindow },
    { key = 't',          mods = 'SUPER',       action = act.SpawnTab('CurrentPaneDomain') },
    { key = 'w',          mods = 'SUPER',       action = act.CloseCurrentTab { confirm = false } },
    { key = 'Tab',        mods = 'CTRL',        action = act.ActivateTabRelative(1) },
    { key = 'Tab',        mods = 'CTRL|SHIFT',  action = act.ActivateTabRelative(-1) },
    { key = '[',          mods = 'SUPER|SHIFT', action = act.ActivateTabRelative(-1) },
    { key = ']',          mods = 'SUPER|SHIFT', action = act.ActivateTabRelative(1) },
    { key = '1',          mods = 'SUPER',       action = act.ActivateTab(0) },
    { key = '2',          mods = 'SUPER',       action = act.ActivateTab(1) },
    { key = '3',          mods = 'SUPER',       action = act.ActivateTab(2) },
    { key = '4',          mods = 'SUPER',       action = act.ActivateTab(3) },
    { key = '5',          mods = 'SUPER',       action = act.ActivateTab(4) },
    -- word jump
    { key = "LeftArrow",  mods = "ALT",         action = act.SendString "\x1bb" },
    { key = "RightArrow", mods = "ALT",         action = act.SendString "\x1bf" },
}
config.mouse_bindings = {
    { event = { Up = { streak = 1, button = 'Left' } },    mods = 'NONE', action = act.CopyTo('Clipboard') },
    { event = { Down = { streak = 1, button = 'Right' } }, mods = 'NONE', action = act.PasteFrom('Clipboard') },
}

-- Window
config.initial_cols = 97
config.initial_rows = 23
config.window_background_opacity = 0.93
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- Cursor & Bell
config.default_cursor_style = 'SteadyBlock'
config.cursor_blink_rate = 0
config.audible_bell = 'Disabled'

-- Scrollback & Performance
config.scrollback_lines = 10000
config.front_end = 'WebGpu'
config.max_fps = 120

return config

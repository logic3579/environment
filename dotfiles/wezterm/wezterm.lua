local wezterm = require("wezterm")
local config = {}

-- Operation system
local is_windows = wezterm.target_triple:find("windows") ~= nil

-- Colors & Appearance
config.color_scheme = "Solarized Dark - Patched"
config.window_frame = {
	font = wezterm.font("MesloLGMDZ Nerd Font Mono"),
}

-- Launching Programs
local function file_exists(path)
	local f = io.open(path, "r")
	if f then
		f:close()
		return true
	end
	return false
end

local function find_windows_bash()
	local local_app = os.getenv("LOCALAPPDATA") or ""
	local candidates = {
		"D:\\Software\\Git\\bin\\bash.exe",
		"C:\\Program Files\\Git\\bin\\bash.exe",
		"C:\\Program Files (x86)\\Git\\bin\\bash.exe",
		local_app .. "\\Programs\\Git\\bin\\bash.exe",
	}
	for _, p in ipairs(candidates) do
		if file_exists(p) then
			return p
		end
	end
	return nil
end

config.default_cwd = "~"
if is_windows then
	local bash = find_windows_bash()
	if bash then
		config.default_prog = { bash, "--login" }
		config.launch_menu = {
			{ label = "Bash", args = { bash, "--login" } },
			{ label = "PowerShell", args = { "pwsh.exe" } },
			{ label = "CMD", args = { "cmd.exe" } },
			{ label = "WSL:Ubuntu", args = { "wsl.exe", "~" } },
		}
	else
		config.default_prog = { "pwsh.exe" }
		config.launch_menu = {
			{ label = "PowerShell", args = { "pwsh.exe" } },
			{ label = "CMD", args = { "cmd.exe" } },
		}
	end
else
	config.default_prog = { "zsh", "--login" }
	config.launch_menu = {
		{ label = "Bash", args = { "bash", "--login" } },
		{ label = "Fish", args = { "fish" } },
		{ label = "Zsh", args = { "zsh", "--login" } },
	}
end

-- Fonts
local font_fallbacks = { "MesloLGMDZ Nerd Font Mono" }
if is_windows then
	table.insert(font_fallbacks, "Microsoft YaHei")
	table.insert(font_fallbacks, "Segoe UI Emoji")
else
	table.insert(font_fallbacks, "PingFang SC")
	table.insert(font_fallbacks, "Apple Color Emoji")
end
config.font = wezterm.font_with_fallback(font_fallbacks)
config.font_size = 17.0

-- Key / Mouse Binding
-- On macOS SUPER = Cmd; on Windows SUPER = Win key (intercepted by OS).
-- Map the "primary" modifier to CTRL|SHIFT on Windows, which is the
-- conventional terminal modifier and does not collide with the taskbar.
local act = wezterm.action
local mod_key = is_windows and "CTRL|SHIFT" or "SUPER"

config.keys = {
	-- global
	{ key = "o", mods = mod_key, action = act.ShowLauncher },
	{ key = "Enter", mods = mod_key, action = act.ToggleFullScreen },
	{ key = "c", mods = "CTRL", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	-- tab manage
	{ key = "n", mods = mod_key, action = act.SpawnWindow },
	{ key = "t", mods = mod_key, action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "w", mods = mod_key, action = act.CloseCurrentTab({ confirm = false }) },
	{ key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
	{ key = "Tab", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
	{ key = "[", mods = "ALT", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "ALT", action = act.ActivateTabRelative(1) },
	{ key = "1", mods = "ALT", action = act.ActivateTab(0) },
	{ key = "2", mods = "ALT", action = act.ActivateTab(1) },
	{ key = "3", mods = "ALT", action = act.ActivateTab(2) },
	{ key = "4", mods = "ALT", action = act.ActivateTab(3) },
	{ key = "5", mods = "ALT", action = act.ActivateTab(4) },
	-- word jump
	{ key = "LeftArrow", mods = "ALT", action = act.SendString("\x1bb") },
	{ key = "RightArrow", mods = "ALT", action = act.SendString("\x1bf") },
}
config.mouse_bindings = {
	{ event = { Up = { streak = 1, button = "Left" } }, mods = "NONE", action = act.CopyTo("Clipboard") },
	{ event = { Down = { streak = 1, button = "Right" } }, mods = "NONE", action = act.PasteFrom("Clipboard") },
}

-- Window
config.initial_cols = 97
config.initial_rows = 23
config.window_background_opacity = 0.93
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- Cursor & Bell
config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 0
config.audible_bell = "Disabled"

-- Scrollback & Performance
config.scrollback_lines = 10000
config.front_end = "WebGpu"
config.max_fps = 120

return config

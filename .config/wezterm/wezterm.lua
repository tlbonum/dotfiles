local wezterm = require "wezterm"
local config = wezterm.config_builder()

-- config.debug_key_events = true
-- config.disable_default_key_bindings = true

-- config.hide_tab_bar_if_only_one_tab = true
-- config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.adjust_window_size_when_changing_font_size = false
config.use_dead_keys = false
config.use_fancy_tab_bar = false
config.scrollback_lines = 10000

config.color_scheme = "qwe"

config.font = wezterm.font({
	-- family = "JetBrains Mono",
	-- family = "Fira Code",
	family = "Berkeley Mono Nerd",
	-- harfbuzz_features = {"zero", "calt", "calig", "ss01", "cv05", "liga"},
	-- harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
})

config.font_size = 12.5
config.line_height = 1.26

-- config.font_size = 12.1
-- config.font_size = 12.5
-- config.line_height = 1.19
-- config.line_height = 1.35

config.window_padding = {
	left = '0',
	right = '0',
	top = '0',
	bottom = '0',
}

config.window_frame = {
	border_left_width = '3px',
	border_right_width = '3px',
	border_bottom_height = '3px',
	border_left_color = 'black',
	border_right_color = 'black',
	border_bottom_color = 'black',
}

local function is_vim(pane)
	local is_vim_env = pane:get_user_vars().IS_NVIM == 'true'
	if is_vim_env == true then return true end
	-- This gsub is equivalent to POSIX basename(3)
	-- Given "/foo/bar" returns "bar"
	-- Given "c:\\foo\\bar" returns "bar"
	local process_name = string.gsub(pane:get_foreground_process_name(), '(.*[/\\])(.*)', '%2')
	return process_name == 'nvim' or process_name == 'vim'
end

local function bind_super_key_to_vim(key, char)
	return {
		key = key,
		mods = 'CMD',
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({ SendKey = { key = char, mods = nil }, }, pane)
			else
				win:perform_action({ SendKey = { key = key, mods = 'CMD' } }, pane)
			end
		end)
	}
end

config.keys = {
	bind_super_key_to_vim('s', utf8.char(0xAA)),
	bind_super_key_to_vim('.', utf8.char(0xAB)),
	bind_super_key_to_vim(',', utf8.char(0xAC)),
	bind_super_key_to_vim('Enter', utf8.char(0xAF)),
	-- bind_super_key_to_vim('.', utf8.char(0xAD)),

	{ key = '"',          mods = "SHIFT|CTRL|ALT", action = "DisableDefaultAssignment", },
	{ key = "%",          mods = "SHIFT|CTRL|ALT", action = "DisableDefaultAssignment", },
	{ key = "h",          mods = "SHIFT|CTRL",     action = "DisableDefaultAssignment", },
	{ key = "j",          mods = "SHIFT|CTRL",     action = "DisableDefaultAssignment", },
	{ key = "l",          mods = "SHIFT|CTRL",     action = "DisableDefaultAssignment", },
	{ key = "k",          mods = "SHIFT|CTRL",     action = "DisableDefaultAssignment", },

	-- { key = "w",          mods = "ALT",            action = wezterm.action.CloseCurrentPane({ confirm = false }) },

	{ key = "v",          mods = "SHIFT|ALT",      action = wezterm.action.SplitPane({ direction = "Right", size = { Percent = 50, } }) },
	{ key = "s",          mods = "SHIFT|ALT",      action = wezterm.action.SplitPane({ direction = "Down", size = { Percent = 50, } }) },

	{ key = "o",          mods = "SHIFT|ALT",      action = wezterm.action.PaneSelect({ mode = 'SwapWithActive' }) },

	-- {key = 'd', mods = 'CMD', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },},
	-- {key = 'd', mods = 'CMD|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },},

	-- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
	{ key = "LeftArrow",  mods = "OPT",            action = wezterm.action { SendString = "\x1bb" } },

	-- Make Option-Right equivalent to Alt-f; forward-word
	{ key = "RightArrow", mods = "OPT",            action = wezterm.action { SendString = "\x1bf" } },
	-- {key = "RightArrow", mods = "OPT", action = wezterm.action { SendString = "\027[1;3C" }},

	-- Select next tab with cmd-opt-left/right arrow
	-- {key = 'LeftArrow', mods = 'CMD|OPT', action = wezterm.action.ActivateTabRelative(-1)},
	-- {key = 'RightArrow', mods = 'CMD|OPT', action = wezterm.action.ActivateTabRelative(1)},

	-- https://www.reddit.com/r/wezterm/comments/18y3m2v/macos_cmdleft_arrow/
	{ key = 'LeftArrow',  mods = 'CMD',            action = wezterm.action { SendString = "\x1bOH" }, },
	{ key = 'RightArrow', mods = 'CMD',            action = wezterm.action { SendString = "\x1bOF" }, }
}

config.mouse_bindings = {
	{ event = { Down = { streak = 1, button = 'Left' } }, mods = 'CMD|ALT', action = wezterm.action.SelectTextAtMouseCursor 'Block',       alt_screen = 'Any' },
	{ event = { Down = { streak = 4, button = 'Left' } }, mods = 'NONE',    action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone' }
}

local smart_splits = wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')
smart_splits.apply_to_config(config, {
	-- smart_splits.apply_to_config(config)
	-- direction_keys = { 'h', 'j', 'k', 'l' },
	modifiers = {
		move = 'SHIFT|META', -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = 'SHIFT|CTRL', -- modifier to use for pane resize, e.g. META+h to resize to the left
	}
})

config.inactive_pane_hsb = {
	saturation = 0.75,
	brightness = 0.66,
}

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
	local edge_background = '#000'
	local background = '#000'
	local foreground = '#585b70' -- overlay0

	if tab.is_active then
		background = '#181825' -- mantle
		-- foreground = '#c0c0c0'
		foreground = '#cdd6f4'
	elseif hover then
		-- background = '#3b3052'
		foreground = '#c0c0c0'
	end

	local edge_foreground = background
	local title = tab_title(tab)

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	title = wezterm.truncate_right(title, max_width - 2)

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		-- { Text = "" },
		-- { Text = " " },
		-- { Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = " " },
		{ Text = title },
		{ Text = " " },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = " " },
		-- { Text = "" },
	}
end)

wezterm.on('update-right-status', function(window, pane)
	-- Each element holds the text for a cell in a "powerline" style << fade
	local cells = {}

	-- Figure out the cwd and host of the current pane.
	-- This will pick up the hostname for the remote host if your
	-- shell is using OSC 7 on the remote host.
	local cwd_uri = pane:get_current_working_dir()
	if cwd_uri then
		local cwd = cwd_uri.file_path:gsub("/Users/thomas", "~")
		local hostname = cwd_uri.host or wezterm.hostname()

		-- Remove the domain name portion of the hostname
		local dot = hostname:find '[.]'
		if dot then
			hostname = hostname:sub(1, dot - 1)
		end
		if hostname == '' then
			hostname = wezterm.hostname()
		end

		table.insert(cells, cwd)
		-- table.insert(cells, hostname)
	end

	-- An entry for each battery (typically 0 or 1 battery)
	for _, b in ipairs(wezterm.battery_info()) do
		table.insert(cells, string.format('%.0f%%', b.state_of_charge * 100))
	end

	local date = wezterm.strftime '%a %b %-d %H:%M'
	table.insert(cells, date)

	-- Color palette for the backgrounds of each cell
	-- local colors = {
	-- 	'#3c1361',
	-- 	'#52307c',
	-- 	'#663a82',
	-- 	'#7c5295',
	-- 	'#b491c8',
	-- }

	-- Foreground color for the text across the fade
	-- local text_fg = '#c0c0c0'
	local text_fg = '#585b70' -- overlay0

	-- The elements to be formatted
	local elements = {}
	-- How many cells have been formatted
	local num_cells = 0

	-- Translate a cell into elements
	local function push(text, is_last)
		-- table.insert(elements, { Background = { Color = "#000" } })
		-- table.insert(elements, { Foreground = { Color = "#181825" } })
		-- table.insert(elements, { Text = "" })
		-- local cell_no = num_cells + 1
		-- table.insert(elements, { Background = { Color = colors[cell_no] } })
		-- table.insert(elements, { Background = { Color = "#181825" } })

		table.insert(elements, { Foreground = { Color = text_fg } })
		table.insert(elements, { Text = ' ' .. text .. ' ' })
		-- if not is_last then
		-- table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
		-- table.insert(elements, { Background = { Color = "#000" } })
		-- table.insert(elements, { Foreground = { Color = "#181825" } })
		-- table.insert(elements, { Text = "" })
		-- end
		-- table.insert(elements, { Background = { Color = "#000" } })
		num_cells = num_cells + 1
	end

	while #cells > 0 do
		local cell = table.remove(cells, 1)
		push(cell, #cells == 0)
	end

	window:set_right_status(wezterm.format(elements))
end)

return config

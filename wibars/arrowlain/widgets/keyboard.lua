--[[

      keyboard layout widget for arrow lain wibar

--]]

local wibox   = require("wibox")
local awful   = require("awful")
local helpers = require("lainmod.helpers")
local base16  = require("base16")

local function caps_hook(widget)
	if capslock_toggle_flag ~= 0 then
		capslock_toggle_flag = 0
		return;
	end
	local cmd = "xset -q | grep 'Caps Lock' | awk -F':' '{print $3}'| awk -F' ' '{print $1}'"
	helpers.async_with_shell(cmd, function(stdout, exit_code)
		if exit_code ~= 0 then
			return
		end
		local layout = widget.text;
		if stdout == "off\n" then
			if layout ~= layout:lower() then
				capslock_toggle_flag = 1
				widget:set_markup(layout:lower())
			end
		elseif stdout == "on\n" then
			if layout ~= layout:upper() then
				capslock_toggle_flag = 1
				widget:set_markup(layout:upper())
			end
		end
	end)
end

-- CapsLock toggle
local function caps_tg(widget)
	capslock_toggle_flag = 1
	local layout = widget.text;
	if layout == layout:lower() then
		layout = layout:upper()
	elseif layout == layout:upper() then
		layout = layout:lower()
	end
	widget:set_markup(layout)
end

local function factory (args)
	local cs      = args.cs or base16.solarized_dark
	local compact = args.compact

	local icon_kb = cs.paths.lainicons .. "keyboard2.png"

	if not mykeyboard_widget then
		-- make global for all screens and key bindings
		mykeyboard_widget = {}
		if compact then
			mykeyboard_widget.icon = nil
		else
			mykeyboard_widget.icon = wibox.widget.imagebox(icon_kb)
		end
		mykeyboard_widget.kblayout = awful.widget.keyboardlayout()
		-- CapsLock handler
		capslock_toggle_flag = 0
		caps_hook(mykeyboard_widget.kblayout.widget)
		mykeyboard_widget.kblayout.widget:connect_signal("widget::redraw_needed",
			function()
				caps_hook(mykeyboard_widget.kblayout.widget)
			end
		)
		-- make toggle global for key binding
		capslock_toggle = function() caps_tg(mykeyboard_widget.kblayout.widget) end
		end

	local widget = wibox.widget {
		mykeyboard_widget.icon,
		mykeyboard_widget.kblayout,
		layout = wibox.layout.align.horizontal
	}

	-- Bug when bind 'caps_tg' to CapsLock key , so hook on timer too
	helpers.newtimer("kblayout", 5, function()
		caps_hook(mykeyboard_widget.kblayout.widget)
	end)

	return widget
end

return factory

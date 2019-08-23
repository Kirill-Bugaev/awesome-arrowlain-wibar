--[[

     Alsa volume widget for arrow lain wibar

--]]

local wibox   = require("wibox")
local awful   = require("awful")
local lainmod = require("lainmod")
local base16  = require("base16")

local markup = lainmod.util.markup

local function factory(args)
	local font    = args.font or "xos4 Terminus 9"
	local cs      = args.cs or base16.solarized_dark
	local fg      = args.fg or cs.palette.barfg
	local spacer  = args.spacer or " "
	local compact = args.compact
	if compact then spacer = "" end

	local icon_vol      = cs.paths.lainicons .. "spkr.png"

	local function openmixer()
		awful.spawn(string.format("%s -e alsamixer -c 0", awful.util.terminal))
	end

	if not myvolume_widget then
	  -- make global for all screens and keybinding
		myvolume_widget = {}
		myvolume_widget.icon = wibox.widget.imagebox(icon_vol)
		myvolume_widget.alsa = lainmod.widget.alsa( {
			settings = function(widget, volume_now)
				local st
				if volume_now.level ~= nil and volume_now.status ~= nil then
					st = volume_now.level .. "%"
					if volume_now.status == "off" then st = st .. "M" end
				else
					st = "N/A"
				end
				widget:set_markup(markup.fontfg(font, fg, spacer .. st))
			end
		} )
		-- bind mouse button click for widget
		myvolume_widget.alsa.widget:buttons(awful.util.table.join (
			awful.button({}, 1, openmixer)
		))
		-- bind mouse button click for icon
		myvolume_widget.icon:buttons(awful.util.table.join (
			awful.button({}, 1, openmixer)
		) )
	end

	local widget = wibox.widget {
		myvolume_widget.icon,
		myvolume_widget.alsa.widget,
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

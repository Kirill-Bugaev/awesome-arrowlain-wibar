--[[

     Alsa volume widget for arrow lain wibar

--]]

local wibox   = require("wibox")
local awful   = require("awful")
local lainmod = require("lainmod")
local helpers = require("lainmod.helpers")
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

	local volicon = wibox.widget.imagebox(icon_vol)
	-- make global for keybinding
	if not myvolume then
		myvolume = {}
	end
	table.insert(myvolume, lainmod.widget.alsa( {
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
	} ))

	local function openmixer()
		awful.spawn(string.format("%s -e alsamixer -c 0", awful.util.terminal))
	end
	-- bind mouse button click
	volicon:buttons(awful.util.table.join (
		awful.button({}, 1, openmixer)
	) )
	myvolume[#myvolume].widget:buttons(awful.util.table.join (
		awful.button({}, 1, openmixer)
	))

	local widget = wibox.widget {
		volicon,
		myvolume[#myvolume],
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

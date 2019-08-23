--[[

     HDD temperature widget for arrow lain wibar

--]]

local wibox   = require("wibox")
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

	local icon_temp = cs.paths.lainicons .. "temp.png"

	if not myhddtemp_widget then
		-- make global for all screens
		myhddtemp_widget = {}
		if compact then
			myhddtemp_widget.icon = nil
		else
		myhddtemp_widget.icon = wibox.widget.imagebox(icon_temp)
		end
		myhddtemp_widget.temp = lainmod.widget.hddtemp( {
			settings = function(widget, hddtemp_now)
				local st
				if hddtemp_now ~= "N/A" then st = hddtemp_now .. "°C"
				else st = "N/A" end
				widget:set_markup(markup.fontfg(font, fg, spacer .. st))
			end
		} )
	end

	-- make single widget
	local widget = wibox.widget {
		myhddtemp_widget.icon,
		myhddtemp_widget.temp.widget,
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

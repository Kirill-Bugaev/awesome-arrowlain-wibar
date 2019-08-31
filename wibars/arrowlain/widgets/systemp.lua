--[[

     System temperature widget for arrow lain wibar

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

	local icon_temp	= cs.paths.lainicons .. "temp.png"

	if not mysystemp_widget then
	  -- make global for all screens
		mysystemp_widget = {}
		if compact then
			mysystemp_widget.icon = nil
		else
			mysystemp_widget.icon = wibox.widget.imagebox(icon_temp)
		end
		mysystemp_widget.temp = lainmod.widget.systemp( {
			dev      = "f71889ed-isa-0480", -- change it according to your lm_sensors device
			sensor   = "temp3",
			settings = function(widget, systemp_now)
				local st
				if systemp_now ~= "N/A" then
					st = math.floor(systemp_now + 0.5) .. "°C"
				else
					st = "N/A"
				end
				widget:set_markup(markup.fontfg(font, fg, spacer .. st))
			end
		} )
	end

	-- make single widget
	local widget = wibox.widget {
		mysystemp_widget.icon,
		mysystemp_widget.temp.widget,
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

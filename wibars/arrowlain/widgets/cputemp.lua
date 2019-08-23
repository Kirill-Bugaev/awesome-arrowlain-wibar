--[[

     cpu temperature widget for arrow lain wibar

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

	if not mycputemp_widget then
	  -- make global for all screens
		mycputemp_widget = {}
		if compact then
			mycputemp_widget.icon = nil
		else
			mycputemp_widget.icon = wibox.widget.imagebox(icon_temp)
		end
		mycputemp_widget.temp = lainmod.widget.cputemp( {
			dev = "k10temp-pci-00c3", -- change it according to your lm_sensors device
			settings = function(widget, coretemp_now)
				local st
				if coretemp_now ~= "N/A" then
					st = math.floor(coretemp_now + 0.5) .. "°C"
				else
					st = "N/A"
		    end
				widget:set_markup(markup.fontfg(font, fg, spacer .. st))
			end
		} )
	end

	-- make single widget
	local widget = wibox.widget {
		mycputemp_widget.icon,
		mycputemp_widget.temp.widget,
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

--[[

     battery widget for arrow lain wibar

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

	local icon_ac            = cs.paths.lainicons .. "ac.png"
	local icon_battery       = cs.paths.lainicons .. "battery.png"
	local icon_battery_low   = cs.paths.lainicons .. "battery_low.png"
	local icon_battery_empty = cs.paths.lainicons .. "battery_empty.png"

	local baticon = wibox.widget.imagebox(icon_battery)
	local battery = lainmod.widget.battery( {
		settings = function(widget, bat_now)
			if bat_now.status and bat_now.status ~= "N/A" then
				if bat_now.ac_status == 1 then
					local st = "AC"
					if compact then st = "" end
					widget:set_markup(markup.fontfg(font, fg, spacer .. st))
					baticon:set_image(icon_ac)
					return
				elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
					baticon:set_image(icon_battery_empty)
				elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
					baticon:set_image(icon_battery_low)
				else
					baticon:set_image(icon_battery)
				end
				widget:set_markup(markup.fontfg(font, fg, spacer .. bat_now.perc .. "%"))
			else
				widget:set_markup(markup.fontfg(font, fg, spacer .. "N/A"))
				baticon:set_image(icon_ac)
			end
		end
	} )

	local widget = wibox.widget {
		baticon,
		battery,
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

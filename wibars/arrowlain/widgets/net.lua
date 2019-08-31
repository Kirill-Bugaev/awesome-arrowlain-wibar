
--[[

     net widget for arrow lain wibar

--]]

local wibox   = require("wibox")
local lainmod = require("lainmod")
local base16  = require("base16")

local markup = lainmod.util.markup

local function factory(args)
	local font                = args.font or "xos4 Terminus 9"
	local cs                  = args.cs or base16.solarized_dark
	local fg                  = args.fg or cs.palette.barfg
	local notification_preset = args.notification_preset or {}
	local spacer              = args.spacer or " "
	local compact             = args.compact
	if compact then spacer = "" end

	local icon_net = cs.paths.lainicons .. "net.png"

	if not mynet_widget then
		-- make global for all screens
		mynet_widget = {}
		if compact then
			mynet_widget.icon = nil
		else
			mynet_widget.icon = wibox.widget.imagebox(icon_net)
		end
		mynet_widget.net = lainmod.widget.net( {
			followtag = true,
			netstat_notification_preset = notification_preset,
			settings = function(widget, net_now)
				widget:set_markup(markup.fontfg (
					font,
					fg,
					spacer .. math.floor(net_now.received + 0.5) .. "K" .. spacer .. "↓↑"
						.. spacer .. math.floor(net_now.sent + 0.5) .. "K"
				) )
			end
		} )
		if not compact then
			mynet_widget.icon:connect_signal("mouse::enter", function() mynet_widget.net.show_netstat_output(1) end)
			mynet_widget.icon:connect_signal("mouse::leave", function() mynet_widget.net.hide_netstat_output() end)
		end
	end

	local widget = wibox.widget {
		mynet_widget.icon,
		mynet_widget.net.widget,
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

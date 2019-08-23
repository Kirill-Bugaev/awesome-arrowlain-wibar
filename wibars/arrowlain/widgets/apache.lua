--[[

     Apache web server status check widget for arrow lain wibar

--]]

local wibox   = require("wibox")
local lainmod = require("lainmod")
local base16  = require("base16")

local markup = lainmod.util.markup

local widget_path = (debug.getinfo(1,"S").source:sub(2)):match("(.*/)")
local icons_path  = widget_path .. "icons/"
local icon_apache = icons_path .. "apache.png"

local function factory(args)
	local font                = args.font or "xos4 Terminus 9"
	local cs                  = args.cs or base16.solarized_dark
	local notification_preset = args.notification_preset or {}
	local fg                  = args.fg or cs.palette.barfg
	local margin              = args.margin or 5
	local compact             = args.compact
	if compact then margin = 0 end

	if not myapache_widget then
	  -- make global for all screens
		myapache_widget = {}
		myapache_widget.icon = wibox.widget.imagebox()
		myapache_widget.apache = lainmod.widget.apache( {
			timeout  = 2,
			logfile = "/var/log/httpd/access_log",
			loglength = 30,
			followtag = true,
			log_notification_preset = notification_preset,
			settings = function(widget, status)
				if status == 0 then
					myapache_widget.icon:set_image(icon_apache)
					-- widget:set_markup(markup.fontfg(font, fg, "apache on"))
					widget:set_markup(markup.fontfg(font, fg, ""))
					if myapache_widget.margined ~= nil then
						myapache_widget.margined.right = margin
					end
				else
					widget:set_text("")
					myapache_widget.icon._private.image = nil
					myapache_widget.icon:emit_signal("widget::redraw_needed")
					myapache_widget.icon:emit_signal("widget::layout_changed")
					if myapache_widget.margined ~= nil then
						myapache_widget.margined.right = 0
					end
				end
			end
		} )
		myapache_widget.icon:connect_signal("mouse::enter", function() myapache_widget.apache.show_log(1) end)
		myapache_widget.icon:connect_signal("mouse::leave", function() myapache_widget.apache.hide_log() end)
		myapache_widget.margined = wibox.container.margin(myapache_widget.apache.widget, 0, margin)
	end

  local widget = wibox.widget {
		myapache_widget.icon,
		myapache_widget.margined,
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

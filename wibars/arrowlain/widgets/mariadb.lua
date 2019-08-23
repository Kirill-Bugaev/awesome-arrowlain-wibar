--[[

     MariaDB status check widget for arrow lain wibar

--]]

local wibox   = require("wibox")
local lainmod = require("lainmod")
local base16  = require("base16")

local markup = lainmod.util.markup

local widget_path  = (debug.getinfo(1,"S").source:sub(2)):match("(.*/)")
local icons_path   = widget_path .. "icons/"
local icon_mariadb = icons_path .. "mariadb.png"

local function factory(args)
	local font                = args.font or "xos4 Terminus 9"
	local cs                  = args.cs or base16.solarized_dark
	local fg                  = args.fg or cs.palette.barfg
	local notification_preset = args.notification_preset or {}
	local margin              = args.margin or 5
	local compact             = args.compact
	if compact then margin = 0 end

	if not mymariadb_widget then
		-- make global for all screens
		mymariadb_widget = {}
		mymariadb_widget.icon = wibox.widget.imagebox()
		mymariadb_widget.mariadb = lainmod.widget.mariadb( {
			timeout  = 2,
			logfile = "/var/log/mysql/mariadb.log",
			loglength = 30,
			followtag = true,
			log_notification_preset = notification_preset,
			settings = function(widget, status)
				if status == 0 then
					mymariadb_widget.icon:set_image(icon_mariadb)
					-- widget:set_markup(markup.fontfg(font, fg, "mariadb on"))
					widget:set_markup(markup.fontfg(font, fg, ""))
					if mymariadb_widget.margined ~= nil then
						mymariadb_widget.margined.right = margin
					end
				else
					widget:set_text("")
					mymariadb_widget.icon._private.image = nil
					mymariadb_widget.icon:emit_signal("widget::redraw_needed")
					mymariadb_widget.icon:emit_signal("widget::layout_changed")
					if mymariadb_widget.margined ~= nil then
						mymariadb_widget.margined.right = 0
					end
				end
			end
		} )
		mymariadb_widget.icon:connect_signal("mouse::enter", function() mymariadb_widget.mariadb.show_log(1) end)
		mymariadb_widget.icon:connect_signal("mouse::leave", function() mymariadb_widget.mariadb.hide_log() end)
		mymariadb_widget.margined = wibox.container.margin(mymariadb_widget.mariadb.widget, 0, margin)
	end

  local widget = wibox.widget {
		mymariadb_widget.icon,
		mymariadb_widget.margined,
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

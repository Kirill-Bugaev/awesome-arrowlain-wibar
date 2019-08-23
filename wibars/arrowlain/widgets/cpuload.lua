--[[

     cpu load widget for arrow lain wibar

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

	local icon_cpu = cs.paths.lainicons .. "cpu.png"

	if not mycpuload_widget then
	  -- make global for all screens
		mycpuload_widget = {}
		mycpuload_widget.icon = wibox.widget.imagebox(icon_cpu)
		mycpuload_widget.cpu = lainmod.widget.cpu( {
			followtag = true,
			ps_notification_preset = notification_preset,
			settings = function(widget, cpu_now)
				widget:set_markup(markup.fontfg(font, fg, spacer .. cpu_now.usage .. "%"))
			end
		} )
		mycpuload_widget.icon:connect_signal("mouse::enter", function() mycpuload_widget.cpu.show_ps_output(1) end)
		mycpuload_widget.icon:connect_signal("mouse::leave", function() mycpuload_widget.cpu.hide_ps_output() end)
	end

	-- make single widget
	local widget = wibox.widget {
		mycpuload_widget.icon,
		mycpuload_widget.cpu.widget,
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

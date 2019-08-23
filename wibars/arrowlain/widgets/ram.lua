--[[

     RAM used widget for arrow lain wibar

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

	local icon_ram = cs.paths.lainicons .. "ram.png"

	if not myram_widget then
		-- make global for all screens
		myram_widget = {}
		myram_widget.icon = wibox.widget.imagebox(icon_ram)
		myram_widget.ram = lainmod.widget.memory( {
			followtag = true,
			ps_notification_preset = notification_preset,
			settings = function(widget, mem_now)
				widget:set_markup(markup.fontfg(font, fg, spacer .. mem_now.perc .. "%"))
			end
		} )
		myram_widget.icon:connect_signal("mouse::enter", function() myram_widget.ram.show_ps_output(1) end)
		myram_widget.icon:connect_signal("mouse::leave", function() myram_widget.ram.hide_ps_output() end)
	end

	-- make single widget
	local widget = wibox.widget {
		myram_widget.icon,
		myram_widget.ram.widget,
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

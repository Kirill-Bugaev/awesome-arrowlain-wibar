--[[

     cpu load widget for arrow lain wibar 

--]]

local wibox 	= require("wibox")
local lainmod  	= require("lainmod")
local base16	= require("base16")

local markup = lainmod.util.markup


local function factory (args)

    local font 			= args.font or "xos4 Terminus 9"
    local cs   			= args.cs or base16.solarized_dark
    local notification_preset 	= args.notification_preset or {}
    local spacer		= args.spacer or " "
    local compact		= args.compact
    if compact then spacer = "" end

    local fg   		= cs.palette.barfg
    local icon_cpu 	= cs.paths.lainicons .. "cpu.png"

    local cpuicon = wibox.widget.imagebox(icon_cpu)
    local cpu = lainmod.widget.cpu({
	followtag = true,
        ps_notification_preset = notification_preset,
        settings = function(widget, cpu_now)
            widget:set_markup(markup.fontfg(font, fg, spacer .. cpu_now.usage .. "%"))
        end
    })
    cpuicon:connect_signal("mouse::enter", function () cpu.show_ps_output(0) end)
    cpuicon:connect_signal("mouse::leave", function () cpu.hide_ps_output() end)

    -- make single widget
    local widget = wibox.widget {
	cpuicon,
	cpu,
	layout = wibox.layout.align.horizontal
    }

    return widget

end

return factory

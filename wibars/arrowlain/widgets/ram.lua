--[[

     RAM used widget for arrow lain wibar 

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
    local icon_ram      = cs.paths.lainicons .. "ram.png"

    local ramicon = wibox.widget.imagebox(icon_ram)
    local ram = lainmod.widget.memory({
	followtag = true,
        ps_notification_preset = notification_preset,
        settings = function(widget, mem_now)
            widget:set_markup(markup.fontfg(font, fg, spacer .. mem_now.perc .. "%"))
        end
    })
    ramicon:connect_signal("mouse::enter", function () ram.show_ps_output(0) end)
    ramicon:connect_signal("mouse::leave", function () ram.hide_ps_output() end)

    -- make single widget
    local widget = wibox.widget {
	ramicon,
	ram,
	layout = wibox.layout.align.horizontal
    }

    return widget
end

return factory

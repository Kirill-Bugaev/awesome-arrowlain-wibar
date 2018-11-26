--[[

     File system widget for arrow lain wibar 

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
    local icon_hdd	= cs.paths.lainicons .. "hdd.png"

    local fsicon = wibox.widget.imagebox(icon_hdd)
    local fs = lainmod.widget.fs({
	followtag = true,
        notification_preset = notification_preset,
        settings  = function(widget, fs_now)
--            widget:set_markup(markup.fontfg(font, fg, spacer .. string.format("%.1f", fs_now["/var"].percentage) .. "%"))
            widget:set_markup(markup.fontfg(font, fg, spacer .. string.format("%s", fs_now["/"].percentage) .. "%"))
        end
    })
    fsicon:connect_signal("mouse::enter", function () fs.show(0) end)
    fsicon:connect_signal("mouse::leave", function () fs.hide() end)

    -- make single widget
    local widget = wibox.widget {
	fsicon,
	fs,
	layout = wibox.layout.align.horizontal
    }

    return widget

end

return factory

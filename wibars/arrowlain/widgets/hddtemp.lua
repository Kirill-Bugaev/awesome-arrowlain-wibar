--[[

     HDD temperature widget for arrow lain wibar 

--]]

local wibox 	= require("wibox")
local lainmod  	= require("lainmod")
local base16	= require("base16")

local markup = lainmod.util.markup

local function factory (args)

    local font 		= args.font or "xos4 Terminus 9"
    local cs   		= args.cs or base16.solarized_dark
    local spacer	= args.spacer or " "
    local compact	= args.compact
    if compact then spacer = "" end

    local fg   		= cs.palette.barfg
    local icon_temp	= cs.paths.lainicons .. "temp.png"

    local tempicon = wibox.widget.imagebox(icon_temp)
    if compact then tempicon = nil end
    local temp = lainmod.widget.hddtemp({
        settings = function(widget, hddtemp_now)
	    if hddtemp_now ~= "N/A" then st = hddtemp_now .. "°C"
	    else st = "N/A" end
            widget:set_markup(markup.fontfg(font, fg, spacer .. st))
        end
    })

    -- make single widget
    local widget = wibox.widget {
	tempicon,
	temp,
	layout = wibox.layout.align.horizontal
    }

    return widget

end

return factory

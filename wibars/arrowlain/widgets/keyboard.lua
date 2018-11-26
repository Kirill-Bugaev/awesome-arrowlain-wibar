--[[

      keyboard layout widget for arrow lain wibar 

--]]

local wibox 	    = require("wibox")
local awful 	    = require("awful")


local function factory (args)

    local cs 		= args.cs or base16.solarized_dark
    local compact	= args.compact

    local icon_kb = cs.paths.lainicons .. "keyboard2.png"

    local kbicon = wibox.widget.imagebox(icon_kb)
    if compact then kbicon = nil end
    local kblayout = awful.widget.keyboardlayout()

    local widget = wibox.widget {
	kbicon,
	kblayout,
	layout = wibox.layout.align.horizontal
    }

    return widget

end

return factory

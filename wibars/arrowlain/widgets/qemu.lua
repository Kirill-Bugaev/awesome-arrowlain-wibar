--[[

     QEMU vm status check widget for arrow lain wibar 

--]]

local wibox 	= require("wibox")
local lainmod  	= require("lainmod")
local base16	= require("base16")

local markup = lainmod.util.markup

local widget_path = (debug.getinfo(1,"S").source:sub(2)):match("(.*/)")
local icons_path  = widget_path .. "icons/"
local icon_qemu	  = icons_path .. "qemu.png"


local function factory (args)

    local font 		= args.font or "xos4 Terminus 9"
    local cs   		= args.cs or base16.solarized_dark
    local margin	= args.margin or 5
    local compact	= args.compact
    if compact then margin = 0 end

    local fg   		= cs.palette.barfg

    local qemuicon = wibox.widget.imagebox()
    local qemu = lainmod.widget.qemu({
        timeout  = 2,
        settings = function(widget)
	    if _exit_code == 0 then
	        qemuicon:set_image(icon_qemu)
--                widget:set_markup(markup.fontfg(font, fg, "qemu on"))
                widget:set_markup(markup.fontfg(font, fg, ""))
		margined_qemu.right = margin
            else
                widget:set_text("")
                qemuicon._private.image = nil
                qemuicon:emit_signal("widget::redraw_needed")
                qemuicon:emit_signal("widget::layout_changed")
		margined_qemu.right = 0
            end
        end
    })

    margined_qemu = wibox.container.margin(qemu.widget, 0, margin)
    local widget = wibox.widget {
	qemuicon,
--	wibox.container.margin(qemu.widget, 0, margin),
	margined_qemu,
	layout = wibox.layout.align.horizontal
    }

    return widget

end

return factory

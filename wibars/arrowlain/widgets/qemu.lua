--[[

     QEMU vm status check widget for arrow lain wibar

--]]

local wibox   = require("wibox")
local lainmod = require("lainmod")
local base16  = require("base16")

local markup = lainmod.util.markup

local widget_path = (debug.getinfo(1,"S").source:sub(2)):match("(.*/)")
local icons_path  = widget_path .. "icons/"
local icon_qemu   = icons_path .. "qemu.png"

local function factory(args)
	local font    = args.font or "xos4 Terminus 9"
	local cs      = args.cs or base16.solarized_dark
	local fg      = args.fg or cs.palette.barfg
	local margin  = args.margin or 5
	local compact = args.compact
	if compact then margin = 0 end

	if not myqemu_widget then
		-- make global for all screens
		myqemu_widget = {}
		myqemu_widget.icon = wibox.widget.imagebox()
		myqemu_widget.qemu = lainmod.widget.qemu( {
			timeout  = 2,
			settings = function(widget, status)
				if status == 0 then
					myqemu_widget.icon:set_image(icon_qemu)
					widget:set_markup(markup.fontfg(font, fg, "qemu on"))
					widget:set_markup(markup.fontfg(font, fg, ""))
					if myqemu_widget.margined ~= nil then
						myqemu_widget.margined.right = margin
					end
				else
					widget:set_text("")
					myqemu_widget.icon._private.image = nil
					myqemu_widget.icon:emit_signal("widget::redraw_needed")
					myqemu_widget.icon:emit_signal("widget::layout_changed")
					if myqemu_widget.margined ~= nil then
						myqemu_widget.margined.right = 0
					end
				end
			end
		} )
		myqemu_widget.margined = wibox.container.margin(myqemu_widget.qemu.widget, 0, margin)
	end

	local widget = wibox.widget {
		myqemu_widget.icon,
		-- wibox.container.margin(qemu.widget, 0, margin),
		myqemu_widget.margined,
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

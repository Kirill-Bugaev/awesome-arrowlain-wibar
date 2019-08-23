--[[

     Samba server status check widget for arrow lain wibar

--]]

local wibox   = require("wibox")
local lainmod = require("lainmod")
local base16  = require("base16")

local markup  = lainmod.util.markup

local widget_path = (debug.getinfo(1,"S").source:sub(2)):match("(.*/)")
local icons_path  = widget_path .. "icons/"
local icon_smb    = icons_path .. "smb.png"

local function factory(args)
	local font    = args.font or "xos4 Terminus 9"
	local cs      = args.cs or base16.solarized_dark
	local fg      = args.fg or cs.palette.barfg
	local margin  = args.margin or 5
	local compact = args.compact
	if compact then margin = 0 end

	if not mysmb_widget then
		-- make global for all screens
		mysmb_widget = {}
		mysmb_widget.icon = wibox.widget.imagebox()
		mysmb_widget.smb = lainmod.widget.smb( {
			timeout  = 2,
			settings = function(widget, status)
				if status == 0 then
					mysmb_widget.icon:set_image(icon_smb)
					-- widget:set_markup(markup.fontfg(font, fg, "smb on"))
					widget:set_markup(markup.fontfg(font, fg, ""))
					if mysmb_widget.margined ~= nil then
						mysmb_widget.margined.right = margin
					end
				else
					widget:set_text("")
					mysmb_widget.icon._private.image = nil
					mysmb_widget.icon:emit_signal("widget::redraw_needed")
					mysmb_widget.icon:emit_signal("widget::layout_changed")
					if mysmb_widget.margined ~= nil then
						mysmb_widget.margined.right = 0
					end
				end
			end
		} )
		mysmb_widget.margined = wibox.container.margin(mysmb_widget.smb.widget, 0, margin)
	end

	local widget = wibox.widget {
		mysmb_widget.icon,
		-- wibox.container.margin(smb.widget, 0, margin),
		mysmb_widget.margined,
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

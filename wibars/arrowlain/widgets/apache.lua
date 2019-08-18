--[[

     Apache web server status check widget for arrow lain wibar

--]]

local wibox   = require("wibox")
local lainmod = require("lainmod")
local base16  = require("base16")

local markup = lainmod.util.markup

local widget_path = (debug.getinfo(1,"S").source:sub(2)):match("(.*/)")
local icons_path  = widget_path .. "icons/"
local icon_apache = icons_path .. "apache.png"

local function factory(args)
	local font    = args.font or "xos4 Terminus 9"
	local cs      = args.cs or base16.solarized_dark
	local fg      = args.fg or cs.palette.barfg
	local margin  = args.margin or 5
	local compact = args.compact
	if compact then margin = 0 end

	local apacheicon = wibox.widget.imagebox()
	local apache = lainmod.widget.apache({
		timeout  = 2,
		settings = function(widget, status)
			if status == 0 then
				apacheicon:set_image(icon_apache)
				-- widget:set_markup(markup.fontfg(font, fg, "apache on"))
				widget:set_markup(markup.fontfg(font, fg, ""))
				if margined_apache ~= nil then
					margined_apache.right = margin
				end
			else
				widget:set_text("")
				apacheicon._private.image = nil
				apacheicon:emit_signal("widget::redraw_needed")
				apacheicon:emit_signal("widget::layout_changed")
				if margined_apache ~= nil then
					margined_apache.right = 0
				end
			end
		end})

	margined_apache = wibox.container.margin(apache.widget, 0, margin)
  local widget = wibox.widget {
		apacheicon,
		margined_apache,
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

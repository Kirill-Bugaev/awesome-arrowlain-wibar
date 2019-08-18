--[[

     php-fpm status check widget for arrow lain wibar

--]]

local wibox   = require("wibox")
local lainmod = require("lainmod")
local base16  = require("base16")

local markup = lainmod.util.markup

local widget_path = (debug.getinfo(1,"S").source:sub(2)):match("(.*/)")
local icons_path  = widget_path .. "icons/"
local icon_phpfpm = icons_path .. "php-fpm.png"

local function factory(args)
	local font    = args.font or "xos4 Terminus 9"
	local cs      = args.cs or base16.solarized_dark
	local fg      = args.fg or cs.palette.barfg
	local margin  = args.margin or 5
	local compact = args.compact
	if compact then margin = 0 end

	local phpfpmicon = wibox.widget.imagebox()
	local phpfpm = lainmod.widget.phpfpm({
		timeout  = 2,
		settings = function(widget, status)
			if status == 0 then
				phpfpmicon:set_image(icon_phpfpm)
				-- widget:set_markup(markup.fontfg(font, fg, "php-fpm on"))
				widget:set_markup(markup.fontfg(font, fg, ""))
				if margined_phpfpm ~= nil then
					margined_phpfpm.right = margin
				end
			else
				widget:set_text("")
				phpfpmicon._private.image = nil
				phpfpmicon:emit_signal("widget::redraw_needed")
				phpfpmicon:emit_signal("widget::layout_changed")
				if margined_phpfpm ~= nil then
					margined_phpfpm.right = 0
				end
			end
		end})

	margined_phpfpm = wibox.container.margin(phpfpm.widget, 0, margin)
  local widget = wibox.widget {
		phpfpmicon,
		margined_phpfpm,
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

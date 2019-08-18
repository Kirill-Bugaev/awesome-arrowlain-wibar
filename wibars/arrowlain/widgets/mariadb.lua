--[[

     MariaDB status check widget for arrow lain wibar

--]]

local wibox   = require("wibox")
local lainmod = require("lainmod")
local base16  = require("base16")

local markup = lainmod.util.markup

local widget_path  = (debug.getinfo(1,"S").source:sub(2)):match("(.*/)")
local icons_path   = widget_path .. "icons/"
local icon_mariadb = icons_path .. "mariadb.png"

local function factory(args)
	local font    = args.font or "xos4 Terminus 9"
	local cs      = args.cs or base16.solarized_dark
	local fg      = args.fg or cs.palette.barfg
	local margin  = args.margin or 5
	local compact = args.compact
	if compact then margin = 0 end

	local mariadbicon = wibox.widget.imagebox()
	local mariadb = lainmod.widget.mariadb({
		timeout  = 2,
		settings = function(widget, status)
			if status == 0 then
				mariadbicon:set_image(icon_mariadb)
				-- widget:set_markup(markup.fontfg(font, fg, "mariadb on"))
				widget:set_markup(markup.fontfg(font, fg, ""))
				if margined_mariadb ~= nil then
					margined_mariadb.right = margin
				end
			else
				widget:set_text("")
				mariadbicon._private.image = nil
				mariadbicon:emit_signal("widget::redraw_needed")
				mariadbicon:emit_signal("widget::layout_changed")
				if margined_mariadb ~= nil then
					margined_mariadb.right = 0
				end
			end
		end})

	margined_mariadb = wibox.container.margin(mariadb.widget, 0, margin)
  local widget = wibox.widget {
		mariadbicon,
		margined_mariadb,
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

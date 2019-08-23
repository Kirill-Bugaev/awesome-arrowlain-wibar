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

	if not myphpfpm_widget then
		-- make global for all screens
		myphpfpm_widget = {}
		myphpfpm_widget.icon = wibox.widget.imagebox()
		myphpfpm_widget.php = lainmod.widget.phpfpm( {
			timeout  = 2,
			settings = function(widget, status)
				if status == 0 then
					myphpfpm_widget.icon:set_image(icon_phpfpm)
					-- widget:set_markup(markup.fontfg(font, fg, "php-fpm on"))
					widget:set_markup(markup.fontfg(font, fg, ""))
					if myphpfpm_widget.margined ~= nil then
						myphpfpm_widget.margined.right = margin
					end
				else
					widget:set_text("")
					myphpfpm_widget.icon._private.image = nil
					myphpfpm_widget.icon:emit_signal("widget::redraw_needed")
					myphpfpm_widget.icon:emit_signal("widget::layout_changed")
					if myphpfpm_widget.margined ~= nil then
						myphpfpm_widget.margined.right = 0
					end
				end
			end
		} )
		myphpfpm_widget.margined = wibox.container.margin(myphpfpm_widget.php.widget, 0, margin)
	end

  local widget = wibox.widget {
		myphpfpm_widget.icon,
		myphpfpm_widget.margined,
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

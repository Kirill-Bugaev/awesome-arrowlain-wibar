--[[

     File system widget for arrow lain wibar

--]]

local wibox   = require("wibox")
local lainmod = require("lainmod")
local base16  = require("base16")

local markup = lainmod.util.markup

local function factory(args)
	local font                = args.font or "xos4 Terminus 9"
	local cs                  = args.cs or base16.solarized_dark
	local fg                  = args.fg or cs.palette.barfg
	local notification_preset = args.notification_preset or {}
	local spacer              = args.spacer or " "
	local compact             = args.compact
	if compact then spacer = "" end

	local icon_hdd = cs.paths.lainicons .. "hdd.png"

	if not myfs_widget then
		-- make global for all screens
		myfs_widget = {}
		myfs_widget.icon = wibox.widget.imagebox(icon_hdd)
		myfs_widget.fs = lainmod.widget.fs( {
			followtag = true,
			notification_preset = notification_preset,
			settings  = function(widget, fs_now)
				-- widget:set_markup(markup.fontfg(font, fg, spacer .. string.format("%.1f", fs_now["/var"].percentage) .. "%"))
				widget:set_markup(markup.fontfg(font, fg, spacer .. string.format("%s", fs_now["/"].percentage) .. "%"))
			end
		} )
		myfs_widget.icon:connect_signal("mouse::enter", function() myfs_widget.fs.show(1) end)
		myfs_widget.icon:connect_signal("mouse::leave", function() myfs_widget.fs.hide() end)
	end

	-- make single widget
	local widget = wibox.widget {
		myfs_widget.icon,
		myfs_widget.fs.widget,
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

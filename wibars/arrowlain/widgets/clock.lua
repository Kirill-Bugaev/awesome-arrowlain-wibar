--[[

     textclock widget for arrow lain wibar

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

	local icon_time    = cs.paths.lainicons .. "time.png"
	-- local cal_icons = cs.paths.calicons

	if not myclock_widget then
	  -- make global for all screens
		myclock_widget = {}

		-- make textclock
		myclock_widget.icon = wibox.widget.imagebox(icon_time)
		if compact then myclock_widget.icon = nil end
		local st = markup.fontfg(font, fg, spacer .. "%a" .. spacer .. "%d") -- day of week and day of month
		if not compact then
			st = st .. markup.fontfg(font, fg, spacer .. "%b")                 -- month
		end
		st =  st .. markup.fontfg(font, fg, spacer .. ">" .. spacer)
			.. markup.fontfg(font, fg, "%H:%M")                                -- time
		myclock_widget.textclock = wibox.widget.textclock(st)
		-- local myclock_widget.textclock = wibox.widget.textclock(markup.fontfg(font, fg, spacer .. "%a %d %b")
		-- 	.. markup.fontfg(font, fg, " > ") .. markup.fontfg(font, fg, "%H:%M"))

		-- attach calendar
		local attach_to = {}
		if not compact then
			table.insert(attach_to, myclock_widget.icon)
		end
		table.insert(attach_to, myclock_widget.textclock)
		
		lainmod.widget.calendar( {
			cal = "cal --color=always",
			attach_to = attach_to,
			followtag = true,
			-- icons = cal_icons,
			currentday = {
				bg = cs.palette.barbg,
				fg = cs.palette.barfg
			},
			notification_preset = notification_preset -- default
		} )
	end

	local widget = wibox.widget {
		myclock_widget.icon,
		myclock_widget.textclock,
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

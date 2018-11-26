--[[

     textclock widget for arrow lain wibar 

--]]

local wibox 	= require("wibox")
local lainmod  	= require("lainmod")
local base16	= require("base16")

local markup = lainmod.util.markup

local function factory (args)

    local font 			= args.font or "xos4 Terminus 9"
    local cs 			= args.cs or base16.solarized_dark
    local notification_preset 	= args.notification_preset or {}
    local spacer		= args.spacer or " "
    local compact		= args.compact
    if compact then spacer = "" end

    local fg   		= cs.palette.barfg
    local icon_time     = cs.paths.lainicons .. "time.png"
--    local cal_icons	= cs.paths.calicons

    -- make textclock
    local timeicon = wibox.widget.imagebox(icon_time)
    if compact then timeicon = nil end
    local st = markup.fontfg(font, fg, spacer .. "%a" .. spacer .. "%d") -- day of week and day of month
    if not compact then st = st .. markup.fontfg(font, fg, spacer .. "%b") end -- month
    st =  st .. markup.fontfg(font, fg, spacer .. ">" .. spacer) .. markup.fontfg(font, fg, "%H:%M")	-- time
    local textclock = wibox.widget.textclock(st)
--    local textclock = wibox.widget.textclock(markup.fontfg(font, fg, spacer .. "%a %d %b") .. markup.fontfg(font, fg, " > ") .. markup.fontfg(font, fg, "%H:%M"))

    -- attach calendar
    local attach_to = {}
    if not compact then table.insert(attach_to, timeicon) end
    table.insert(attach_to, textclock)
    local calendar = lainmod.widget.calendar({
        cal = "cal --color=always",
        attach_to = attach_to,
	followtag = true,
--	icons = cal_icons,
	currentday = {
	    bg = cs.palette.barbg,
	    fg = cs.palette.barbg_magenta
        },
        notification_preset = notification_preset	-- default
    })

    local widget = wibox.widget {
	timeicon,
	textclock,
	layout = wibox.layout.align.horizontal
    }

    return widget

end

return factory

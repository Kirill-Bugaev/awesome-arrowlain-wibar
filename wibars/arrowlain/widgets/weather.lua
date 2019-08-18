--[[

     weather widget for arrow lain wibar

--]]

local wibox   = require("wibox")
local lainmod = require("lainmod")
local base16  = require("base16")
local secrets = require("wibars.arrowlain.secrets")

local markup = lainmod.util.markup

local function factory(args)
	local font                = args.font or "xos4 Terminus 9"
	local cs                  = args.cs or base16.solarized_dark
	local fg                  = args.fg or cs.palette.barfg
	local notification_preset = args.notification_preset or {}
	local spacer              = args.spacer or " "
	local compact             = args.compact
	if compact then spacer = "" end

	local icon_weather  = cs.paths.lainicons .. "dish.png"
	local at = "@"
	local compact_icons = {
		["01"] = "☀️",
		["02"] = "🌤",
		["03"] = "🌥",
		["04"] = "☁",
		["09"] = "🌧",
		["10"] = "🌦",
		["11"] = "🌩",
		["13"] = "🌨",
		["50"] = "🌫",
	}

	local weathericon = wibox.widget.imagebox(icon_weather)
	if compact then
		spacer = ""
		at = ""
		weathericon = nil
	end
	local weather = lainmod.widget.weather( {
		APPID               = secrets.openweather_api_key,
		-- Novosibirsk 1496747
		-- Bratsk 2051523
		city_id             = 2051523,
		followtag           = true,
		notification_preset = notification_preset,
		weather_na_markup   = markup.fontfg(font, fg, spacer .. "N/A"),
		settings = function(widget, weather_now)
			local descr
			if compact then
				descr = compact_icons[weather_now["weather"][1]["icon"]:sub(1, 2)]
			else
				descr = weather_now["weather"][1]["description"]:lower()
			end
			local units = math.floor(weather_now["main"]["temp"] + 0.5)
			widget:set_markup(markup.fontfg(font, fg, spacer .. descr .. spacer .. at .. spacer .. units .."°C"))
		end
	} )
	if not compact then
		weathericon:connect_signal("mouse::enter", function () weather.show(0) end)
		weathericon:connect_signal("mouse::leave", function () weather.hide() end)
	end

	local widget = wibox.widget {
		weathericon,
		weather,
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

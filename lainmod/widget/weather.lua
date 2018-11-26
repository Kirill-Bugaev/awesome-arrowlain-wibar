--[[

     Licensed under GNU General Public License v2
      * (c) 2015, Luca CPZ

--]]

local helpers  = require("lainmod.helpers")
local json     = require("lainmod.util").dkjson
local focused  = require("awful.screen").focused
local naughty  = require("naughty")
local wibox    = require("wibox")

local math, os, string, tonumber = math, os, string, tonumber

-- OpenWeatherMap
-- current weather and X-days forecast
-- lain.widget.weather

local function factory(args)
    local weather               = { widget = wibox.widget.textbox() }
    local args                  = args or {}
    local APPID                 = args.APPID or "3e321f9414eaedbfab34983bda77a66e" -- lain's default
    local timeout               = args.timeout or 60 * 5 -- 5 min
    local timeout_forecast      = args.timeout or 60 * 30 -- 30 min
    local current_call          = args.current_call  or "curl -s 'http://api.openweathermap.org/data/2.5/weather?id=%s&units=%s&lang=%s&APPID=%s'"
    local forecast_call         = args.forecast_call or "curl -s 'http://api.openweathermap.org/data/2.5/forecast/daily?id=%s&units=%s&lang=%s&cnt=%s&APPID=%s'"
    local city_id               = args.city_id or 0 -- placeholder
    local units                 = args.units or "metric"
    local lang                  = args.lang or "en"
    local cnt                   = args.cnt or 5
    local date_cmd              = args.date_cmd or "date -u -d @%d +'%%a %%d'"
    local icons_path            = args.icons_path or helpers.icons_dir .. "openweathermap/"
    local notification_preset   = args.notification_preset or {}

    local notification_text_fun = args.notification_text_fun or
                                  function (wn)
                                      local day = os.date("%a %d", wn["dt"])
                                      local tmin = math.floor(wn["temp"]["min"])
                                      local tmax = math.floor(wn["temp"]["max"])
                                      local desc = wn["weather"][1]["description"]
                                      return string.format("<b>%s</b>: %s, %d°C .. %d°C ", day, desc, tmin, tmax)
                                  end
    local weather_na_markup     = args.weather_na_markup or " N/A "
    local followtag             = args.followtag or false
    local showpopup             = args.showpopup or "on"
    local settings              = args.settings or function() end

    weather.current_weather 	= ""
    weather.forecast 		= ""
    weather.notification_text 	= ""

    weather.widget:set_markup(weather_na_markup)
    weather.icon_path = icons_path .. "na.png"
    weather.icon = wibox.widget.imagebox(weather.icon_path)

    function weather.show(t_out)
        weather.hide()

        if followtag then
            notification_preset.screen = focused()
        end

        if not weather.notification_text then
            weather.update()
            weather.forecast_update()
        end

	weather.notification_text = weather.current_weather .. weather.forecast
        weather.notification = naughty.notify({
            text    = weather.notification_text,
            icon    = weather.icon_path,
            timeout = t_out,
            preset  = notification_preset
        })
    end

    function weather.hide()
        if weather.notification then
            naughty.destroy(weather.notification)
            weather.notification = nil
        end
    end

    function weather.attach(obj)
        obj:connect_signal("mouse::enter", function()
            weather.show(0)
        end)
        obj:connect_signal("mouse::leave", function()
            weather.hide()
        end)
    end

    function weather.forecast_update()
        local cmd = string.format(forecast_call, city_id, units, lang, cnt, APPID)
        helpers.async(cmd, function(f)
            local pos, err
            local weather_now, pos, err = json.decode(f, 1, nil)

            if not err and type(weather_now) == "table" and tonumber(weather_now["cod"]) == 200 then
                weather.forecast = string.format("\n<b>Forecast (UTC):</b>\n")
		weather.forecast = weather.forecast .. string.format("<b>Last update</b> ") .. os.date("%H:%M %p", os.time(os.date("!*t", os.time()))) .. "\n"
                for i = 1, weather_now["cnt"] do
                    weather.forecast = weather.forecast ..
                                                notification_text_fun(weather_now["list"][i])
                    if i < weather_now["cnt"] then
                        weather.forecast = weather.forecast .. "\n"
                    end
                end
            end
        end)
    end

    function weather.update()
        local cmd = string.format(current_call, city_id, units, lang, APPID)
        helpers.async(cmd, function(f)
            local pos, err, icon
            local weather_now, pos, err = json.decode(f, 1, nil)

            if not err and type(weather_now) == "table" and tonumber(weather_now["cod"]) == 200 then
                local sunrise = tonumber(weather_now["sys"]["sunrise"])
                local sunset  = tonumber(weather_now["sys"]["sunset"])
                local icon    = weather_now["weather"][1]["icon"]
                local loc_now = os.time() -- local time
                local loc_m   = os.time { year = os.date("%Y"), month = os.date("%m"), day = os.date("%d"), hour = 0 } -- local time from midnight
                local loc_d   = os.date("*t",  loc_now) -- table YMDHMS for current local time (for TZ calculation)
                local utc_d   = os.date("!*t", loc_now) -- table YMDHMS for current UTC time
                local utc_now = os.time(utc_d) -- UTC time now
                local offdt   = (loc_d.isdst and 1 or 0) * 3600 + 100 * (loc_d.min  - utc_d.min) / 60 -- DST offset
                local offset  = os.difftime(loc_now, utc_now) + (loc_d.isdst and 1 or 0) * 3600 + 100 * (loc_d.min  - utc_d.min) / 60 -- TZ offset (including DST)
                local offday  = (offset < 0 and -86400) or 86400 -- 24 hour correction value (+86400 or -86400)

                -- if current UTC time is earlier then local midnight -> positive offset (negative otherwise)
                if offset * (loc_m - utc_now + offdt) > 0 then
                    sunrise = sunrise + offday -- Shift sunset and sunrise times by 24 hours
                    sunset  = sunset  + offday
                end

                if sunrise <= loc_now and loc_now <= sunset then
                    icon = string.gsub(icon, "n", "d")
                else
                    icon = string.gsub(icon, "d", "n")
                end

                weather.icon_path = icons_path .. icon .. ".png"
                local widget = weather.widget
                settings(widget, weather_now)

		-- Current weather for notification box
		degrees_to_direction = function (d)
    		    local val = math.floor(d/22.5 + 0.5)
    		    local directions = {
			    	      [0] = "North", [1] = "North - NorthEast",  [2] = "NorthEast",  [3] = "East - NorthEast",
                		      [4] = "East",  [5] = "East - SouthEast",   [6] = "SouthEast",  [7] = "South - SouthEast",
                		      [8] = "South", [9] = "South - SouthWest", [10] = "SouthWest", [11] = "West - SouthWest",
                		     [12] = "West", [13] = "West - NorthWest",  [14] = "NorthWest", [15] = "North - NorthWest"
			     	 }
    		    return directions[val % 16]
		end

		weather.current_weather = string.format("<b>City:</b> ") .. weather_now["name"] .. "\n"
		weather.current_weather = weather.current_weather .. string.format("<b>Conditions:</b> ") .. weather_now["weather"][1]["description"] .."\n"
		weather.current_weather = weather.current_weather .. string.format("<b>Temperature:</b> ") .. weather_now["main"]["temp"] .. "°C" .."\n"
		weather.current_weather = weather.current_weather .. string.format("<b>Wind:</b> ") ..  math.floor(weather_now["wind"]["speed"]*1000/3600+0.5) .. "mps "
		if weather_now["wind"]["deg"] ~= nil then
		    weather.current_weather = weather.current_weather .. degrees_to_direction(weather_now["wind"]["deg"])
		end
		weather.current_weather = weather.current_weather .. "\n"
		weather.current_weather = weather.current_weather .. string.format("<b>Pressure:</b> ") ..  math.floor(100*1000*weather_now["main"]["pressure"]/(13546*9.81)) .. "mmHg\n"
		weather.current_weather = weather.current_weather .. string.format("<b>Humidity:</b> ") ..  weather_now["main"]["humidity"] .. "%\n"
		weather.current_weather = weather.current_weather .. string.format("<b>Sunrise:</b> ") ..  os.date("%H:%M %p", weather_now["sys"]["sunrise"]) .. "\n"
		weather.current_weather = weather.current_weather .. string.format("<b>Sunset:</b> ") ..  os.date("%H:%M %p", weather_now["sys"]["sunset"]) .. "\n"
            else
                weather.icon_path = icons_path .. "na.png"
                weather.widget:set_markup(weather_na_markup)
		weather.current_weather = ""
		weather.notification_text = ""
            end

            weather.icon:set_image(weather.icon_path)
        end)
    end

    if showpopup == "on" then weather.attach(weather.widget) end

    weather.timer = helpers.newtimer("weather-" .. city_id, timeout, weather.update)
    weather.timer_forecast = helpers.newtimer("weather_forecast-" .. city_id, timeout_forecast, weather.forecast_update)

    return weather
end

return factory

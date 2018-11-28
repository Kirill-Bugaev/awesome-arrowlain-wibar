--[[

     Licensed under GNU General Public License v2
      * (c) 2018, Kirill Bugaev

--]]

local awful    = require("awful")
local helpers  = require("lainmod.helpers")
local wibox    = require("wibox")
local open     = io.open
local tonumber = tonumber

-- systemp
-- lain.widget.systemp

local function factory(args)
    local temp     = { widget = wibox.widget.textbox() }
    local args     = args or {}
    local timeout  = args.timeout or 2
--    local tempfile = args.tempfile or "/sys/class/thermal/thermal_zone0/temp"
    local settings = args.settings or function() end

    local dev		= "acpitz-virtual-0" 

    function temp.update()
--[[        local f = open(tempfile)
        if f then
            coretemp_now = tonumber(f:read("*all")) / 1000
            f:close()
        else
            coretemp_now = "N/A"
        end	]]--
	local sensors_cmd = "/usr/bin/sensors -A " .. dev .. " | grep temp1 | cut -c16-19"
	helpers.async_with_shell(sensors_cmd, function(stdout, exit_code)
	    local systemp_now = tonumber(stdout)
	    if (exit_code ~= 0) or (systemp_now == nil) then systemp_now = "N/A" end
            local widget = temp.widget
            settings(widget, systemp_now)
	end)
    end

    helpers.newtimer("systemp", timeout, temp.update)

    return temp
end

return factory

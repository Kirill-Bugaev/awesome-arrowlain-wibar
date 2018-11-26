--[[

     Licensed under GNU General Public License v2
      * (c) 2013, Luca CPZ

--]]

local awful    = require("awful")
local helpers  = require("lainmod.helpers")
local wibox    = require("wibox")
local open     = io.open
local tonumber = tonumber

-- coretemp
-- lain.widget.temp

local function factory(args)
    local temp     = { widget = wibox.widget.textbox() }
    local args     = args or {}
    local timeout  = args.timeout or 2
--    local tempfile = args.tempfile or "/sys/class/thermal/thermal_zone0/temp"
    local settings = args.settings or function() end

    function temp.update()
--[[        local f = open(tempfile)
        if f then
            coretemp_now = tonumber(f:read("*all")) / 1000
            f:close()
        else
            coretemp_now = "N/A"
        end	]]--
	local sensors_cmd = "bash -c '/usr/bin/sensors -A k10temp-pci-00c3 | grep temp1 | cut -c16-19'" 
	awful.spawn.easy_async(sensors_cmd, function(stdout, stderr, reason, exit_code)
	    local coretemp_now = tonumber(stdout)
	    if (exit_code ~= 0) or (coretemp_now == nil) then coretemp_now = "N/A" end
            local widget = temp.widget
            settings(widget, coretemp_now)
	end)
    end

    helpers.newtimer("coretemp", timeout, temp.update)

    return temp
end

return factory

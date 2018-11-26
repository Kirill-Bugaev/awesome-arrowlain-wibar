--[[

     Licensed under GNU General Public License v2
      * (c) 2013, Kirill Bugaev

--]]

local awful    = require("awful")
local helpers  = require("lainmod.helpers")
local wibox    = require("wibox")
local open     = io.open
local tonumber = tonumber

-- hddtemp
-- Receive HDD temperature from hddtemp daemon via TCP/IP on 7634 port
-- lain.widget.hddtemp

local function factory(args)
    local temp     = { widget = wibox.widget.textbox() }
    local args     = args or {}
    local host	   = args.host or "127.0.0.1"
    local port	   = args.port or "7634"
    local timeout  = args.timeout or 2
    local settings = args.settings or function() end

    function temp.update()
	local hddtemp_cmd = "bash -c '/usr/bin/nc " .. host .. " " .. port .. "'" 
	awful.spawn.easy_async(hddtemp_cmd, function(stdout, stderr, reason, exit_code)	
	    local hddtemp_now = tonumber(string.sub(stdout, -6, -5))
	    if (exit_code ~= 0) or (hddtemp_now == nil) then hddtemp_now = "N/A" end
	    local widget = temp.widget
            settings(widget, hddtemp_now)
	end)
    end

    helpers.newtimer("hddtemp", timeout, temp.update)

    return temp
end

return factory

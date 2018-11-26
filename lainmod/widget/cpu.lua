--[[

     Licensed under GNU General Public License v2
      * (c) 2013,      Luca CPZ
      * (c) 2010-2012, Peter Hofmann

--]]

local naughty  	= require("naughty")
local helpers   = require("lainmod.helpers")
local wibox     = require("wibox")
local awful    	= require("awful")
local math      = { ceil   = math.ceil }
local string    = { format = string.format,
                   gmatch = string.gmatch }
local tostring = tostring

-- CPU usage
-- lain.widget.cpu

local function factory(args)
    local cpu      = { core = {}, widget = wibox.widget.textbox() }

    function cpu.hide_ps_output()
	if not cpu.ps_notification then return end
	naughty.destroy(cpu.ps_notification)
	cpu.ps_notification = nil
    end

    function cpu.show_ps_output(src)
	local cmd = "/usr/bin/ps -eo pid,pcpu,comm --sort -pcpu"
  	awful.spawn.easy_async(cmd, function(stdout, stderr, reason, exit_code)
       	    cpu.ps_notification_preset.screen = cpu.followtag and awful.screen.focused() or scr or 1
	    cpu.ps_notification = naughty.notify {
		preset = cpu.ps_notification_preset,
		text = stdout,
		timeout = 0
	    } 
	end)
    end

    local args      = args or {}
    local timeout   = args.timeout or 2
    local showpopup = args.showpopup or "on"
    local settings  = args.settings or function() end

    cpu.followtag              = args.followtag or false
    cpu.ps_notification_preset = args.ps_notification_preset or {}

    function cpu.update()
        -- Read the amount of time the CPUs have spent performing
        -- different kinds of work. Read the first line of /proc/stat
        -- which is the sum of all CPUs.
        local times = helpers.lines_match("cpu","/proc/stat")

        for index,time in pairs(times) do
            local coreid = index - 1
            local core   = cpu.core[coreid] or
                           { last_active = 0 , last_total = 0, usage = 0 }
            local at     = 1
            local idle   = 0
            local total  = 0

            for field in string.gmatch(time, "[%s]+([^%s]+)") do
                -- 4 = idle, 5 = ioWait. Essentially, the CPUs have done
                -- nothing during these times.
                if at == 4 or at == 5 then
                    idle = idle + field
                end
                total = total + field
                at = at + 1
            end

            local active = total - idle

            if core.last_active ~= active or core.last_total ~= total then
                -- Read current data and calculate relative values.
                local dactive = active - core.last_active
                local dtotal  = total - core.last_total
                local usage   = math.ceil((dactive / dtotal) * 100)

                core.last_active = active
                core.last_total  = total
                core.usage       = usage

                -- Save current data for the next run.
                cpu.core[coreid] = core
            end
        end

        local cpu_now = cpu.core
        cpu_now.usage = cpu_now[0].usage
        local widget = cpu.widget

        settings(widget, cpu_now)
    end

    if showpopup == "on" then
       cpu.widget:connect_signal('mouse::enter', function () cpu.show_ps_output(0) end)
       cpu.widget:connect_signal('mouse::leave', function () cpu.hide_ps_output() end)
    end

    helpers.newtimer("cpu", timeout, cpu.update)

    return cpu
end

return factory

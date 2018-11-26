--[[

     Licensed under GNU General Public License v2
      * (c) 2013,      Luca CPZ
      * (c) 2010-2012, Peter Hofmann

--]]

local naughty  		   = require("naughty")
local helpers              = require("lainmod.helpers")
local wibox                = require("wibox")
local awful    		   = require("awful")
local gmatch, lines, floor = string.gmatch, io.lines, math.floor

-- Memory usage (ignoring caches)
-- lain.widget.mem

local function factory(args)
    local mem      = { widget = wibox.widget.textbox() }

    function mem.hide_ps_output()
	if not mem.ps_notification then return end
	naughty.destroy(mem.ps_notification)
	mem.ps_notification = nil
    end

    function mem.show_ps_output(src)
	local cmd = "/usr/bin/ps -eo pid,pmem,comm --sort -pmem"
  	awful.spawn.easy_async(cmd, function(stdout, stderr, reason, exit_code)
       	    mem.ps_notification_preset.screen = mem.followtag and awful.screen.focused() or scr or 1
	    mem.ps_notification = naughty.notify {
		preset = mem.ps_notification_preset,
		text = stdout,
		timeout = 0
	    } 
	end)
    end

    local args      = args or {}
    local timeout   = args.timeout or 2
    local showpopup = args.showpopup or "on"
    local settings  = args.settings or function() end

    mem.followtag              = args.followtag or false
    mem.ps_notification_preset = args.ps_notification_preset or {}

    function mem.update()
        local mem_now = {}
        for line in lines("/proc/meminfo") do
            for k, v in gmatch(line, "([%a]+):[%s]+([%d]+).+") do
                if     k == "MemTotal"     then mem_now.total = floor(v / 1024 + 0.5)
                elseif k == "MemFree"      then mem_now.free  = floor(v / 1024 + 0.5)
                elseif k == "Buffers"      then mem_now.buf   = floor(v / 1024 + 0.5)
                elseif k == "Cached"       then mem_now.cache = floor(v / 1024 + 0.5)
                elseif k == "SwapTotal"    then mem_now.swap  = floor(v / 1024 + 0.5)
                elseif k == "SwapFree"     then mem_now.swapf = floor(v / 1024 + 0.5)
                elseif k == "SReclaimable" then mem_now.srec  = floor(v / 1024 + 0.5)
                end
            end
        end

        mem_now.used = mem_now.total - mem_now.free - mem_now.buf - mem_now.cache - mem_now.srec
        mem_now.swapused = mem_now.swap - mem_now.swapf
        mem_now.perc = math.floor(mem_now.used / mem_now.total * 100 + 0.5)

        local widget = mem.widget
        settings(widget, mem_now)
    end

    if showpopup == "on" then
       mem.widget:connect_signal('mouse::enter', function () mem.show_ps_output(0) end)
       mem.widget:connect_signal('mouse::leave', function () mem.hide_ps_output() end)
    end

    helpers.newtimer("mem", timeout, mem.update)

    return mem
end

return factory

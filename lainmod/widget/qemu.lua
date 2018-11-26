
--[[

     Licensed under GNU General Public License v2
      * (c) 2018, Kirill Bugaev

--]]

local helpers  = require("lainmod.helpers")
local wibox    = require("wibox")
local awful    = require("awful")

-- QEMU vm status check
-- lain.widget.qemu

local function factory(args)
    local qemu       = { widget = wibox.widget.textbox() }
    local args      = args or {}
    local timeout   = args.timeout or 3
    local settings  = args.settings or function() end

    function update()
	local checkcmd = "/usr/lib/initcpio/busybox pidof qemu-system-x86_64"
  	awful.spawn.easy_async(checkcmd, function(stdout, stderr, reason, exit_code)
	    _exit_code = exit_code
	    local widget = qemu.widget
            settings(widget)
        end)
    end

    qemu.timer = helpers.newtimer("qemu vm check", timeout, update, true, true)

    return qemu
end

return factory

--[[

     Licensed under GNU General Public License v2
      * (c) 2018, Kirill Bugaev

--]]

local helpers  = require("lainmod.helpers")
local wibox    = require("wibox")
local awful    = require("awful")

-- Samba server status check
-- lain.widget.smb

local function factory(args)
    local smb       = { widget = wibox.widget.textbox() }
    local args      = args or {}
    local timeout   = args.timeout or 3
    local settings  = args.settings or function() end

    function update()
	local checkcmd = "systemctl status smb"
  	awful.spawn.easy_async(checkcmd, function(stdout, stderr, reason, exit_code)
	    _exit_code = exit_code
	    local widget = smb.widget
            settings(widget)
        end)
    end

    smb.timer = helpers.newtimer("smb server check", timeout, update, true, true)

    return smb
end

return factory

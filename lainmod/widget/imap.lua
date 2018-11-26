--[[

     Licensed under GNU General Public License v2
      * (c) 2013, Luca CPZ

--]]

local helpers  	= require("lainmod.helpers")
local naughty  	= require("naughty")
local wibox    	= require("wibox")
local awful    	= require("awful")
local focused   = require("awful.screen").focused
local beautiful	= require("beautiful")
local string   	= string
local type     	= type
local tonumber 	= tonumber

-- Mail IMAP check
-- lain.widget.imap

local function factory(args)
    local imap      = { widget = wibox.widget.textbox() }
 --   imap.hint_notification = nil
    imap.mail 	= args.mail
    local icon	= args.icon or ""

    function imap.hide_hint_notify()
	if not imap.hint_notification then return end
	naughty.destroy(imap.hint_notification)
	imap.hint_notification = nil
    end

    function imap.show_hint_notify(src)
	if helpers.get_map(imap.mail) ~= "N/A" then
	    hint_notification_preset = helpers.shallow_table_copy(imap.notification_preset)
--	    hint_notification_preset.icon = helpers.icons_dir .. "mail.png"
	    hint_notification_preset.icon = icon
       	    hint_notification_preset.screen = imap.followtag and focused() or scr or 1
--          hint_notification_preset.position = "top_right"
	    notify_text = tostring(helpers.get_map(imap.mail)) .. " unseen on " .. imap.mail
	    imap.hint_notification = naughty.notify {
		preset = hint_notification_preset,
		text = notify_text,
		timeout = 0
	    }
	end
    end

    local args      = args or {}
    local server    = args.server
    local mail      = args.mail
    local password  = args.password
    local port      = args.port or 993
    local timeout   = args.timeout or 60
    local is_plain  = args.is_plain or false
    local followtag = args.followtag or false
    local notify    = args.notify or "on"
    local showpopup = args.showpopup or "on"
    local settings  = args.settings or function() end
    
    imap.followtag           = args.followtag or false
    imap.notification_preset = args.notification_preset or { }

--    local head_command = "curl --connect-timeout 3 -fsm 3"
    local head_command = "curl --connect-timeout 30 -fsm 30"
    local request = "-X 'SEARCH (UNSEEN)'"

    if not server or not mail or not password then return end

    helpers.set_map(mail, 0)

    if not is_plain then
        if type(password) == "string" or type(password) == "table" then
            helpers.async(password, function(f) password = f:gsub("\n", "") end)
        elseif type(password) == "function" then
            local p = password()
        end
    end

    function update()

	mail_notification_preset = helpers.shallow_table_copy(imap.notification_preset) 
--	mail_notification_preset.icon = helpers.icons_dir .. "mail.png"
	mail_notification_preset.icon = icon
        mail_notification_preset.position = "top_left"

        if followtag then
            mail_notification_preset.screen = awful.screen.focused()
        end

        local curl = string.format("%s --url imaps://%s:%s/INBOX -u %s:%q %s -k",
               head_command, server, port, mail, password, request)

--        helpers.async(curl, function(f)
--	    mailcount = tonumber(f:match("UNSEEN (%d+)"))
  	awful.spawn.easy_async(curl, function(stdout, stderr, reason, exit_code)
	    local _,mailcount = stdout:gsub("%S+","")
	    if exit_code == 0 then
		if mailcount == nil then
		    mailcount = 0
		else
		    mailcount = mailcount - 2
		end
	    else
		mailcount = "N/A"
	    end
	    local widget = imap.widget
            settings(widget, mailcount)

	    if mailcount ~= "N/A" then
		if notify == "on" and mailcount >= 1 and mailcount > helpers.get_map(mail) then
		    if mailcount == 1 then
			nt = mail .. " has one new message"
		    else
			nt = mail .. " has <b>" .. mailcount .. "</b> new messages"
		    end
		    naughty.notify { preset = mail_notification_preset, text = nt }
		end
	    end

            helpers.set_map(mail, mailcount)
        end)
    end

    if showpopup == "on" then
       imap.widget:connect_signal('mouse::enter', function () imap.show_hint_notify(0) end)
       imap.widget:connect_signal('mouse::leave', function () imap.hide_hint_notify() end)
    end

    imap.timer = helpers.newtimer(mail, timeout, update)

    return imap
end

return factory

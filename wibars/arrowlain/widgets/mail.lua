--[[

     First mail widget for arrow lain wibar

--]]

local wibox   = require("wibox")
local awful   = require("awful")
local lainmod = require("lainmod")
local base16  = require("base16")

local markup  = lainmod.util.markup
local browser = awful.util.browser

local function factory(args, account, password, mailbox_number)
	local font                = args.font or "xos4 Terminus 9"
	local cs                  = args.cs or base16.solarized_dark
	local fg                  = args.fg or cs.palette.barfg
	local notification_preset = args.notification_preset or {}
	local spacer              = args.spacer or " "
	local compact             = args.compact
	if compact then spacer = "" end

	local icon_mail = cs.paths.lainicons .. "mail.png"

	-- mailbox buttons join
	local function om_table(boxnumber)
		return  awful.util.table.join (
		awful.button({}, 1, function()
			awful.spawn(
				string.format("%s --target window https://mail.google.com/mail/u/%s/", browser, boxnumber)
			)
		end )
		)
	end

	-- Mail account
	local mailicon = wibox.widget.imagebox(icon_mail)
	local mail = lainmod.widget.imap( {
		timeout             = 180,
		server              = "imap.gmail.com",
		mail                = account,
		password            = password,
		notify              = "off",
		followtag           = true,
		icon                = cs.paths.icons_path .. "mail.png",
		notification_preset = notification_preset, -- default
		settings = function(widget, mailcount)
			if mailcount == 0 then
			    widget:set_text("")
			else
			    widget:set_markup(markup.fontfg(font, fg, spacer .. mailcount))
			end
		end
	} )
	mail.widget:buttons(om_table(mailbox_number))
	mailicon:buttons(om_table(mailbox_number))
	mailicon:connect_signal("mouse::enter", function() mail.show_hint_notify(0) end)
	mailicon:connect_signal("mouse::leave", function() mail.hide_hint_notify() end)

	-- make single widget
	local widget = wibox.widget {
		mailicon,
		mail,
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

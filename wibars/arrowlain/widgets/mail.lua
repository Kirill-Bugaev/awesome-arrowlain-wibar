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

	if not mymail_widgets then
		-- make global for all screens
		mymail_widgets = {}
	end
	local already_made = 0
	for i, w in ipairs(mymail_widgets) do
		if w.mail.account == account then
			already_made = i
			break
		end
	end

	local mymail
	if already_made ~= 0 then
		mymail = mymail_widgets[already_made]
	else
		mymail = {}
		mymail.icon = wibox.widget.imagebox(icon_mail)
		mymail.mail = lainmod.widget.mail( {
			host                = "imap.gmail.com",
			tls                 = true,
			client_to           = 5,
			account             = account,
			password            = password,
			mailbox             = "INBOX",
			get_message_count   = 30,
			timeout             = 180,
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
		mymail.mail.widget:buttons(om_table(mailbox_number))
		mymail.icon:buttons(om_table(mailbox_number))
		mymail.icon:connect_signal("mouse::enter", function() mymail.mail.show_hint_notify(0) end)
		mymail.icon:connect_signal("mouse::leave", function() mymail.mail.hide_hint_notify() end)
		table.insert(mymail_widgets, mymail)
	end

	-- make single widget
	local widget = wibox.widget {
		mymail.icon,
		mymail.mail.widget,
		layout = wibox.layout.align.horizontal
	}

	return widget
end

return factory

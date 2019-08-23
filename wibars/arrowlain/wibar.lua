--[[

     Awesome WM arrow style wibar
     wibar with lain widgets

--]]

local gears   = require("gears")
local base16  = require("base16")
local awful   = require("awful")
local wibox   = require("wibox")
local wibars  = require("wibars")
local helpers = require("lainmod.helpers")

local secrets   = wibars.arrowlain.secrets
local my_table  = awful.util.table or gears.table -- 4.{0,1} compatibility

local widgets       = wibars.arrowlain.widgets
local arrow_wrapper = wibars.arrowlain.arrow_wrapper
local margins       = wibars.arrowlain.margins

local function order_widgets(wt, dir)
	local new_wt = {}

	if dir == "right" then
		new_wt = wt
	else
		for i = #wt, 1, -1 do
			table.insert(new_wt, wt[i])
		end
	end

	return new_wt
end

local function factory(args)
	local position = args.position or "bottom"
	local visible  = args.visible or true
	local height   = args.height or 16
	local scr      = args.screen or awful.screen.focused()
	local font     = args.font or "xos4 Terminus 9"
	local cs       = args.cs or base16.solarized_dark
	local dir      = args.direction -- arrow direction
	local spacer   = args.spacer
	local compact  = args.compact
	if string.lower(dir) ~= "right" then dir = "left" end
	if spacer == nil then spacer = true end
	if compact == nil then compact = false end

	-- make wibar
	local wibar = awful.wibar({
		position = position,
		visible  = visible,
		height   = height,
		screen   = scr,
		bg       = cs.palette.barbg,
		fg       = cs.palette.colorized_barfg_unfocus -- stub for keyboard layout widget
	})

	-- {{{ Lain widgets
	local widgetsettings = {
		font                = font,
		spacer              = " ",
		compact             = compact,
		cs                  = cs,
		fg                  = cs.palette.colorized_barfg_unfocus, -- for text on colorized arrows
		notification_preset = {
			position = position .. "_right",
			bg       = cs.palette.notification_bg,
			fg       = cs.palette.notification_fg,
			font     = font
		}
	}
	if compact then
	-- widgetsettings.spacer = ""
		for k, _ in pairs(margins) do
			margins[k].left  = 0
			margins[k].right = 2
		end
		margins.kblayout.right = 0
		margins.cpuload.right  = 0
		margins.cputemp.right  = 0
		margins.ram.right      = 0
		margins.systemp.right  = 0
		margins.fs.right       = 0
		margins.hddtemp.right  = 0
		margins.mail1.right    = 0
		margins.mail2.right    = 0
	end

	-- Arrow wrapped widgets
	-- Text clock
	-- naked
	local clockw_set = helpers.deep_table_copy(widgetsettings)
	clockw_set.notification_preset.fg = cs.palette.colorized_barfg_unfocus
	clockw_set.notification_preset.bg = cs.palette.barbg_magenta
	local nclock = widgets.clock(clockw_set)
	-- wrapped
	local wclock = arrow_wrapper (
		nclock,
		cs.palette.barbg_magenta,
		dir,
		margins.clock.left,
		margins.clock.right,
		spacer,
		cs.palette.barbg_blue,
		true
	)
	-- Weather
	local weatherw_set = helpers.deep_table_copy(widgetsettings)
	weatherw_set.notification_preset.fg = cs.palette.colorized_barfg_unfocus
	weatherw_set.notification_preset.bg = cs.palette.barbg_blue
	local nweather = widgets.weather(weatherw_set)
	local wweather = arrow_wrapper (
		nweather,
		cs.palette.barbg_blue,
		dir,
		margins.weather.left,
		margins.weather.right,
		spacer,
		cs.palette.barbg_violet,
		false
	)
	-- Battery
	local nbattery = widgets.battery(widgetsettings)
	local wbattery = arrow_wrapper (
		nbattery,
		cs.palette.barbg_violet,
		dir,
		margins.battery.left,
		margins.battery.right,
		spacer,
		cs.palette.barbg_yellow,
		false
	)
	-- ALSA volume
	local nvolume = widgets.alsavol(widgetsettings)
	local wvolume = arrow_wrapper (
		nvolume,
		cs.palette.barbg_yellow,
		dir,
		margins.volume.left,
		margins.volume.right,
		spacer,
		cs.palette.barbg_cyan,
		false
	)
	-- Keyboard map indicator and switcher
	local nkblayout = widgets.keyboard(args)
	local wkblayout = arrow_wrapper (
		nkblayout,
		cs.palette.barbg_cyan,
		dir,
		margins.kblayout.left,
		margins.kblayout.right,
		spacer,
		cs.palette.barbg_red,
		false
	)
	-- CPU load and temperature
	local cpuw_set = helpers.deep_table_copy(widgetsettings)
	cpuw_set.notification_preset.fg = cs.palette.colorized_barfg_unfocus
	cpuw_set.notification_preset.bg = cs.palette.barbg_red
	local ncpuload = widgets.cpuload(cpuw_set)
	local ncputemp = widgets.cputemp(widgetsettings)
	local ncpu = wibox.widget {
		wibox.container.margin(ncpuload, margins.cpuload.left, margins.cpuload.right),
		wibox.container.margin(ncputemp, margins.cputemp.left, margins.cputemp.right),
		layout = wibox.layout.align.horizontal
	}
	local wcpu = arrow_wrapper (
		ncpu,
		cs.palette.barbg_red,
		dir,
		margins.cpu.left,
		margins.cpu.right,
		spacer,
		cs.palette.barbg_orange,
		false
	)
	-- RAM and system temperature
	local ramw_set = helpers.deep_table_copy(widgetsettings)
	ramw_set.notification_preset.fg = cs.palette.colorized_barfg_unfocus
	ramw_set.notification_preset.bg = cs.palette.barbg_orange
	local nram = widgets.ram(ramw_set)
	local nsystemp = widgets.systemp(widgetsettings)
	local nramsys = wibox.widget {
		wibox.container.margin(nram, margins.ram.left, margins.ram.right),
		wibox.container.margin(nsystemp, margins.systemp.left, margins.systemp.right),
		layout = wibox.layout.align.horizontal
	}
	local wramsys = arrow_wrapper (
		nramsys,
		cs.palette.barbg_orange,
		dir,
		margins.ramsys.left,
		margins.ramsys.right,
		spacer,
		cs.palette.barbg_green,
		false
	)
	-- File system and HDD temperature
	local fsw_set = helpers.deep_table_copy(widgetsettings)
	fsw_set.notification_preset.fg = cs.palette.colorized_barfg_unfocus
	fsw_set.notification_preset.bg = cs.palette.barbg_green
	local nfs = widgets.fs(fsw_set)
	local nhddtemp = widgets.hddtemp(widgetsettings)
	local nfshdd = wibox.widget {
		wibox.container.margin(nfs, margins.fs.left, margins.fs.right),
		wibox.container.margin(nhddtemp, margins.hddtemp.left, margins.hddtemp.right),
		layout = wibox.layout.align.horizontal
	}
	local wfshdd = arrow_wrapper (
		nfshdd,
		cs.palette.barbg_green,
		dir,
		margins.fshdd.left,
		margins.fshdd.right,
		spacer,
		cs.palette.barbg_blue,
		false
	)
	-- Net
	local netw_set = helpers.deep_table_copy(widgetsettings)
	netw_set.notification_preset.fg = cs.palette.colorized_barfg_unfocus
	netw_set.notification_preset.bg = cs.palette.barbg_blue
	local nnet = widgets.net(netw_set)
	local wnet = arrow_wrapper (
		nnet,
		cs.palette.barbg_blue,
		dir,
		margins.net.left,
		margins.net.right,
		spacer,
		cs.palette.barbrbg,
		false
	)
	-- Mail
	local mailw_set = helpers.deep_table_copy(widgetsettings)
	mailw_set.notification_preset.fg = cs.palette.barbrfg
	mailw_set.notification_preset.bg = cs.palette.barbrbg
	mailw_set.fg = cs.palette.barbrfg
	local nmail1 = widgets.mail(mailw_set, secrets.mail1.account, secrets.mail1.password, 1)
	local nmail2 = widgets.mail(mailw_set, secrets.mail2.account, secrets.mail2.password, 0)
	local nmail = wibox.widget {
		wibox.container.margin(nmail1, margins.mail1.left, margins.mail1.right),
		wibox.container.margin(nmail2, margins.mail2.left, margins.mail2.right),
		layout = wibox.layout.align.horizontal
	}
	local wmail = arrow_wrapper (
		nmail,
		cs.palette.barbrbg,
		dir,
		margins.mail.left,
		margins.mail.right,
		spacer,
		"alpha",
		false
	)

	-- Naked widgets
	widgetsettings.fg = cs.palette.barfg
	widgetsettings.margin = margins.between_naked.right
	-- Apache status check
	local napache = widgets.apache(widgetsettings)
	-- MariaDB status check
	local nmariadb = widgets.mariadb(widgetsettings)
	-- php-fpm status check
	local nphpfpm = widgets.phpfpm(widgetsettings)
	-- Samba server status check
	local nsmb = widgets.smb(widgetsettings)
	-- QEMU vm status check
	local nqemu = widgets.qemu(widgetsettings)

	-- Order widgets and make single
	local wt = {
		wclock,
		wweather,
		wbattery,
		wvolume,
		wkblayout,
		wcpu,
		wramsys,
		wfshdd,
		wnet,
		wmail,
		napache,
		nmariadb,
		nphpfpm,
		nsmb,
		nqemu
	}
	wt = order_widgets(wt, dir)
	local single = helpers.make_single_widget(wt, wibox.layout.align.horizontal)
	local arrowlain_left, arrowlain_right
	if dir == "right" then
		arrowlain_left = single
		arrowlain_right = nil
	else
		arrowlain_left = nil
		arrowlain_right = single
	end
	-- }}}

	-- Awesome widgets
	-- Prompt box. Make it for screen
	scr.mypromptbox = awful.widget.prompt()
	-- Layout box
	local mylayoutbox = awful.widget.layoutbox(scr)
	mylayoutbox:buttons(my_table.join (
		awful.button({ }, 1, function() awful.layout.inc( 1) end),
		awful.button({ }, 3, function() awful.layout.inc(-1) end),
		awful.button({ }, 4, function() awful.layout.inc( 1) end),
		awful.button({ }, 5, function() awful.layout.inc(-1) end)
	) )

	-- Add widgets to wibar
	wibar:setup {
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			arrowlain_left,
			wibox.widget.systray(),
			scr.mypromptbox,
		},
		-- Middle widget
		nil,
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			arrowlain_right,
			mylayoutbox,
		},
	}

	return wibar
end

return factory

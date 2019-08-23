# awesome-arrowlain-wibar
Wibar in arrow style with modified Lain widgets for Awesome WM

This project was inspired by [lcpz/awesome-copycast][] Powerarrow theme and Vim [Powerline][] plugin. It uses modified Lain library for Awesome WM, original can be found at [lcpz/lain][].

## Introduction

This wibar is an extension for Awesome WM. It allows you to monitor system and hardware state, current weather and forecast, mailboxes, etc. See [screenshots][] section below for a demonstration of wibar capabilities.

The most laborious part is configuring widgets is described in [configuration][] section.

See [troubleshooting][] section if you're having any issues with wibar. 

## Screenshots

![Screenshot of normal left solarized](https://github.com/Kirill-Bugaev/awesome-arrowlain-wibar/blob/master/screenshots/screenshot_normal_spacer_left_solarized.png)
![Screenshot of normal right nord](https://github.com/Kirill-Bugaev/awesome-arrowlain-wibar/blob/master/screenshots/screenshot_normal_nospacer_right_nord.png)
![Screenshot of compact left default](https://github.com/Kirill-Bugaev/awesome-arrowlain-wibar/blob/master/screenshots/screenshot_compact_nospacer_left_default.png)

## Installation

*awesome-arrowlain-wibar requires [awesome-lainmod][] lua library and [awesome-base16][] color schemes suite which are separately distributed. You need to install them first.*

Clone current repository to temporary directory with `git clone https://github.com/Kirill-Bugaev/awesome-arrowlain-wibar.git`. Copy `wibars` directory from `awesome-arrowlain-wibar` directory to your Awesome WM configuration directory (`~/.config/awesome` by default).

## Configuration

### Adding wibar to Awesome WM screens

1. Open your Awesome WM lua configuration file (`~/.config/awesome/rc.lua` by default) in text editor.

2. Include required modules by adding the following strings to the beginning of configuration file:

```lua
-- My color schemes
local base16 = require("base16")
-- My wibars
local wibars = require("wibars")
local arrowlain = wibars.arrowlain
...
```

3. Find `awful.screen.connect_for_each_screen` function call and add code which will create wibar for each Awesome screen to the end of function initialized in parameters. It should look something like this:

```lua
awful.screen.connect_for_each_screen(function(s)
...
-- {{{ Code that you should add
    s.mywibox = arrowlain.wibar ({
	position 	= "bottom",
	visible   	= true,
	height   	= 16,
	screen 		= s,
	cs		= base16.solarized_dark,
	font   		= beautiful.font,
	direction 	= "left",
	spacer		= true,
	compact		= false
    })
-- }}}
end)
```

4. Restart Awesome.

### Configuring wibar

You can customize wibar creating code above to configure wibar appearance. Just change lua table item values proper way in `arrowlain.wibar` function call. If some value is omitted then default will be used. Description list of available options is here:

*  `position` (`top` or `bottom`, default is `bottom`) sets position of wibar on top or bottom of screen.
*  `visible` (`true` or `false`, default is `true`) sets wibar visibility on Awesome screens.
*  `height` (`*positive_number*`, default is `16`) sets wibar height counted from top or bottom screen border. I recommend to use default value if you don't want that wibar icons look ugly.
*  `screen` (`*awesome_screen*`, default is `awful.screen.focused()`) sets Awesome screen on which wibar will shown. If you create wibar for each screen in `awful.screen.connect_for_each_screen` function call then set this value equal to screen variable used in argument function (`s` above).
*  `cs` (`base16.*color_scheme_name*`, default is `base16.solarized_dark`) sets color scheme for wibar. 5 color schemes are available out of box: default light and dark, solarized light and dark, nord. You can add your own color scheme or import existing from [base16][] suite.
*  `font` (`*font_name_and_size*`, default is `xos4 Terminus 9`) sets font for wibar. It is highly recommended to use Terminus font otherwise it may happen that some widgets will show notifies in not right format. If you don't have Terminus font on your system you can [install one][Terminus] from ArchLinux repositories.
*  `direction` (`left` or `right`, default is `left`) sets arrow direction and align (opposite to value). 
*  `spacer` (`true` or `false`, default is `true`) sets spacer between arrow widgets, see [screenshots][].
*  `compact` (`true` or `false`, default is `false`) toggles compact mode, see [screenshots][].

### Configuring widgets

Depending on how your system is equipped (which software is installed) some widgets may show proper or "N/A" values. Showing "N/A" is normal behaviour for most cases and means that you need to install necessary utilities or configure widgets manually. But in some cases it may mean that your hardware doesn't support some features, for example you could have no hdd thermometer and therefore can't measure hdd temperature or if you have desktop computer you could have no battery which is the part of laptop. Also it may be that you just don't want to see some widgets on wibar. Any way you can switch off unwanted widgets. Section below describes how to do it.

#### Switching off unwanted widgets

Open `wibar.lua` configuration file (`~/.config/awesome/wibars/arrowlain/wibar.lua` by default) in text editor. Comment strokes in `factory` function which correspond creation of naked or wrapped in arrow (wrapped is better choice) widgets which you want to switch off. For example if you want to switch off battery widget you should comment stroke which wraps widget in arrow. Your comment should look something like this:

```lua
-- Battery
local nbattery = widgets.battery(widgetsettings)
-- local wbattery = arrow_wrapper(nbattery, cs.palette.barbg_violet, dir, margins.battery.left, margins.battery.right, spacer, cs.palette.barbg_yellow, false)	
```

Wrapped cpu, memory and hdd widgets consist of two naked widgets. First shows the load, second -- device temperature (it is a system chipset temperature in case of memory widget). For example if you want to switch off system chipset temperature widget but keep memory load widget you should comment stroke where naked system chipset temperature widget is created and corresponding stroke in lua table where it merges with memory load widget:

```lua
-- RAM and system temperature
local nram = widgets.ram(widgetsettings)
-- local nsystemp = widgets.systemp(widgetsettings)
local nramsys = wibox.widget {
    wibox.container.margin(nram, margins.ram.left, margins.ram.right),
--  wibox.container.margin(nsystemp, margins.systemp.left, margins.systemp.right),
    layout = wibox.layout.align.horizontal
}
local wramsys = arrow_wrapper(nramsys, cs.palette.barbg_orange, dir, margins.ramsys.left, margins.ramsys.right, spacer, cs.palette.barbg_green, false)	
```
Cpu and hdd temperature widgets can be switched off the same way.

You may want to switch off second mail widget if you have only one mailbox. In order to do this comment stroke where naked second mail widget is created and corresponding stroke in lua table where it merges with first mail widget:

```lua
-- IMAP mail
local nmail1 = widgets.mail(widgetsettings, secrets.mail1.account, secrets.mail1.password, 1)
-- local nmail2 = widgets.mail(widgetsettings, secrets.mail2.account, secrets.mail2.password, 0)
local nmail = wibox.widget {
    wibox.container.margin(nmail1, margins.mail1.left, margins.mail1.right),
--  wibox.container.margin(nmail2, margins.mail2.left, margins.mail2.right),
    layout = wibox.layout.align.horizontal
}
local wmail = arrow_wrapper(nmail, cs.palette.barbrbg, dir, margins.mail.left, margins.mail.right, spacer, "alpha", false)
```

#### Clock

This widget displays current date and time. Also it shows calendar on mouse hovering.

#### Weather

This widget shows short description of current weather condition on wibar and detailed (with forecast) on mouse hovering. It requires `curl` utility has been installed on system, that can be done with `pacman -S curl` command for ArchLinux, although `curl` is included in `base` package group and should be installed by default during the system installation.

Weather widget uses [OpenWeatherMap][] service to receive current weather condition and forecast. So OpenWeatherMap  API key is required. Widget already has one, but you can get yours and use it. Visit <https://openweathermap.org/appid> to get API key. Then change existing in `secrets.lua` configuration file (`~/.config/awesome/wibars/arrowlain/secrets.lua` by default):

```lua
-- OpenWeatherMap API key - https://openweathermap.org/appid
openweather_api_key = "*YOUR_API_KEY*",
```

In order to widget shows weather in your place you should change `city_id` in `weather.lua` configuration file (`~/.config/awesome/wibars/arrowlain/widgets/weather.lua` by default):

```lua
local weather = lainmod.widget.weather({
    APPID = secrets.openweather_api_key, 
    -- Novosibirsk	1496747
    -- Bratsk		2051523
    city_id = *your_city_id*,
    followtag = true,
    ...
})
```
To know your `city_id` visit <https://openweathermap.org/find>, name of your city in search field, tap Enter, choose your city from appeared list. `city_id` will the number in URL like this: `https://openweathermap.org/city/*2643743*`.

In compact mode widget uses glyph symbols to show current weather condition on wibar. You may need `Symbola` font to display it proper way. If you don't have Symbola font on your system you can [install one][Symbola] from AUR repository for ArchLinux.

#### Battery

It shows laptop battery status and popup messages when battery status has been changed. If you don't have a battery it may be useless. So you can switch it off, see [Switching off unwanted widgets][] section.

#### Volume

This widget shows current volume level on system. It requires `amixer` has been installed on system, that can be done with `pacman -S alsa-utils` command for ArchLinux. Also in order to have permission to mixer it may be required to add user to `audio` group, that can be done with `gpasswd -a *user_name* audio` command.

You can add Awesome key bindings to change volume level. In order to do this open Awesome `rc.lua` configuration file (`~/.config/awesome/rc.lua` by default) and add following strings to  `globalkeys = gears.table.join()` function call:

```lua
modkey	= "Mod4"
altkey	= "Mod1"
globalkeys = gears.table.join(
...
    -- ALSA volume control
    awful.key({ modkey, altkey }, "Up",
	function ()
	    os.execute(string.format("amixer -q set %s 5%%+", myvolume.channel))
	    myvolume.update()
	end,
	{description = "volume up", group = "Volume"}
    ),
    awful.key({ modkey, altkey }, "Down",
	function ()
	    os.execute(string.format("amixer -q set %s 5%%-", myvolume.channel))
	    myvolume.update()
	end,
	{description = "volume down", group = "Volume"}
    ),
    awful.key({}, "XF86AudioMute",
	function ()
	    os.execute(string.format("amixer -q set %s toggle", myvolume.togglechannel or myvolume.channel))
	    myvolume.update()
	end,
	{description = "mute toggle", group = "Volume"}
    ),
...
)
``` 

Now you can change volume level with Mod4-Alt-ArrowUp and Mod4-Alt-ArrowDown key combinations and mute with your keyboard MuteAudio key.

#### Keyboard layout

It shows current keyboard layout. Layout can be changed by clicking on widget.
You can bind CapsLock toggle to CapsLock key in your `rc.lua`
```
-- CapsLock handler
awful.key({}, "#66",
	function()
		capslock_toggle();
	end,
{description="CapsLock", group="awesome"}),
```

#### CPU

This widget shows CPU usage and temperature. You shouldn't have a problem with CPU usage unlike temperature. Original [lcpz/lain][] library uses `/sys/class/thermal/thermal_zone0/temp` system file to determine CPU temperature, but I was forced to change such behaviour because this file is responsible for virtual device temperature on my system. I prefer to use `lm_sensors` utility to determine device temperatures and it is required for cpu and memory widgets work proper way. You can install `lm_sensors` with `pacman -S lm_sensors` command for ArchLinux. Run `sensors` command in terminal to see which devices are available:

```shell
$ sensors
acpitz-virtual-0	# This is some thermometer device name
Adapter: Virtual device
temp1:        +60.0°C  (crit = +105.0°C)

k10temp-pci-00c3	# This is CPU thermometer device name
Adapter: PCI adapter
temp1:        +69.5°C  (high = +70.0°C)
```

Now you should change device name in Lain `cputemp.lua` configuration file (`~/.config/awesome/arrowlain/widgets/cputemp.lua` by default) in `factory` function to the one that corresponds your CPU:

```lua
local function factory(args)
mycputemp_widget.temp = lainmod.widget.cputemp( {
	dev = "k10temp-pci-00c3", -- change it according to your lm_sensors device
...
end
``` 

#### Memory and system chipset temperature

It shows memory usage and system chipset temperature. Everything that was said for [CPU temperature widget][CPU] is fair for this widget too. You should change device name in Lain `systemp.lua` configuration file (`~/.config/awesome/lainmod/widget/systemp.lua` by default) in `factory` function to the one that corresponds your system chipset or [switch off][Switching off unwanted widgets] chipset temperature widget if you don't have such sensor.

#### File system and HDD temperature

This widget shows `/` (by default) partition usage and HDD temperature on wibar. Detailed partitions usage is displayed on mouse hovering. To change partition showed on wibar :w
you should change value in `fs.lua` configuration file (`~/.config/awesome/wibars/arrowlain/widgets/fs.lua` by default):

```lua
widget:set_markup(markup.fontfg(font, fg, spacer .. string.format("%s", fs_now["*your_partition*"].percentage) .. "%"))
```

HDD temperature widget requires `hddtemp` and `GNU NetCat` utilities have been installed. You can do it with `pacman -S hddtemp gnu-netcat` command for ArchLinux. Also you need enable and start hddtemp systemd service with `systemctl enable hddtemp` and `systemctl start hddtemp` commands. If widget still doesn't work proper way you can switch it off, see [switching off unwanted widgets] section.

#### Net

It shows incoming and outcoming net traffic.

#### Mail

This widget shows unread messages in your mailboxes and open mailboxes in browser on mouse click. Also it shows popup messages when new mail is recieved.  It uses `curl` utility for recieving number of unread messages. You can install `curl` with `pacman -S curl` command for ArchLinux, although `curl` is included in `base` package group and should be installed by default during the system installation.
In order to widget works proper way you should enter mail accounts and passwords in `secrets.lua` configuration file (`~/.config/awesome/wibars/arrowlain/secrets.lua` by default):

```lua
-- Mail accounts
mail1 = {
    account  = "firts_mail@gmail.com",
    password = "first_mail_password"
},
mail2 = {
    account  = "second_mail@gmail.com",
    password = "second_mail_password"
}
```
You should also set `awful.util.browser` variable (in `rc.lua` eg) to value of your browser launch command (`"firefox"` eg):

```lua
awful.util.browser = "firefox"
```

Widget is configured by default to open GMail mailboxes in browser. To use another mail service you should change URL string in `mail.lua` configuration file (`~/.config/awesome/wibars/arrowlain/widgets/mail.lua`) in `om_table` function:

```lua
local function om_table (boxnumber)
    ...
    string.format("%s --target window https://mail.google.com/mail/u/%s/", browser, boxnumber)
    ...
end
```

If you have only one mailbox you may want to switch off second widget, see [switching off unwanted widgets][] section.

#### Bonus: Apache, MariaDB, php-fpm, Samba and QEMU

This naked (not wrapped in arrow) widgets show corresponding icons on wibar when Apache web server, MariaDB, php-fpm, Samba server or QEMU virtual machine is running.

#### Adding your widgets to wibar

You can add your widget (wrapped in arrow or naked) on wibar. Just add Lua variable is corresponding to widget in `wt` widget table in `wibar.lua` configuration file (`~/.config/awesome/wibars/arrowlain/wibar.lua` by default):

```lua
local wt = {
    ...
    *your_wrapped_widget*,
    ...
    *your_naked_widget*,
    ...
}
```
To wrap widget in arrow use `arrow_wrapper()` function in `wibar.lua` before adding widget to `wt` table:

```lua
local *wrapped_widget* = arrow_wrapper(*naked_widget*, *arrow_color*, dir, *left_margin*, *right_margin*, spacer, *next_arrow_color*, false)
```

## Troubleshooting

### Wibar takes to much space on screen (not all widgets fit on wibar)

Try to disable spacer between widgets and/or use compact mode, see [Configuring wibar][] section. Also [switch off unwanted widgets][Switching off unwanted widgets].

If you have any other issues and you can't find the answer in description above, please write me on kirill.bugaev87@gmail.com.

[lcpz/awesome-copycast]: https://github.com/lcpz/awesome-copycats
[Powerline]: https://github.com/powerline/powerline
[lcpz/lain]: https://github.com/lcpz/lain
[Terminus]: https://www.archlinux.org/packages/community/any/terminus-font/
[screenshots]: #Screenshots
[troubleshooting]: #Troubleshooting
[awesome-lainmod]: https://github.com/Kirill-Bugaev/awesome-lainmod
[awesome-base16]: https://github.com/Kirill-Bugaev/awesome-base16
[configuration]: #Configuration
[base16]: http://chriskempson.com/projects/base16/
[OpenWeatherMap]: https://openweathermap.org/
[Symbola]: https://aur.archlinux.org/packages/ttf-symbola/
[Switching off unwanted widgets]: #Switching-off-unwanted-widgets
[CPU]: #CPU
[Configuring wibar]: #Configuring-wibar


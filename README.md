# awesome-arrowlain-wibar
Wibar in arrow style with modified Lain widgets for Awesome WM

This project was inspired by [lcpz/awesome-copycast][] Powerarrow theme and Vim [Powerline][] plugin. It uses modified Lain library for Awesome WM, original can be found at [lcpz/lain][].

## Introduction

This wibar is an extension for Awesome WM which allows you to monitor system and hardware state, current weather and forecast, mailboxes, etc. See the [screenshots][] below for a demonstration of the wibar capabilities.

The most laborious part is configuring widgets is described in [configuration][] section.

See the [troubleshooting][] section if you're having any issues with the wibar. 

## Screenshots

![Screenshot of normal left solarized](https://github.com/Kirill-Bugaev/awesome-arrowlain-wibar/blob/master/screenshots/screenshot_normal_left_solarized.png)
![Screenshot of normal right nord](https://github.com/Kirill-Bugaev/awesome-arrowlain-wibar/blob/master/screenshots/screenshot_normal_right_nord.png)
![Screenshot of compact left default](https://github.com/Kirill-Bugaev/awesome-arrowlain-wibar/blob/master/screenshots/screenshot_compact_left_default.png)

## Installation

Clone current repository to temporary directory with `git clone https://github.com/Kirill-Bugaev/awesome-arrowlain-wibar.git`. Copy `base16`, `lainmod` and `wibars` directories from `awesome-arrowlain-wibar` directory to your Awesome WM configuration directory (`~/.config/awesome` by default).

## Configuration

### Adding wibar to Awesome WM screens

1. Open your Awesome WM lua configuration file (`~/.config/awesome/rc.lua` by default) in text editor.

2. Include required modules by adding the following strings to the beginning:

```lua
-- My color schemes
local base16 = require("base16")
-- My wibars
local wibars = require("wibars")
local arrowlain = wibars.arrowlain
```

3. Find `awful.screen.connect_for_each_screen` function call and add the code which will create wibar for each Awesome screen to the end of function described in parameters. It should look something like this:

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

You can customize wibar creating code above to configure wibar appearance. Just change lua table item values proper way in `arrowlain.wibar` function call. If some value is omitted then default will be used. Description list of available options is below:

*  `position` (`top` or `bottom`, default is `bottom`) set position of wibar on top or bottom of screen.
*  `visible` (`true` or `false`, default is `true`) set wibar visibility on Awesome screens.
*  `height` (`*positive_number*`, default is `16`) set wibar height counted from top or bottom screen border. Recommend to use default value if you don't want that wibar icons look ugly.
*  `screen` (`*awesome_screen*`, default is `awful.screen.focused()`) set Awesome screen on which wibar will shown. If you create wibar for each screen in `awful.screen.connect_for_each_screen` function call then set this value equal to screen variable used in argument function (`s` above).
*  `cs` (`base16.*color_scheme_name*`, default is `base16.solarized_dark`) set color scheme for wibar. 5 color schemes are available out of box: default light and dark, solarized light and dark, nord. You can add your own color scheme or import existing from [base16][] suite.
*  `font` (`*font_name_and_size*`, default is `xos4 Terminus 9`) set font for wibar. It is highly recommended to use Terminus font otherwise it may happen that some widgets will show notifies in not right format.
*  `direction` (`left` or `right`, default is `left`) set arrow direction and align is opposite to `direction` option value. 
*  `spacer` (`true` or `false`, default is `true`) set spacer between arrow widgets, see [screenshots][].
*  `compact` (`true` or `false`, default is `false`) toggle compact mode, see [screenshots][].

### Configuring widgets

Depending on how your system is equipped (which software is installed) some widgets may show "N/A" values. It is normal behaviour for most cases and means that you need to install necessary utilities or configure widgets manually in proper way. But in some cases it may mean that your hardware doesn't support some features, for example you could have no hdd thermometer and therefore can't measure hdd temperature or if you have desktop computer you could have no battery which is the part of laptop. Also it may be that you just don't want to see some widgets on wibar. Any way you can switch off unwanted widgets. Section below describes how to do it.

#### Switching off unwanted widgets

Open wibar lua configuration file (`~/.config/awesome/wibars/arrowlain/wibar.lua` by default) in text editor. Comment strokes (in `factory` function) which correspond creation of naked or wrapped in arrow (wrapped is better choice) widgets which you want to switch off. For example if you want to switch off battery widget you should comment stroke where widget is wrapped in arrow. Your comment should look something like this:

```lua
...
    -- Battery
    local nbattery = widgets.battery(widgetsettings)
--    local wbattery = arrow_wrapper(nbattery, cs.palette.barbg_violet, dir, margins.battery.left, margins.battery.right, spacer, cs.palette.barbg_yellow, false)	
...
```

Wrapped cpu, memory and hdd widgets consist of two naked widgets. First shows the load, second -- device temperature (it is a system chipset temperature in case of memory widget). For example if you want to switch off system chipset temperature widget but keep memory load widget you should comment stroke where naked system chipset temperature widget is created and corresponding stroke in lua table where it merges with memory load widget:

```lua
...
    -- RAM and system temperature
    local nram = widgets.ram(widgetsettings)
--    local nsystemp = widgets.systemp(widgetsettings)
    local nramsys = wibox.widget {
	wibox.container.margin(nram, margins.ram.left, margins.ram.right),
--	wibox.container.margin(nsystemp, margins.systemp.left, margins.systemp.right),
	layout = wibox.layout.align.horizontal
    }
    local wramsys = arrow_wrapper(nramsys, cs.palette.barbg_orange, dir, margins.ramsys.left, margins.ramsys.right, spacer, cs.palette.barbg_green, false)	
...
```
Cpu and hdd temperature widgets can be switched off the same way.

You may want to switch off second mail widget if you have only one mailbox. In order to do this comment stroke where naked second mail widget is created and corresponding stroke in lua table where it merges with first mail widget:

```lua
...
    -- IMAP mail
    local nmail1 = widgets.mail(widgetsettings, secrets.mail1.account, secrets.mail1.password, 1)
--    local nmail2 = widgets.mail(widgetsettings, secrets.mail2.account, secrets.mail2.password, 0)
    local nmail = wibox.widget {
	wibox.container.margin(nmail1, margins.mail1.left, margins.mail1.right),
--	wibox.container.margin(nmail2, margins.mail2.left, margins.mail2.right),
	layout = wibox.layout.align.horizontal
    }
    local wmail = arrow_wrapper(nmail, cs.palette.barbrbg, dir, margins.mail.left, margins.mail.right, spacer, "alpha", false)
...
```

#### Clock

This widget displays current date and time. Also it shows calendar on mouse hovering.

#### Weather

This widget shows short description of current weather condition on wibar and detailed (with forecast) on mouse hovering. It requires `curl` utility have been installed on system, that can be done with `pacman -S curl` for ArchLinux, although `curl` is included in `base` package group and should be installed by default during the system installation.

Weather widget uses [OpenWeatherMap][] service to receive current weather condition and forecast. So OpenWeatherMap  API key is required. Widget already has one, but you can get yours and use it. Visit <https://openweathermap.org/appid> to get API key. Then change existing in `secrets.lua` configuration file (`~/.config/awesome/wibars/arrowlain/secrets.lua` by default):

```lua
...
    -- OpenWeatherMap API key - https://openweathermap.org/appid
    openweather_api_key = "*YOUR_API_KEY*",
...
```

In order to widget shows weather in your place you should change `city_id` in `weather.lua` configuration file (`~/.config/awesome/wibars/arrowlain/widgets/weather.lua` by default):

```lua
...
    local weather = lainmod.widget.weather({
        -- Novosibirsk	1496747
        -- Bratsk	2051523
	APPID = secrets.openweather_api_key, 
        city_id = *YOUR_CITY_ID*,
        followtag = true,
...
```
To know your `city_id` visit <https://openweathermap.org/find>, enter your city name in search field, tap Enter, choose your city from appeared list. `city_id` will the number in URL like this: `https://openweathermap.org/city/*2643743*`.

### Battery

This widget shows laptop battery status. If you don't have battery it may be useless. So you can switch it off. See [Switching off unwanted widgets][] section.

## Troubleshooting


[lcpz/awesome-copycast]: https://github.com/lcpz/awesome-copycats
[Powerline]: https://github.com/powerline/powerline
[lcpz/lain]: https://github.com/lcpz/lain
[screenshots]: #Screenshots
[troubleshooting]: #Troubleshooting
[configuration]: #Configuration
[base16]: http://chriskempson.com/projects/base16/
[OpenWeatherMap]: https://openweathermap.org/
[Switching off unwanted widgets]: #Switching-off-unwanted-widgets

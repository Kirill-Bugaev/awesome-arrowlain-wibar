# awesome-arrowlain-wibar
Wibar in arrow style with modified Lain widgets for Awesome WM

This project was inspired by [lcpz/awesome-copycast][] Powerarrow theme and Vim [Powerline][] plugin. It uses modified Lain library for Awesome WM, original can be found at [lcpz/lain][].

### Introduction

This wibar is an extension for Awesome WM which allows you to monitor system and hardware state, current weather and forecast, mailboxes, etc. See the [screenshots][] below for a demonstration of the wibar capabilities.

The most laborious part is configuring widgets is described in [configuration][] section.

See the [troubleshooting][] section if you're having any issues with the wibar. 

### Screenshots

![Screenshot of normal left solarized](https://github.com/Kirill-Bugaev/awesome-arrowlain-wibar/blob/master/screenshots/screenshot_normal_left_solarized.png)
![Screenshot of normal right nord](https://github.com/Kirill-Bugaev/awesome-arrowlain-wibar/blob/master/screenshots/screenshot_normal_right_nord.png)
![Screenshot of compact left default](https://github.com/Kirill-Bugaev/awesome-arrowlain-wibar/blob/master/screenshots/screenshot_compact_left_default.png)

### Installation

Clone current repository to temporary directory with `git clone https://github.com/Kirill-Bugaev/awesome-arrowlain-wibar.git`. Copy `base16`, `lainmod` and `wibars` directories from `awesome-arrowlain-wibar` directory to your Awesome WM configuration directory (`~/.config/awesome` by default).

### Configuration

#### Adding wibar to Awesome WM screens

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

#### Configuring wibar

You can customize wibar creating code above to configure wibar appearance. Just change lua table item values proper way in `arrowlain.wibar` function call. If some value is omitted then default will be used. Description list of available options is below:

*  `position` (possible values are `top` or `bottom`, default is `bottom`) set position of wibar on top or bottom of screen.
*  `visible` (possible values are `true` or `false`, default is `true`) set wibar visibility on Awesome screens.
*  `height` (possible value is `*any_positive_number*`, default is `16`) set wibar height counted from top or bottom screen border. Recommend to use default value if you don't want that wibar icons look ugly.
*  `screen` (possible value is `*awesome_screen*`, default is `awful.screen.focused()`) set Awesome screen on which wibar will shown. If you create wibar for each screen in `awful.screen.connect_for_each_screen` function call then set this value equal to screen variable used in argument function (`s` above).
*  `cs` (possible value is `base16.*color_scheme_name*`, default is `base16.solarized_dark`) set color scheme for wibar. 5 color schemes are available out of box: default light and dark, solarized light and dark, nord. You can add your own color scheme or import existing from [base16][] suite.
*  `font` (possible value is `*any_font_name_and_size*`, default is `xos4 Terminus 9`) set font for wibar. It is highly recommended to use Terminus font otherwise it may happen that some widgets will show notifies in not right format.
*  `direction` (possible values are `left` or `right`, default is `left`) set arrow direction and align is opposite to `direction` option value. 
*  `spacer` (possible values are `true` or `false`, default is `true`) set spacer between arrow widgets, see [screenshots][].
*  `compact` (possible values are `true` or `false`, default is `false`) toggle compact mode, see [screenshots][].

### Troubleshooting


[lcpz/awesome-copycast]: https://github.com/lcpz/awesome-copycats
[Powerline]: https://github.com/powerline/powerline
[lcpz/lain]: https://github.com/lcpz/lain
[screenshots]: #Screenshots
[troubleshooting]: #Troubleshooting
[configuration]: #Configuration
[base16]: http://chriskempson.com/projects/base16/


--[[

     net widget for arrow lain wibar 

--]]

local wibox 	= require("wibox")
local lainmod  	= require("lainmod")
local base16	= require("base16")

local markup = lainmod.util.markup

local function factory (args)

    local font 		= args.font or "xos4 Terminus 9"
    local cs   		= args.cs or base16.solarized_dark
    local spacer	= args.spacer or " "
    local compact	= args.compact
    if compact then spacer = "" end

    local fg   		= cs.palette.barfg
    local icon_net	= cs.paths.lainicons .. "net.png"

    local neticon = wibox.widget.imagebox(icon_net)
    if compact then neticon = nil end
    local net = lainmod.widget.net({
        settings = function(widget, net_now)
            widget:set_markup(markup.fontfg(font, fg, spacer .. math.floor(net_now.received + 0.5) .. "K" .. spacer .. "↓↑" .. spacer .. math.floor(net_now.sent + 0.5) .. "K"))
        end
    })

    local widget = wibox.widget {
	neticon,
	net,
	layout = wibox.layout.align.horizontal
    }

    return widget

end

return factory

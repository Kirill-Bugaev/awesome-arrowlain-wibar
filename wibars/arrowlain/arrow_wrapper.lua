--[[

     Arrow wrapper for widgets
     (c)2018 Kirill Bugaev

--]]

local lainmod = require("lainmod")
local wibox   = require("wibox")

local separators = lainmod.util.separators

local function arrow_wrapper(widget, color, dir, margin_left, margin_right, spacer, next_color, force_tail)
	local left_nc, right_nc
	if spacer then
		left_nc = "alpha"
		right_nc = "alpha"
	else
		if dir == "right" then
			left_nc = "alpha"
			right_nc = next_color
		else
			left_nc = next_color
			right_nc = "alpha"
		end
	end

	local leftarrow, rightarrow
	if dir == "right" then
		rightarrow = separators.arrow_right
		if spacer or force_tail then
			leftarrow = separators.arrow_right
		else
			leftarrow = function() return nil end
		end
	else
		leftarrow = separators.arrow_left
		if spacer or force_tail then
			rightarrow = separators.arrow_left
		else
			rightarrow = function() return nil end
		end
	end

	local wraped = wibox.widget {
		leftarrow(left_nc, color),
		wibox.container.background (
			wibox.container.margin(widget, margin_left, margin_right),
			color
		) ,
		rightarrow(color, right_nc),
		layout = wibox.layout.align.horizontal
	}

	return wraped
end

local function factory(...)
	return arrow_wrapper(...)
end

return factory

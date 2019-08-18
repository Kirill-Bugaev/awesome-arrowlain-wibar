--[[

     Make single widget from table of widgets
     (c)2018 Kirill Bugaev

--]]

local wibox = require("wibox")

-- awesome v4.2 wibox.widget can make single widget from first 3 widgets only in table argument
-- so need to wrap widgets recursively to create single
local function make_single(wt)
	local wt_with_layout = {}

	if #wt <= 3 then
		wt_with_layout = wt
	else
		local wn = math.floor(#wt / 3)
		if #wt % 3 ~= 0 then wn = wn + 1 end

		local new_wt = {}
		for i = 1,wn,1 do
			table.insert(new_wt, wt[i])
		end
		local w1 = make_single(new_wt)

		new_wt = {}
		for i = wn+1, wn*2, 1 do
			table.insert(new_wt, wt[i])
		end
		local w2 = make_single(new_wt)

		new_wt = {}
		for i = 2*wn+1, #wt, 1 do
			table.insert(new_wt, wt[i])
		end
		local w3 = make_single(new_wt)

		table.insert(wt_with_layout, w1)
		table.insert(wt_with_layout, w2)
		table.insert(wt_with_layout, w3)
	end

	wt_with_layout.layout = wibox.layout.align.horizontal
	return wibox.widget(wt_with_layout)
end

local function factory(...)
	return make_single(...)
end

return factory

--[[

     Margins for arrowlain wibar widgets
     (c)2018 Kirill Bugaev

--]]

local margins = {
	clock = {
		left = 3,
		right = 8
	},
	weather = {
		left = 4,
		right = 8
	},
	battery = {
		left = 3,
		right = 8
	},
	volume = {
		left = 3,
		right = 8
	},
	kblayout = {
		left = 4,
		right = 2
	},
	cpuload = {
		left = 0,
		right = 0
	},
	cputemp = {
		left = 8,
		right = 0
	},
	cpu = {
		left = 4,
		right = 8
	},
	ram = {
		left = 0,
		right = 0
	},
	systemp = {
		left = 8,
		right = 0
	},
	ramsys = {
		left = 4,
		right = 8
	},
	fs = {
		left = 0,
		right = 0
	},
	hddtemp = {
		left = 8,
		right = 0
	},
	fshdd = {
		left = 4,
		right = 8
	},
	net = {
		left = 4,
		right = 8
	},
	mail1 = {
		left = 0,
		right = 0
	},
	mail2 = {
		left = 10,
		right = 0
	},
	mail = {
		left = 4,
		right = 8
	},
	between_naked = {
		left = 0,
		right = 5
	}
}

local function factory()
	return margins
end

return factory()

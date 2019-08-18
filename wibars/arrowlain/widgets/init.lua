--[[

     widgets for arrow lain wibar

     Licensed under GNU General Public License v2
      * (c) 2018, Kirill Bugaev

--]]

local wrequire     = require("lainmod.helpers").wrequire
local setmetatable = setmetatable

local widgets = { _NAME = "wibars.arrowlain.widgets" }

return setmetatable(widgets, { __index = wrequire })

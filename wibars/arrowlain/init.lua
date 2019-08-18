--[[

     arrow lain wibar

     Licensed under GNU General Public License v2
      * (c) 2018, Kirill Bugaev

--]]

local wrequire     = require("lainmod.helpers").wrequire
local setmetatable = setmetatable

local arrowlain = { _NAME = "wibars.arrowlain" }

return setmetatable(arrowlain, { __index = wrequire })


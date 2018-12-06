--[[

     Wibars for Awesome WM

     Licensed under GNU General Public License v2
      * (c) 2018, Kirill Bugaev

--]]

local wrequire     = require("lainmod.helpers").wrequire
local setmetatable = setmetatable

local wibars = { _NAME = "wibars" } 

return setmetatable(wibars, { __index = wrequire })

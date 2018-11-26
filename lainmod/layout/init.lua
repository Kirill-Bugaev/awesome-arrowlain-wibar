--[[

     Lain
     Layouts, widgets and utilities for Awesome WM

     Layouts section

     Licensed under GNU General Public License v2
      * (c) 2013,      Luca CPZ
      * (c) 2010-2012, Peter Hofmann

--]]

local wrequire     = require("lainmod.helpers").wrequire
local setmetatable = setmetatable

local layout       = { _NAME = "lainmod.layout" }

return setmetatable(layout, { __index = wrequire })

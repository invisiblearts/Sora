-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Variables
if not C.ActionBar then
    C.ActionBar = {}
end

C.ActionBar = {}
C.ActionBar.Size = 42
C.ActionBar.Space = 8
C.ActionBar.MainBarPostion = {"BOTTOM", UIParent, 0, 8}
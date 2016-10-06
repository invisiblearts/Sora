-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Variables
if not C.UnitFrame then
    C.UnitFrame = {}
end

C.MiniMap = {}
C.MiniMap.Width = 148
C.MiniMap.Height = 148
C.MiniMap.BarHeight = 6
C.MiniMap.Postion = {"TOPLEFT", UIParent, 8, -8}

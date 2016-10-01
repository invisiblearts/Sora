-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local Parent = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
Parent:SetPoint("BOTTOM", 0, 250)
Parent:SetSize(ExtraActionBarFrame:GetSize())

-- 设置额外动作条
ExtraActionBarFrame:ClearAllPoints()
ExtraActionBarFrame:SetParent(Parent)
ExtraActionBarFrame:EnableMouse(false)
ExtraActionBarFrame:SetPoint("CENTER", 0, 0)
ExtraActionBarFrame.ignoreFramePositionManager = true

-- 设置动作条驱动状态
RegisterStateDriver(Parent, "visibility", "[petbattle][overridebar][vehicleui] hide; show")

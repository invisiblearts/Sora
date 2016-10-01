-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local LeftSide = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
LeftSide:SetPoint("LEFT", 8, 0)
LeftSide:SetSize(C.ActionBar.Size, C.ActionBar.Size*12 + C.ActionBar.Space*11)
local RightSide = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
RightSide:SetPoint("RIGHT", -8, 0)
RightSide:SetSize(C.ActionBar.Size, C.ActionBar.Size*12 + C.ActionBar.Space*11)

-- 设置左动作条布局
MultiBarLeft:SetParent(LeftSide)
MultiBarLeft:EnableMouse(false)
for i = 1, NUM_ACTIONBAR_BUTTONS do
	local Button = _G["MultiBarLeftButton"..i]
	Button:ClearAllPoints()
	Button:SetSize(C.ActionBar.Size, C.ActionBar.Size)

	if i == 1 then
		Button:SetPoint("TOP", LeftSide, 0, 0)
	else
		Button:SetPoint("TOP", _G["MultiBarLeftButton" .. i-1], "BOTTOM", 0, -C.ActionBar.Space)
	end
end

-- 设置右动作条布局
MultiBarRight:SetParent(RightSide)
MultiBarRight:EnableMouse(false)
for i = 1, NUM_ACTIONBAR_BUTTONS do
	local Button = _G["MultiBarRightButton"..i]
	Button:ClearAllPoints()
	Button:SetSize(C.ActionBar.Size, C.ActionBar.Size)

	if i == 1 then
		Button:SetPoint("TOP", RightSide, 0, 0)
	else
		Button:SetPoint("TOP", _G["MultiBarRightButton" .. i-1], "BOTTOM", 0, -C.ActionBar.Space)
	end
end

-- 设置动作条驱动状态
RegisterStateDriver(LeftSide, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
RegisterStateDriver(RightSide, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
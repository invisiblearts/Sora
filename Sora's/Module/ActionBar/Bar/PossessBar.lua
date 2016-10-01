-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local Parent = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
Parent:SetHeight(C.ActionBar.Size)
Parent:SetWidth(C.ActionBar.Size*NUM_STANCE_SLOTS + C.ActionBar.Space*(NUM_STANCE_SLOTS-1))
Parent:SetPoint("BOTTOMLEFT", _G["MultiBarBottomRightButton1"], "TOPLEFT", 0, C.ActionBar.Space)

-- 设置Possess栏布局
PossessBarFrame:SetParent(Parent)
PossessBarFrame:EnableMouse(false)
for i = 1, NUM_POSSESS_SLOTS do
	local Button = _G["PossessButton"..i]
	Button:ClearAllPoints()
	Button:SetSize(C.ActionBar.Size, C.ActionBar.Size)

	if i == 1 then
		Button:SetPoint("BOTTOMLEFT", Parent)
	else
		Button:SetPoint("LEFT", _G["PossessButton"..i-1], "RIGHT", C.ActionBar.Space, 0)
	end
end

-- 设置动作条驱动状态
RegisterStateDriver(Parent, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
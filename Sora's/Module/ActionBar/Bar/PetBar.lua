-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local Parent = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
Parent:SetHeight(C.ActionBar.Size)
Parent:SetWidth(C.ActionBar.Size*NUM_PET_ACTION_SLOTS + C.ActionBar.Space*(NUM_PET_ACTION_SLOTS-1))
Parent:SetPoint("BOTTOMLEFT", _G["MultiBarBottomLeftButton6"], "TOPLEFT", 0, C.ActionBar.Space)

-- 设置宠物栏布局
PetActionBarFrame:SetParent(Parent)
PetActionBarFrame:EnableMouse(false)
for i = 1, NUM_PET_ACTION_SLOTS do
	local Button = _G["PetActionButton"..i]
	Button:ClearAllPoints()
	Button:SetSize(C.ActionBar.Size, C.ActionBar.Size)

	if i == 1 then
		Button:SetPoint("LEFT", Parent, 0, 0)
	else
		Button:SetPoint("LEFT", _G["PetActionButton"..i-1], "RIGHT", C.ActionBar.Space, 0)
	end
end

-- 设置宠物栏驱动状态
RegisterStateDriver(Parent, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; [@pet,exists,nomounted] show; hide")
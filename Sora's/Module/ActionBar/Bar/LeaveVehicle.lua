-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local Parent = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
Parent:SetPoint("TOPLEFT", ActionButton8, 0, 0)
Parent:SetPoint("BOTTOMRIGHT", ActionButton8, 0, 0)

-- 设置离开载具按钮
local Button = CreateFrame("BUTTON", "rABS_LeaveVehicleButton", Parent, "SecureHandlerClickTemplate, SecureHandlerStateTemplate");
Button:SetAllPoints()
Button:RegisterForClicks("AnyUp")
Button:SetScript("OnClick", VehicleExit)

Button:SetNormalTexture("INTERFACE\\PLAYERACTIONBARALT\\NATURAL")
Button:SetPushedTexture("INTERFACE\\PLAYERACTIONBARALT\\NATURAL")
Button:SetHighlightTexture("INTERFACE\\PLAYERACTIONBARALT\\NATURAL")
Button:GetHighlightTexture():SetBlendMode("ADD")
Button:GetNormalTexture():SetTexCoord(0.0859375, 0.1679688, 0.359375, 0.4414063)
Button:GetPushedTexture():SetTexCoord(0.001953125, 0.08398438, 0.359375, 0.4414063)
Button:GetHighlightTexture():SetTexCoord(0.6152344, 0.6972656, 0.359375, 0.4414063)

Button.Shadow = S.MakeShadow(Button, 2)

-- 设置动作条驱动状态
RegisterStateDriver(Parent, "visibility", "[petbattle] hide; show")
RegisterStateDriver(Button, "visibility", "[petbattle] hide; [overridebar][vehicleui][possessbar][@vehicle,exists] show; hide")

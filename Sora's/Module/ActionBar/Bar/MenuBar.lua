-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local Parent = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
Parent:Hide()

for _, name in pairs(MICRO_BUTTONS) do
	local Button = _G[name]

	if Button then
		Button:SetParent(Parent)
	end
end

CharacterMicroButton:ClearAllPoints();
PetBattleFrame.BottomFrame.MicroButtonFrame:SetScript("OnShow", nil)

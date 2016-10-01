-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local Parent = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
Parent:Hide()

CharacterBag0Slot:SetParent(Parent)
CharacterBag1Slot:SetParent(Parent)
CharacterBag2Slot:SetParent(Parent)
CharacterBag3Slot:SetParent(Parent)
MainMenuBarBackpackButton:SetParent(Parent)
MainMenuBarBackpackButton:ClearAllPoints()

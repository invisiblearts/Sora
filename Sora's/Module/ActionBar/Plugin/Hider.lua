local pastebin = CreateFrame("Frame")
pastebin:Hide()
MainMenuBar:SetParent(pastebin)
MainMenuBarPageNumber:SetParent(pastebin)
ActionBarDownButton:SetParent(pastebin)
ActionBarUpButton:SetParent(pastebin)
OverrideActionBarExpBar:SetParent(pastebin)
OverrideActionBarHealthBar:SetParent(pastebin)
OverrideActionBarPowerBar:SetParent(pastebin)
OverrideActionBarPitchFrame:SetParent(pastebin)

StanceBarLeft:SetTexture(nil)
StanceBarMiddle:SetTexture(nil)
StanceBarRight:SetTexture(nil)
SlidingActionBarTexture0:SetTexture(nil)
SlidingActionBarTexture1:SetTexture(nil)
PossessBackground1:SetTexture(nil)
PossessBackground2:SetTexture(nil)

MainMenuBarTexture0:SetTexture(nil)
MainMenuBarTexture1:SetTexture(nil)
MainMenuBarTexture2:SetTexture(nil)
MainMenuBarTexture3:SetTexture(nil)
MainMenuBarLeftEndCap:SetTexture(nil)
MainMenuBarRightEndCap:SetTexture(nil)

local textureList =  {
	"_BG",
	"EndCapL",
	"EndCapR",
	"_Border",
	"Divider1",
	"Divider2",
	"Divider3",
	"ExitBG",
	"MicroBGL",
	"MicroBGR",
	"_MicroBGMid",
	"ButtonBGL",
	"ButtonBGR",
	"_ButtonBGMid",
}

for _,tex in pairs(textureList) do
	OverrideActionBar[tex]:SetAlpha(0)
end
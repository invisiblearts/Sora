local _, private = ...

-- [[ Lua Globals ]]
local _G = _G

-- [[ Core ]]
local _, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	if _G.AuroraConfig.enableFont then
		local locale = _G.GetLocale()
		local font = C.media.font

		_G.RaidWarningFrame.slot1:SetFont(font, 20, "OUTLINE")
		_G.RaidWarningFrame.slot2:SetFont(font, 20, "OUTLINE")
		_G.RaidBossEmoteFrame.slot1:SetFont(font, 20, "OUTLINE")
		_G.RaidBossEmoteFrame.slot2:SetFont(font, 20, "OUTLINE")

		_G.STANDARD_TEXT_FONT = font
		_G.UNIT_NAME_FONT     = font
		_G.DAMAGE_TEXT_FONT   = font

		_G.AchievementFont_Small:SetFont(font, 10)
		_G.AchievementFont_Small:SetShadowColor(0, 0, 0)
		_G.AchievementFont_Small:SetShadowOffset(1, -1)
		_G.CoreAbilityFont:SetFont(font, 32)
		_G.CoreAbilityFont:SetShadowColor(0, 0, 0)
		_G.CoreAbilityFont:SetShadowOffset(1, -1)
		_G.DestinyFontHuge:SetFont(font, 32)
		_G.DestinyFontHuge:SetShadowColor(0, 0, 0)
		_G.DestinyFontHuge:SetShadowOffset(1, -1)
		_G.DestinyFontLarge:SetFont(font, 18)
		_G.DestinyFontLarge:SetShadowColor(0, 0, 0)
		_G.DestinyFontLarge:SetShadowOffset(1, -1)
		_G.FriendsFont_Normal:SetFont(font, 12)
		_G.FriendsFont_Small:SetFont(font, 10)
		_G.FriendsFont_Large:SetFont(font, 14)
		_G.FriendsFont_UserText:SetFont(font, 11)
		_G.GameFont_Gigantic:SetFont(font, 32)
		_G.GameTooltipHeader:SetFont(font, 14)
		_G.GameTooltipHeader:SetShadowColor(0, 0, 0)
		_G.GameTooltipHeader:SetShadowOffset(1, -1)
		_G.InvoiceFont_Small:SetFont(font, 10)
		_G.InvoiceFont_Small:SetShadowColor(0, 0, 0)
		_G.InvoiceFont_Small:SetShadowOffset(1, -1)
		_G.InvoiceFont_Med:SetFont(font, 12)
		_G.InvoiceFont_Med:SetShadowColor(0, 0, 0)
		_G.InvoiceFont_Med:SetShadowOffset(1, -1)
		_G.MailFont_Large:SetFont(font, 15)
		_G.NumberFont_GameNormal:SetFont(font, 10)
		_G.NumberFont_OutlineThick_Mono_Small:SetFont(font, 12, "OUTLINE")
		_G.NumberFont_Outline_Huge:SetFont(font, 30, "OUTLINE")
		_G.NumberFont_Outline_Large:SetFont(font, 16, "OUTLINE")
		_G.NumberFont_Outline_Med:SetFont(font, 14, "OUTLINE")
		_G.NumberFont_Shadow_Med:SetFont(font, 14)
		_G.NumberFont_Shadow_Small:SetFont(font, 12)
		_G.QuestFont_Shadow_Small:SetFont(font, 14)
		_G.QuestFont_Large:SetFont(font, 15)
		_G.QuestFont_Large:SetShadowColor(0, 0, 0)
		_G.QuestFont_Large:SetShadowOffset(1, -1)
		_G.QuestFont_Shadow_Huge:SetFont(font, 17)
		_G.QuestFont_Huge:SetFont(font, 18)
		_G.QuestFont_Super_Huge:SetFont(font, 24)
		_G.QuestFont_Super_Huge:SetShadowColor(0, 0, 0)
		_G.QuestFont_Super_Huge:SetShadowOffset(1, -1)
		if locale ~= "zhCN" and locale ~= "zhTW" then -- I don't even know
			_G.QuestFont_Enormous:SetFont(font, 30)
			_G.QuestFont_Enormous:SetShadowOffset(1, -1)
		end
		_G.ReputationDetailFont:SetFont(font, 10)
		_G.SpellFont_Small:SetFont(font, 10)
		_G.SpellFont_Small:SetShadowColor(0, 0, 0)
		_G.SpellFont_Small:SetShadowOffset(1, -1)
		_G.SystemFont_InverseShadow_Small:SetFont(font, 10)
		_G.SystemFont_Large:SetFont(font, 16)
		_G.SystemFont_Large:SetShadowColor(0, 0, 0)
		_G.SystemFont_Large:SetShadowOffset(1, -1)
		_G.SystemFont_Huge1:SetFont(font, 20)
		_G.SystemFont_Huge1:SetShadowColor(0, 0, 0)
		_G.SystemFont_Huge1:SetShadowOffset(1, -1)
		_G.SystemFont_Med1:SetFont(font, 12)
		_G.SystemFont_Med1:SetShadowColor(0, 0, 0)
		_G.SystemFont_Med1:SetShadowOffset(1, -1)
		_G.SystemFont_Med2:SetFont(font, 13)
		_G.SystemFont_Med2:SetShadowColor(0, 0, 0)
		_G.SystemFont_Med2:SetShadowOffset(1, -1)
		_G.SystemFont_Med3:SetFont(font, 14)
		_G.SystemFont_Med3:SetShadowColor(0, 0, 0)
		_G.SystemFont_Med3:SetShadowOffset(1, -1)
		_G.SystemFont_OutlineThick_WTF:SetFont(font, 32, "THICKOUTLINE")
		_G.SystemFont_OutlineThick_Huge2:SetFont(font, 22, "THICKOUTLINE")
		_G.SystemFont_OutlineThick_Huge4:SetFont(font, 26, "THICKOUTLINE")
		_G.SystemFont_Outline_Small:SetFont(font, 10, "OUTLINE")
		_G.SystemFont_Outline:SetFont(font, 13, "OUTLINE")
		_G.SystemFont_Shadow_Large:SetFont(font, 16)
		_G.SystemFont_Shadow_Large_Outline:SetFont(font, 16)
		_G.SystemFont_Shadow_Large2:SetFont(font, 18)
		_G.SystemFont_Shadow_Med1:SetFont(font, 12)
		_G.SystemFont_Shadow_Med1_Outline:SetFont(font, 12, "OUTLINE")
		_G.SystemFont_Shadow_Med2:SetFont(font, 13)
		_G.SystemFont_Shadow_Med3:SetFont(font, 14)
		_G.SystemFont_Shadow_Outline_Huge2:SetFont(font, 22, "OUTLINE")
		_G.SystemFont_Shadow_Huge1:SetFont(font, 20)
		_G.SystemFont_Shadow_Huge2:SetFont(font, 24)
		_G.SystemFont_Shadow_Huge3:SetFont(font, 25)
		_G.SystemFont_Shadow_Small:SetFont(font, 10)
		_G.SystemFont_Shadow_Small2:SetFont(font, 11)
		_G.SystemFont_Small:SetFont(font, 10)
		_G.SystemFont_Small:SetShadowColor(0, 0, 0)
		_G.SystemFont_Small:SetShadowOffset(1, -1)
		_G.SystemFont_Small2:SetFont(font, 11)
		_G.SystemFont_Small2:SetShadowColor(0, 0, 0)
		_G.SystemFont_Small2:SetShadowOffset(1, -1)
		_G.SystemFont_Tiny:SetFont(font, 9)
		_G.SystemFont_Tiny:SetShadowColor(0, 0, 0)
		_G.SystemFont_Tiny:SetShadowOffset(1, -1)
		_G.Tooltip_Med:SetFont(font, 12)
		_G.Tooltip_Med:SetShadowColor(0, 0, 0)
		_G.Tooltip_Med:SetShadowOffset(1, -1)
		_G.Tooltip_Small:SetFont(font, 10)
		_G.Tooltip_Small:SetShadowColor(0, 0, 0)
		_G.Tooltip_Small:SetShadowOffset(1, -1)

		-- Why?
		_G.HelpFrameKnowledgebaseNavBarHomeButtonText:SetFont(font, 12)
		_G.WorldMapFrameNavBarHomeButtonText:SetFont(font, 12)
	end
end)

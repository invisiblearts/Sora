local ADDON_NAME, ns = ...

local _, _G = _, _G
local prev_itemID, prev_numlines

local types = {
	unit = "NPC ID:",
	item = "ItemID:",
	spell = "SpellID:",
	quest = "QuestID:",
	talent = "TalentID:",
	ability = "AbilityID:",
	currency = "CurrencyID:",
	achievement = "AchievementID:"
}

local function addLine(tooltip, id, type)
	local numlines, found = tooltip:NumLines()
	if (type == "ItemID:") then
		local itemType = select(6, GetItemInfo(id))
		if (itemType == TRADESKILL_SERVICE_LEARN) then
			if (not prev_numlines or numlines < prev_numlines) then
				found = true
			end
			if (not prev_itemID or prev_itemID ~= id) then
				found = true
			end
			prev_itemID = id
			prev_numlines = numlines
		end
	end

	if (not found) then
		for i = 3, numlines do
			local frame = _G[tooltip:GetName() .. "TextLeft" .. i]
			local text
			if (frame) then text = frame:GetText() end
			if (not text) then break end
			if (strfind(text, type)) then found = true break end
		end
	end

	if (not found) then
		tooltip:AddLine(type .. " |cffffffff" .. id)
		tooltip:Show()
	end
end
ns.addLine = addLine

-- All types, primarily for detached tooltips
local function onSetHyperlink(self, link)
	local type, id = strmatch(link,"^(%a+):(%d+)")
	if (not type or not id) then return end
	if (type == "spell" or type == "enchant" or type == "trade") then
		addLine(self, id, types.spell)
	elseif (type == "talent") then
		addLine(self, id, types.talent)
	elseif (type == "quest") then
		addLine(self, id, types.quest)
	elseif (type == "achievement") then
		addLine(self, id, types.achievement)
	elseif (type == "item") then
		addLine(self, id, types.item)
	elseif (type == "currency") then
		addLine(self, id, types.currency)
	end
end
ns.onSetHyperlink = onSetHyperlink

hooksecurefunc(ItemRefTooltip, "SetHyperlink", onSetHyperlink)
hooksecurefunc(GameTooltip, "SetHyperlink", onSetHyperlink)

-- Spells
local hex, unitColor = ns.hex, ns.unitColor
local UnitAura, UnitBuff, UnitDebuff = UnitAura, UnitBuff, UnitDebuff

local function addAuraInfo(self, caster, spellID)
	if (not (caster or spellID)) then return end
	if (spellID) then
		addLine(self, spellID, types.spell)
	end
	if (caster) then
		local color = hex(unitColor(caster))
		GameTooltip:AddLine("CastBy: "..color..UnitName(caster))
	end
	GameTooltip:Show()
end

hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
	local _,_,_,_,_,_,_, caster,_,_, spellID = UnitAura(...)
	addAuraInfo(self, caster, spellID)
end)

hooksecurefunc(GameTooltip, "SetUnitBuff", function(self,...)
	local _,_,_,_,_,_,_, caster,_,_, spellID = UnitBuff(...)
	addAuraInfo(self, caster, spellID)
end)

hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
	local _,_,_,_,_,_,_, caster,_,_, spellID = UnitDebuff(...)
	addAuraInfo(self, caster, spellID)
end)

hooksecurefunc("SetItemRef", function(link, ...)
	local id = tonumber(link:match("spell:(%d+)"))
	if (id) then addLine(ItemRefTooltip, id, types.spell) end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local id = select(3, self:GetSpell())
	if (id) then addLine(self, id, types.spell) end
end)

-- Items
local function attachItemTooltip(self)
	local link = select(2, self:GetItem())
	if (link) then
		local id = strmatch(link, "item:(%d*)")
		if ((id == "" or id == "0") and TradeSkillFrame ~= nil and TradeSkillFrame:IsVisible() and GetMouseFocus().reagentIndex) then
			local selectedRecipe = TradeSkillFrame.RecipeList:GetSelectedRecipeID()
			for i = 1, 8 do
				if (GetMouseFocus().reagentIndex == i) then
					id = C_TradeSkillUI.GetRecipeReagentItemLink(selectedRecipe, i):match("item:(%d+):") or nil
					break
				end
			end
		end
		if (id and id ~= "" and id ~= "0") then
			addLine(self, id, types.item)
		end
	end
end

GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)

-- Achievement Frame Tooltips
local f = CreateFrame("frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, addon)
	if (addon == "Blizzard_AchievementUI") then
		for i,button in ipairs(AchievementFrameAchievementsContainer.buttons) do
			button:HookScript("OnEnter", function()
				GameTooltip:SetOwner(button, "ANCHOR_NONE")
				GameTooltip:SetPoint("TOPLEFT", button, "TOPRIGHT", 0, 0)
				addLine(GameTooltip, button.id, types.achievement)
				GameTooltip:Show()
			end)
			button:HookScript("OnLeave", function()
				GameTooltip:Hide()
			end)
		end
	end
end)

-- Pet battle buttons
hooksecurefunc("PetBattleAbilityButton_OnEnter", function(self)
	local petIndex = C_PetBattles.GetActivePet(LE_BATTLE_PET_ALLY)
	if (self:GetEffectiveAlpha() > 0) then
		local id = select(1, C_PetBattles.GetAbilityInfo(LE_BATTLE_PET_ALLY, petIndex, self:GetID()))
		if (id) then
			local oldText = PetBattlePrimaryAbilityTooltip.Description:GetText(id)
			PetBattlePrimaryAbilityTooltip.Description:SetText(oldText .. "\r\r" .. types.ability .. "|cffffffff " .. id .. "|r")
		end
	end
end)

-- Pet battle auras
hooksecurefunc("PetBattleAura_OnEnter", function(self)
	local parent = self:GetParent()
	local id = select(1, C_PetBattles.GetAuraInfo(parent.petOwner, parent.petIndex, self.auraIndex))
	if (id) then
		local oldText = PetBattlePrimaryAbilityTooltip.Description:GetText(id)
		PetBattlePrimaryAbilityTooltip.Description:SetText(oldText .. "\r\r" .. types.ability .. "|cffffffff " .. id .. "|r")
	end
end)

-- Currencies
hooksecurefunc(GameTooltip, "SetCurrencyToken", function(self, index)
	local id = tonumber(strmatch(GetCurrencyListLink(index),"currency:(%d+)"))
	if (id) then addLine(self, id, types.currency) end
end)

hooksecurefunc(GameTooltip, "SetCurrencyByID", function(self, id)
	 if (id) then addLine(self, id, types.currency) end
end)

hooksecurefunc(GameTooltip, "SetCurrencyTokenByID", function(self, id)
	 if (id) then addLine(self, id, types.currency) end
end)

-- Quests
local function questhook(self)
	if (self.questID) then addLine(GameTooltip, self.questID, types.quest) end
end

local titlebuttonshooked = {}
hooksecurefunc("QuestLogQuests_GetTitleButton", function(index)
	local titles = QuestMapFrame.QuestsFrame.Contents.Titles
	if (titles[index] and not titlebuttonshooked[index]) then
		titles[index]:HookScript("OnEnter", questhook)
		titlebuttonshooked[index] = true
	end
end)
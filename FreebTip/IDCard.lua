local ADDON_NAME, ns = ...

IDCard = {}
local registry = {}
local hookfactory = function(hook, orig)
	return function(self, ...)
		local reg = registry[self]
		if (reg[orig]) then reg[orig](self, ...) end
		hook(reg.button, self, ...)
	end
end

local setItem = hookfactory(function(b, self)
	local name, link = self:GetItem()
	if (link and name and strlen(name) > 0) then
		local icon = GetItemIcon(link)
		local quality = select(3, GetItemInfo(link))
		if (quality) then
			local R, G, B = GetItemQualityColor(quality)
			b:SetBackdropBorderColor(R, G, B)
			self:SetBackdropBorderColor(R, G, B)
		end
		b.achOverlay:SetTexture(icon)
		b.link = link
		b.type = "item"
		b:Show()
	end
end, "setItem")

local function openToAchievement(link)
	if (not (AchievementFrame and AchievementFrame:IsShown())) then
		ToggleAchievementFrame()
	end
	local id = tonumber(link:match("achievement:(%d+)"))
	if (not id) then return end

	AchievementFrame_SelectAchievement(id)
end

local cleared = hookfactory(function(b, self)
	b:SetBackdropBorderColor(ns.cfg.bdrcolor.r, ns.cfg.bdrcolor.g, ns.cfg.bdrcolor.b)
	b.achOverlay:SetTexture(nil)
	b.type = nil
	b.link = nil
	b:Hide()
end, "cleared")

local setHyperlink = hookfactory(function(b, self, link)
	if (not (link and type(link) == "string")) then return end
	local linkType, id = link:match("^([^:]+):(%d+)")
	if (linkType == "achievement" and id) then
		b.achOverlay:SetTexture(select(10, GetAchievementInfo(id)))
		b.link = GetAchievementLink(id)
		b.type = "achievement"
		b:Show()
	elseif (linkType == "spell" and id) then
		b.achOverlay:SetTexture(select(3, GetSpellInfo(id)))
		b.link = GetSpellLink(id)
		b.type = "spell"
		b:Show()
	end
end, "setHyperlink")

local function click(self)
	if (IsModifiedClick("CHATLINK") and self.link) then
		local frame = GetCurrentKeyBoardFocus()
		if (frame and frame:IsObjectType("EditBox")) then
			frame:Insert(self.link)
		end
	elseif (IsModifiedClick("DRESSUP") and self.link) then
		if (self.type == "item") then DressUpItemLink(self.link)
		elseif (self.type == "achievement") then openToAchievement(self.link) end
	end
end

local function dragstart(self) self:GetParent():StartMoving() end
local function dragstop(self) self:GetParent():StopMovingOrSizing() end

function IDCard:RegisterTooltip(tooltip)
	if (registry[tooltip]) then return end
	local reg = {}
	registry[tooltip] = reg

	local b = CreateFrame("Button", nil, tooltip)
	b:SetWidth(40)
	b:SetHeight(40)
	b:SetBackdrop(ns.cfg.backdrop)
	b:SetBackdropBorderColor(ns.cfg.bdrcolor.r, ns.cfg.bdrcolor.g, ns.cfg.bdrcolor.b)
	b:SetScale(ns.cfg.scale)
	b:SetPoint("TOPRIGHT", tooltip, "TOPLEFT", 1, 0)
	b:SetScript("OnDragStart", dragstart)
	b:SetScript("OnDragStop", dragstop)
	b:SetScript("OnClick", click)
	b:RegisterForDrag("LeftButton")
	b:Hide()
	reg.button = b

	local t = b:CreateTexture(nil, "OVERLAY")
	t:SetTexCoord(.08, .92, .08, .92)
	t:SetPoint("TOPLEFT", b, "TOPLEFT", 1, -1)
	t:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -1, 1)
	b.achOverlay = t

	reg.setItem = tooltip:GetScript("OnTooltipSetItem")
	reg.cleared = tooltip:GetScript("OnTooltipCleared")
	reg.setHyperlink = tooltip.SetHyperlink
	tooltip:SetScript("OnTooltipSetItem", setItem)
	tooltip:SetScript("OnTooltipCleared", cleared)
	tooltip.SetHyperlink = setHyperlink
end

IDCard:RegisterTooltip(ItemRefTooltip)
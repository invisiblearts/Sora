﻿----------------
--  命名空间  --
----------------

local _, ns = ...
local cfg = ns.cfg
local Buttons = 0

local function SetIconTexture(self, crop)
	if crop == 1 then self:SetTexCoord(.1, .9, .1, .9) end
	self:SetPoint("TOPLEFT", 2, -2)
	self:SetPoint("BOTTOMRIGHT", -2, 2)
end
local function SetNormalTexture(self)
	if self then
		self:SetTexture(cfg.Texture)
		self:SetAllPoints()
		self:SetVertexColor(cfg.colors.normal.r, cfg.colors.normal.g, cfg.colors.normal.b)
	end
	local Button = self:GetParent()
	if Button and not Button.Shadow then
		Button.Shadow = CreateFrame("Frame", nil, Button)
		Button.Shadow:SetPoint("TOPLEFT", -3, 3)
		Button.Shadow:SetPoint("BOTTOMRIGHT", 3, -3)
		Button.Shadow:SetBackdrop({edgeFile = cfg.GlowTex , edgeSize = 5})
		Button.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
		Button.Shadow:SetFrameLevel(0)
	end
end
local function SetPushedTexture(self)
	self:SetTexture(cfg.Texture)
	self:SetVertexColor(cfg.colors.pushed.r, cfg.colors.pushed.g, cfg.colors.pushed.b)
end
local function SetHighlightTexture(self)
	self:SetTexture(cfg.Texture)
	self:SetVertexColor(cfg.colors.highlight.r, cfg.colors.highlight.g, cfg.colors.highlight.b)
end
local function SetCheckedTexture(self)
	self:SetTexture(cfg.Texture)
	self:SetVertexColor(cfg.colors.checked.r, cfg.colors.checked.g, cfg.colors.checked.b)
end
local function SetStyle(self, checked)
	SetIconTexture(_G[self:GetName().."Icon"], 1)
	SetNormalTexture(self:GetNormalTexture())
	SetPushedTexture(self:GetPushedTexture())
	SetHighlightTexture(self:GetHighlightTexture())
	if checked == 1 then SetCheckedTexture(self:GetCheckedTexture()) end
end

-- Hook
hooksecurefunc("ActionButton_Update", function(self)
	_G[self:GetName().."Border"]:Hide()
	_G[self:GetName().."Flash"]:Hide()
	local HotKey = _G[self:GetName().."HotKey"]
	HotKey:SetFont(cfg.Font, ActionBarDB.HotkeyFontSize, "THINOUTLINE")
	if ActionBarDB.HideHotKey then
		HotKey:SetAlpha(0)
	else
		HotKey:SetPoint("TOPRIGHT")
	end
	local Name = _G[self:GetName().."Name"]
	Name:SetFont(cfg.Font, ActionBarDB.NameFontSize, "THINOUTLINE")
	if ActionBarDB.HideMacroName then Name:Hide() end
	local Count = _G[self:GetName().."Count"]
	Count:SetFont(cfg.Font, ActionBarDB.CountFontSize, "THINOUTLINE")
	SetStyle(self, 1)
end)
hooksecurefunc("ActionButton_Update", function(self)
	for i=1, VEHICLE_MAX_ACTIONBUTTONS do
		local HotKey = _G["VehicleMenuBarActionButton"..i.."HotKey"]
		HotKey:SetFont(cfg.Font, ActionBarDB.HotkeyFontSize, "THINOUTLINE")
		if ActionBarDB.HideHotKey then
			HotKey:SetAlpha(0)
		else
			HotKey:SetPoint("TOPLEFT")
		end
	end
end)
hooksecurefunc("ActionButton_ShowGrid", function(self)
	local NormalTexture	= _G[self:GetName().."NormalTexture"]
	NormalTexture:SetVertexColor(cfg.colors.normal.r, cfg.colors.normal.g, cfg.colors.normal.b, 1)
end)
hooksecurefunc("PetActionBar_Update", function(self)
	for i = 1, NUM_PET_ACTION_SLOTS do
		local Button = _G["PetActionButton"..i]
		local Shine = _G["PetActionButton"..i.."Shine"]
		local Border = _G["PetActionButton"..i.."Border"]
		SetStyle(Button, 1)
		Shine:ClearAllPoints()
		Shine:SetAllPoints()
		Border:Hide()
	end
end)
hooksecurefunc("ShapeshiftBar_UpdateState", function(self)
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		_G["ShapeshiftButton"..i.."Flash"]:Hide()
		SetStyle(_G["ShapeshiftButton"..i], 1)
	end
end)
hooksecurefunc("ActionButton_UpdateFlyout", function(self)
	self.FlyoutBorder:SetAlpha(0)
	self.FlyoutBorderShadow:SetAlpha(0)
	SpellFlyoutHorizontalBackground:SetAlpha(0)
	SpellFlyoutVerticalBackground:SetAlpha(0)
	SpellFlyoutBackgroundEnd:SetAlpha(0)
	for i = 1, GetNumFlyouts() do
		local x = GetFlyoutID(i)
		local _, _, numSlots, isKnown = GetFlyoutInfo(x)
		if isKnown then
			Buttons = numSlots
			break
		end
	end
end)
SpellFlyout:HookScript("OnShow", function(self)
	for i = 1, Buttons do
		if _G["SpellFlyoutButton"..i] then
			local self = _G["SpellFlyoutButton"..i]
			local tex = self:GetNormalTexture()
			self:SetNormalTexture(cfg.Texture)
			SetStyle(self)
		end

	end
end)

-- Totem Bar
if select(2, UnitClass("player"))== "SHAMAN" and MultiCastActionBarFrame then
	local function MultiCastSlotButtons(self, slot)
		self:SetNormalTexture(cfg.Texture)
		local tex = self:GetNormalTexture()
		tex:SetVertexColor(cfg.colors.normal.r, cfg.colors.normal.g, cfg.colors.normal.b)
		SetHighlightTexture(self:GetHighlightTexture())
		self.overlayTex.SetTexture = function() end
		self.overlayTex.Show = function() end
		self.overlayTex:Hide()
	end
	local function MultiCastSpellButtons(self)
		_G[self:GetName().."Highlight"]:Hide()
		SetStyle(self)
		local HotKey = _G[self:GetName().."HotKey"]
		HotKey:SetFont(cfg.Font, ActionBarDB.HotkeyFontSize, "THINOUTLINE")
		if ActionBarDB.HideHotKey then
			HotKey:SetAlpha(0)
		else
			HotKey:SetPoint("TOPRIGHT")
		end
	end
	hooksecurefunc("MultiCastSlotButton_Update", MultiCastSlotButtons)
	hooksecurefunc("MultiCastActionButton_Update", MultiCastSlotButtons)
	hooksecurefunc("MultiCastSummonSpellButton_Update", MultiCastSpellButtons)
	hooksecurefunc("MultiCastRecallSpellButton_Update", MultiCastSpellButtons)
	MultiCastFlyoutFrame.top:Hide()
	MultiCastFlyoutFrame.middle:Hide()
	
	hooksecurefunc("MultiCastFlyoutFrame_LoadSlotSpells", function(self, slot, ...)
		local numSpells = select("#", ...) + 1
		for i = 1, numSpells do
			self.buttons[i]:SetNormalTexture(cfg.Texture)
			local IconTexture, HighlightTexture, NormalTexture = self.buttons[i]:GetRegions()
			if i ~= 1 then
				SetIconTexture(IconTexture, 1)
			else
				SetIconTexture(IconTexture)
			end
			SetHighlightTexture(HighlightTexture)
			NormalTexture:SetVertexColor(cfg.colors.normal.r, cfg.colors.normal.g, cfg.colors.normal.b)
		end
	end)
	
	hooksecurefunc("MultiCastFlyoutFrame_LoadPageSpells", function(self)
		for key, value in next, TOTEM_MULTI_CAST_SUMMON_SPELLS do
			if IsSpellKnown(value) then
				self.buttons[key]:SetNormalTexture(cfg.Texture)
				local IconTexture, HighlightTexture, NormalTexture = self.buttons[key]:GetRegions()
				SetIconTexture(IconTexture, 1)
				SetHighlightTexture(HighlightTexture)
				NormalTexture:SetVertexColor(cfg.colors.normal.r, cfg.colors.normal.g, cfg.colors.normal.b)
			end
		end
	end)
end

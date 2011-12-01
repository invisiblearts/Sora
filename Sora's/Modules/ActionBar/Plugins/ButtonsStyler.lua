﻿-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")
local Module = Sora:NewModule("ButtonsStyler")

local function StyleButton(Button, Checked) 
    local name = Button:GetName()
	
    local Icon = _G[name.."Icon"]
    local Count = _G[name.."Count"]
    local Border = _G[name.."Border"]
    local HotKey = _G[name.."HotKey"]
    local Cooldown = _G[name.."Cooldown"]
    local Name = _G[name.."Name"]
    local Flash = _G[name.."Flash"]
    local NormalTexture = _G[name.."NormalTexture"]
	local IconTexture = _G[name.."IconTexture"]
 
    Button.Highlight = Button:CreateTexture(nil, "OVERLAY")
    Button.Highlight:SetTexture(1, 1, 1, 0.3)
    Button.Highlight:SetPoint("TOPLEFT", 2, -2)
    Button.Highlight:SetPoint("BOTTOMRIGHT", -2, 2)
    Button:SetHighlightTexture(Button.Highlight)
 
    Button.Pushed = Button:CreateTexture(nil, "OVERLAY")
    Button.Pushed:SetTexture(0.1, 0.1, 0.1, 0.5)
	Button.Pushed:SetPoint("TOPLEFT", 2, -2)
	Button.Pushed:SetPoint("BOTTOMRIGHT", -2, 2)
    Button:SetPushedTexture(Button.Pushed)
	
	if Checked then
		Button.Checked = Button:CreateTexture(nil, "OVERLAY")
		Button.Checked:SetTexture(1, 1, 1, 0.3)
		Button.Checked:SetPoint("TOPLEFT", 2, -2)
		Button.Checked:SetPoint("BOTTOMRIGHT", -2, 2)
		Button:SetCheckedTexture(Button.Checked)
	end
end
local function Style(self)
	local name = self:GetName()
	
	if name:match("MultiCast") then return end 
	
	local Icon = _G[name.."Icon"]
	local Count = _G[name.."Count"]
	local Flash	 = _G[name.."Flash"]
	local HotKey = _G[name.."HotKey"]
	local Border  = _G[name.."Border"]
	local Name = _G[name.."Name"]
	local NormalTexture  = _G[name.."NormalTexture"]
 
	Flash:SetTexture("")
	self:SetNormalTexture("")
 
	Border:Hide()
	Border = nil
 
	Count:ClearAllPoints()
	Count:SetPoint("BOTTOMRIGHT", 2, 2)
	Count:SetFont(DB.Font, ActionBarDB.FontSize, "THINOUTLINE")
 
	if Name and ActionBarDB.HideMacroName then
		Name:SetText("")
		Name:Hide()
		Name.Show = function() end
	end
 
	if not Icon.Shadow then
		Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		Icon:SetPoint("TOPLEFT", 2, -2)
		Icon:SetPoint("BOTTOMRIGHT", -2, 2)
		Icon.Shadow = S.MakeTexShadow(self, Icon, 4)
	end

	HotKey:ClearAllPoints()
	HotKey:SetPoint("TOPRIGHT", 1, -1)
	HotKey:SetFont(DB.Font, ActionBarDB.FontSize, "THINOUTLINE")
	HotKey.ClearAllPoints = function() end
	HotKey.SetPoint = function() end
 
	if ActionBarDB.HideHotKey then
		HotKey:SetText("")
		HotKey:Hide()
		HotKey.Show = function() end
	end
end
local function StyleSmallButton(Button, Icon, name)
	local Flash	 = _G[name.."Flash"]
	Button:SetNormalTexture("")
	Button.SetNormalTexture = function() end
	
	Flash:SetTexture(DB.Button)
	
	if not Icon.Shadow then
		Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		Icon:SetPoint("TOPLEFT", 2, -2)
		Icon:SetPoint("BOTTOMRIGHT", -2, 2)
		Icon.Shadow = S.MakeTexShadow(Button, Icon, 4)
	end
end
local function StyleFlyout(self)
	--self.FlyoutBorder:SetAlpha(0)
	--self.FlyoutBorderShadow:SetAlpha(0)
	
	SpellFlyoutHorizontalBackground:SetAlpha(0)
	SpellFlyoutVerticalBackground:SetAlpha(0)
	SpellFlyoutBackgroundEnd:SetAlpha(0)
	
	for i=1, GetNumFlyouts() do
		local x = GetFlyoutID(i)
		local _, _, numSlots, isKnown = GetFlyoutInfo(x)
		if isKnown then buttons = numSlots break end
	end
	
	--Change arrow direction depending on what bar the button is on
	local arrowDistance
	if (SpellFlyout and SpellFlyout:IsShown() and SpellFlyout:GetParent() == self) or GetMouseFocus() == self then
		arrowDistance = 5
	else
		arrowDistance = 2
	end
	
	if self:GetParent():GetParent():GetName() == "SpellBookSpellIconsFrame" then return end

	if self:GetAttribute("flyoutDirection") ~= nil then
		local SetPoint, _, _, _, _ = self:GetParent():GetParent():GetPoint()
		
		if strfind(SetPoint, "BOTTOM") then
			self.FlyoutArrow:ClearAllPoints()
			self.FlyoutArrow:SetPoint("TOP", self, "TOP", 0, arrowDistance)
			SetClampedTextureRotation(self.FlyoutArrow, 0)
			if not InCombatLockdown() then self:SetAttribute("flyoutDirection", "UP") end
		else
			self.FlyoutArrow:ClearAllPoints()
			self.FlyoutArrow:SetPoint("LEFT", self, "LEFT", -arrowDistance, 0)
			SetClampedTextureRotation(self.FlyoutArrow, 270)
			if not InCombatLockdown() then self:SetAttribute("flyoutDirection", "LEFT") end
		end
	end
end

function Module:OnEnable()
	for _, value in ipairs({"ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarLeftButton", "MultiBarRightButton", "ShapeshiftButton", "PetActionButton", "MultiCastActionButton"}) do
		for index = 1, 12 do
			local Button = _G[value..tostring(index)]
			local Cooldown = _G[value..tostring(index).."Cooldown"]
	 
			if Button == nil or Cooldown == nil then break end
			
			Cooldown:ClearAllPoints()
			Cooldown:SetPoint("TOPLEFT", 2, -2)
			Cooldown:SetPoint("BOTTOMRIGHT", -2, 2)
		end
	end

	for i = 1, 12 do
		StyleButton(_G["ActionButton"..i], true)
		StyleButton(_G["MultiBarBottomLeftButton"..i], true)
		StyleButton(_G["MultiBarBottomRightButton"..i], true)
		StyleButton(_G["MultiBarLeftButton"..i], true)
		StyleButton(_G["MultiBarRightButton"..i], true)
	end	 
	for i=1, 10 do
		StyleButton(_G["ShapeshiftButton"..i], true)
		StyleButton(_G["PetActionButton"..i], true)
	end
	for i=1, NUM_SHAPESHIFT_SLOTS do
		local Button  = _G["ShapeshiftButton"..i]
		local Icon  = _G["ShapeshiftButton"..i.."Icon"]
		StyleSmallButton(Button, Icon, "ShapeshiftButton"..i)
	end
	for i=1, NUM_PET_ACTION_SLOTS do
		local Button  = _G["PetActionButton"..i]
		local Icon  = _G["PetActionButton"..i.."Icon"]
		StyleSmallButton(Button, Icon, "PetActionButton"..i)
	end
	hooksecurefunc("ActionButton_Update", Style)
	hooksecurefunc("ActionButton_UpdateFlyout", StyleFlyout)

	if select(2, UnitClass("player"))== "SHAMAN" and MultiCastActionBarFrame then
		hooksecurefunc("MultiCastFlyoutFrame_ToggleFlyout", function(Flyout)
			Flyout.top:SetTexture(nil)
			Flyout.middle:SetTexture(nil)
			local last = nil
			
			for _, Button in ipairs(Flyout.buttons) do
				local Icon = select(1, Button:GetRegions())
				Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
				Icon:SetDrawLayer("ARTWORK")
				Icon:SetPoint("TOPLEFT", 2, -2)
				Icon:SetPoint("BOTTOMRIGHT", -2, 2)		
				if not InCombatLockdown() then
					Button:SetSize(ActionBarDB.ButtonSize, ActionBarDB.ButtonSize)
					Button:ClearAllPoints()
					Button:SetPoint("BOTTOM", last, "TOP", 0, 3)
					Button.Shadow = S.MakeTexShadow(Button, Icon, 4)
				end
				if Button:IsVisible() then last = Button end
				Button:SetBackdropBorderColor(Flyout.parent:GetBackdropBorderColor())
				StyleButton(Button)		
			end
			
			Flyout.buttons[1]:SetPoint("BOTTOM")	
			Flyout:ClearAllPoints()
			Flyout:SetPoint("BOTTOM", Flyout.parent, "TOP", 0, 4)
		end)
		local function StyleTotemSlotButton(Button, index)
			Button.overlayTex:SetTexture(nil)
			Button.background:ClearAllPoints()
			Button.background:SetPoint("TOPLEFT", 2, -2)
			Button.background:SetPoint("BOTTOMRIGHT", -2, 2)
			Button.Shadow = S.MakeTexShadow(Button, Button.background, 4)
			Button:SetSize(ActionBarDB.ButtonSize, ActionBarDB.ButtonSize)
			Button:ClearAllPoints()
			if index == 1 then
				Button:SetPoint("LEFT", MultiCastSummonSpellButton, "RIGHT", ActionBarDB.ButtonSize+3*2, 0)
			elseif index == 2 then
				Button:SetPoint("LEFT", MultiCastSummonSpellButton, "RIGHT", 3, 0)
			elseif index == 3 then
				Button:SetPoint("LEFT", MultiCastSlotButton1, "RIGHT", 3, 0)
			elseif index == 4 then
				Button:SetPoint("LEFT", MultiCastSlotButton3, "RIGHT", 3, 0)		
			end
			StyleButton(Button)
		end
		hooksecurefunc("MultiCastSlotButton_Update", function(self, slot) StyleTotemSlotButton(self, tonumber(string.match(self:GetName(), "MultiCastSlotButton(%d)"))) end)

		local function StyleTotemActionButton(Button, index)
			local Icon = select(1, Button:GetRegions())
			Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			Icon:SetPoint("TOPLEFT", 2, -2)
			Icon:SetPoint("BOTTOMRIGHT", -2, 2)
			Button.overlayTex:SetTexture(nil)
			Button.overlayTex:Hide()
			Button:GetNormalTexture():SetTexCoord(0, 0, 0, 0)
			if Button.slotButton then
				Button:ClearAllPoints()
				Button:SetAllPoints(Button.slotButton)
				Button:SetFrameLevel(Button.slotButton:GetFrameLevel()+1)
			end
			Button:SetBackdropColor(0, 0, 0, 0)
			StyleButton(Button, true)
		end
		hooksecurefunc("MultiCastActionButton_Update", function(actionButton, actionId, actionIndex, slot) StyleTotemActionButton(actionButton, actionIndex) end)
		hooksecurefunc("MultiCastSummonSpellButton_Update", function(Button)
			if not Button then return end
			local Icon = select(1, Button:GetRegions())
			Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			Icon:SetPoint("TOPLEFT", 2, -2)
			Icon:SetPoint("BOTTOMRIGHT", -2, 2)
			Button.Shadow = S.MakeTexShadow(Button, Icon, 4)
			Button:GetNormalTexture():SetTexture(nil)
			Button:SetSize(ActionBarDB.ButtonSize, ActionBarDB.ButtonSize)
			Button:ClearAllPoints()
			Button:SetPoint("BOTTOMLEFT", DB.ActionBar, "TOPLEFT", 0, 5)
			_G[Button:GetName().."Highlight"]:SetTexture(nil)
			_G[Button:GetName().."NormalTexture"]:SetTexture(nil)
			StyleButton(Button)
		end)
		hooksecurefunc("MultiCastRecallSpellButton_Update", function(Button)
			if not Button then return end
			local Icon = select(1, Button:GetRegions())
			Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			Icon:SetPoint("TOPLEFT", 2, -2)
			Icon:SetPoint("BOTTOMRIGHT", -2, 2)
			Button.Shadow = S.MakeTexShadow(Button, Icon, 4)
			Button:GetNormalTexture():SetTexture(nil)
			Button:SetSize(ActionBarDB.ButtonSize, ActionBarDB.ButtonSize)
			Button:ClearAllPoints()
			Button:SetPoint("LEFT", MultiCastSlotButton4, "RIGHT", 3, 0)	
			_G[Button:GetName().."Highlight"]:SetTexture(nil)
			_G[Button:GetName().."NormalTexture"]:SetTexture(nil)
			StyleButton(Button)
		end)
	end
end
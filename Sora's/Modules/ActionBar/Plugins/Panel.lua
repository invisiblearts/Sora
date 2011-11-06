﻿-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")
local Module = Sora:NewModule("ActionBarPanel")

local function BuildExpBar()
	local Bar = CreateFrame("StatusBar", nil, UIParent)
	Bar:SetStatusBarTexture(DB.Statusbar)
	if ActionBarDB.MainBarLayout == 1 then
		Bar:SetPoint("TOPLEFT", MultiBarBottomRightButton2, "BOTTOMLEFT", 2, -9)
		Bar:SetPoint("BOTTOMRIGHT", MultiBarBottomRightButton8, "BOTTOMRIGHT", -2, -14)
	elseif ActionBarDB.MainBarLayout == 2 then
		Bar:SetPoint("TOPLEFT", ActionButton2, "BOTTOMLEFT", 2, -9)
		Bar:SetPoint("BOTTOMRIGHT", ActionButton11, "BOTTOMRIGHT", -2, -14)
	end
	Bar.Rest = CreateFrame("StatusBar", nil, Bar)
	Bar.Rest:SetAllPoints()
	Bar.Rest:SetStatusBarTexture(DB.Statusbar)
	Bar.Rest:SetFrameLevel(Bar:GetFrameLevel()-1)
	Bar.Text = S.MakeFontString(Bar, 10)
	Bar.Text:SetPoint("CENTER")
	Bar.Text:SetAlpha(0)
	Bar.Shadow = S.MakeShadow(Bar, 3)
	Bar:SetStatusBarTexture(DB.Statusbar)
	Bar:RegisterEvent("PLAYER_XP_UPDATE")
	Bar:RegisterEvent("PLAYER_LEVEL_UP")
	Bar:RegisterEvent("UPDATE_EXHAUSTION")
	Bar:RegisterEvent("UPDATE_FACTION")
	Bar:SetScript("OnEnter",function(self) self.Text:SetAlpha(1) end)
	Bar:SetScript("OnLeave",function(self) self.Text:SetAlpha(0) end)
	Bar:SetScript("OnEvent", function(self)
		local currXP = UnitXP("player")
		local playerMaxXP = UnitXPMax("player")
		local exhaustionXP  = GetXPExhaustion("player")
		local name, standingID, barMin, barMax, barValue = GetWatchedFactionInfo()
		if UnitLevel("player") == MAX_PLAYER_LEVEL or IsXPUserDisabled == true then
			self.Rest:SetMinMaxValues(0, 1)
			self.Rest:SetValue(0)
			if name then
				self:SetStatusBarColor(FACTION_BAR_COLORS[standingID].r, FACTION_BAR_COLORS[standingID].g, FACTION_BAR_COLORS[standingID].b, 1)
				self:SetMinMaxValues(barMin, barMax)
				self:SetValue(barValue)
				self.Text:SetText(barValue-barMin.." / "..barMax-barMin.."    "..floor(((barValue-barMin)/(barMax-barMin))*1000)/10 .."% | ".. name.. "(".._G["FACTION_STANDING_LABEL"..standingID]..")")
			else
				self:SetStatusBarColor(0.2, 0.4, 0.8, 1)
				self:SetMinMaxValues(0, 1)
				self:SetValue(1)
				self.Text:SetText("")
			end
		else
			self:SetStatusBarColor(0.4, 0.1, 0.6, 1)
			self.Rest:SetStatusBarColor(0.2, 0.4, 0.8, 1)
			self:SetMinMaxValues(0, playerMaxXP)
			self.Rest:SetMinMaxValues(0, playerMaxXP)
			if exhaustionXP then
				self.Text:SetText(S.SVal(currXP).." / "..S.SVal(playerMaxXP).."    "..floor((currXP/playerMaxXP)*1000)/10 .."%" .. " (+"..S.SVal(exhaustionXP )..")")
				if exhaustionXP+currXP >= playerMaxXP then
					self:SetValue(currXP)
					self.Rest:SetValue(playerMaxXP)
				else
					self:SetValue(currXP)
					self.Rest:SetValue(exhaustionXP+currXP)
				end
			else
				self:SetValue(currXP)
				self.Rest:SetValue(0)
				self.Text:SetText(S.SVal(currXP).." / "..S.SVal(playerMaxXP).."    "..floor((currXP/playerMaxXP)*1000)/10 .."%")
			end
		end
	end)
end
local function BuildExtraBarButton()
	local LeftButton = S.MakeButton(UIParent)
	LeftButton:SetSize(ActionBarDB.ButtonSize, 9)
	if ActionBarDB.MainBarLayout == 1 then
		LeftButton:SetPoint("TOP", MultiBarBottomRightButton1, "BOTTOM", 0, -7)
	elseif ActionBarDB.MainBarLayout == 2 then
		LeftButton:SetPoint("TOP", ActionButton1, "BOTTOM", 0, -7)
	end
	LeftButton:SetScript("OnClick", function(self) S.LeftBarFade() end)
	local RightButton = S.MakeButton(UIParent)
	RightButton:SetSize(ActionBarDB.ButtonSize, 9)
	if ActionBarDB.MainBarLayout == 1 then
		RightButton:SetPoint("TOP", MultiBarBottomRightButton7, "BOTTOM", 0, -7)
	elseif ActionBarDB.MainBarLayout == 2 then
		RightButton:SetPoint("TOP", ActionButton12, "BOTTOM", 0, -7)
	end
	RightButton:SetScript("OnClick", function(self) S.RightBarFade() end)
end

function Module:OnEnable()
	BuildExpBar()
	BuildExtraBarButton()
end



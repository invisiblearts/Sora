-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local function CreatePowerBar(self, ...)
	local Power = CreateFrame("StatusBar", nil, self)
	Power:SetPoint("BOTTOM", self)
	Power:SetSize(self:GetWidth(), 2)
	Power:SetStatusBarTexture(DB.Statusbar)

	Power.BG = Power:CreateTexture(nil, "BACKGROUND")
	Power.BG:SetTexture(DB.Statusbar)
	Power.BG:SetAllPoints()
	Power.BG:SetVertexColor(0.12, 0.12, 0.12)
	Power.BG.multiplier = 0.2
	
	Power.Smooth = true
	Power.colorPower = true
	Power.frequentUpdates = true
	Power.Shadow = S.MakeShadow(Power, 2)
	
	self.Power = Power
end

local function CreateHealthBar(self, ...)
	local Health = CreateFrame("StatusBar", nil, self)
	Health:SetPoint("TOP", self)
	Health:SetStatusBarTexture(DB.Statusbar)
	Health:SetSize(self:GetWidth(), self:GetHeight()-4)

	Health.BG = Health:CreateTexture(nil, "BACKGROUND")
	Health.BG:SetAllPoints()
	Health.BG:SetTexture(DB.Statusbar)
	Health.BG:SetVertexColor(0.12, 0.12, 0.12)
	Health.BG.multiplier = 0.2
	
	Health.Smooth = true
	Health.colorClass = true
	Health.colorSmooth = true
	Health.colorTapping = true
	Health.colorReaction = true
	Health.frequentUpdates = true
	Health.Shadow = S.MakeShadow(Health, 2)

	Health.PostUpdate = function(Health, unit, min, max, ...)
		local disconnnected = not UnitIsConnected(unit)
		local dead = UnitIsDead(unit)
		local ghost = UnitIsGhost(unit)

		if disconnnected or dead or ghost then
			Health:SetValue(max)	
			Health:SetStatusBarColor(0, 0, 0)
		else
			Health:SetValue(min)
			if unit == "vehicle" then Health:SetStatusBarColor(22/255, 106/255, 44/255) end
		end
	end

	self.Health = Health
end

local function RegisterForClicks(self, ...)
	self.menu = function(self)
		local unit = self.unit:sub(1, -2)
		local cunit = self.unit:gsub("^%l", string.upper)

		if cunit == "Vehicle" then cunit = "Pet" end

		if unit == "party" or unit == "partypet" then
			ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
		elseif _G[cunit.."FrameDropDown"] then
			ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
		end
	end

	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)
	self:RegisterForClicks("AnyUp")
end

local function CreateTag(self, ...)
	local NameTag = S.MakeText(self.Health, 10)
	NameTag:SetPoint("CENTER", 0, 0)

	local InfoTag = S.MakeText(self.Health, 7)
	InfoTag:SetPoint("CENTER", 0, -10)

	self:Tag(InfoTag, "[Sora:Info]")
	self:Tag(NameTag, "[Sora:Color][name]")
end

local function CreateRange(self, ...)
	self.Range = {
		insideAlpha = 1,
		outsideAlpha = 0.4,
	}
end

local function CreateRaidIcon(self, ...)
	local RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
	RaidIcon:SetSize(16, 16)
	RaidIcon:SetPoint("CENTER", self.Health, "TOP", 0, 2)

	self.RaidIcon = RaidIcon
end

local function CreateCombatIcon(self)
	local Leader = self.Health:CreateTexture(nil, "OVERLAY")
	Leader:SetSize(16, 16)
	Leader:SetPoint("TOPLEFT", -7, 9)

	self.Leader = Leader
	local Assistant = self.Health:CreateTexture(nil, "OVERLAY")
	Assistant:SetAllPoints(Leader)
	self.Assistant = Assistant

	local MasterLooter = self.Health:CreateTexture(nil, "OVERLAY")
	MasterLooter:SetSize(16, 16)
	MasterLooter:SetPoint("LEFT", Leader, "RIGHT")
	self.MasterLooter = MasterLooter
end

local function CreateLFDRoleIcon(self, ...)
	local LFDRoleIcon = self.Health:CreateTexture(nil, "OVERLAY")
	LFDRoleIcon:SetSize(16, 16)
	LFDRoleIcon:SetPoint("TOPRIGHT", 7, 9)
	self.LFDRole = LFDRoleIcon
end

local function CreateThreatBorder(self, ...)
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", function(self, event, unit, ...)
		if self.unit ~= unit then return end
		local status = UnitThreatSituation(unit)
		unit = unit or self.unit
		if status and status > 1 then
			local r, g, b = GetThreatStatusColor(status)
			self.Health.Shadow:SetBackdropBorderColor(r, g, b, 0.60)
			self.Power.Shadow:SetBackdropBorderColor(r, g, b, 0.60)
		else
			self.Health.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
			self.Power.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
		end
	end)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", function(self, event, unit, ...)
		if self.unit ~= unit then return end
		local status = UnitThreatSituation(unit)
		unit = unit or self.unit
		if status and status > 1 then
			local r, g, b = GetThreatStatusColor(status)
			self.Health.Shadow:SetBackdropBorderColor(r, g, b, 0.60)
			self.Power.Shadow:SetBackdropBorderColor(r, g, b, 0.60)
		else
			self.Health.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
			self.Power.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
		end
	end)
end

local function CreateReadyCheckIcon(self, ...)
	local ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
	ReadyCheck:SetSize(16, 16)
	ReadyCheck:SetPoint("CENTER", 0, 0)
	self.ReadyCheck = ReadyCheck
end

local function CreateRaid(self, ...)
	CreatePowerBar(self, ...)
	CreateHealthBar(self, ...)
	RegisterForClicks(self, ...)

	CreateTag(self, ...)
	CreateRange(self, ...)
	CreateRaidIcon(self, ...)
	CreateCombatIcon(self, ...)
	CreateLFDRoleIcon(self, ...)
	CreateThreatBorder(self, ...)
	CreateReadyCheckIcon(self, ...)	
end

local function OnPlayerLogin(self, event, ...)
	CompactRaidFrameManager:UnregisterAllEvents()
	CompactRaidFrameManager.Show = function() end
	CompactRaidFrameManager:Hide()

	CompactRaidFrameContainer:UnregisterAllEvents()
	CompactRaidFrameContainer.Show = function() end
	CompactRaidFrameContainer:Hide()

	oUF:RegisterStyle("Raid", CreateRaid)
	oUF:SetActiveStyle("Raid")

	local Width, Height = unpack(C.Raid.Size);
	local Parent = CreateFrame("Frame", nil, UIParent)
	Parent:SetPoint(unpack(C.Raid.Postion))
	Parent:SetSize(Width*5 + 8*4, Height*5 + 8*4)

	local Raid = oUF:SpawnHeader("oUF_SoraRaid", nil, "raid,party,solo", 
		"showRaid", true,  
		"showPlayer", true, 
		"showParty", true, 
		"showSolo", false, 
		"xoffset", 8,
		"yoffset", -8, 
		"groupFilter", "1,2,3,4,5", 
		"groupBy", "GROUP", 
		"groupingOrder", "1,2,3,4,5", 
		"sortMethod", "INDEX", 
		"maxColumns", 5, 
		"unitsPerColumn", 5, 
		"columnSpacing", 8, 
		"point", "LEFT", 
		"columnAnchorPoint", "TOP",
		"oUF-initialConfigFunction", ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
		]]):format(Width, Height))

	Raid:SetPoint("TOPLEFT", Parent, "TOPLEFT", 0 , 0)
end

local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		OnPlayerLogin(self, event, ...)
	end
end)
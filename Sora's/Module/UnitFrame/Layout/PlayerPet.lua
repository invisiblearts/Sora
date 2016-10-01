-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local function CreatePowerBar(self, ...)
	local Power = CreateFrame("StatusBar", nil, self)
	Power:SetPoint("BOTTOM")
	Power:SetSize(self:GetWidth(), 2)
	Power:SetStatusBarTexture(DB.Statusbar)

	Power.BG = Power:CreateTexture(nil, "BACKGROUND")
	Power.BG:SetTexture(DB.Statusbar)
	Power.BG:SetAllPoints()
	Power.BG:SetVertexColor(0.12, 0.12, 0.12)
	
	Power.Smooth = true
	Power.colorPower = true
	Power.BG.multiplier = 0.2
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
	Health.colorReaction = true
	Health.frequentUpdates = true
	Health.Shadow = S.MakeShadow(Health, 2)

	self.Health = Health
end

local function CreateTags(self, ...)
	local NameTag = S.MakeText(self.Health, 10)
	NameTag:SetPoint("TOPLEFT", 1, -1)
	
	local HPTag = S.MakeText(self.Health, 7)
	HPTag:SetPoint("BOTTOMRIGHT", self.Health, 2, 1)

	self:Tag(NameTag, "[name]")
	self:Tag(HPTag, "[Sora:PerHP]")
end

local function CreateRaidIcon(self, ... )
	local RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
	RaidIcon:SetSize(16, 16)
	RaidIcon:SetPoint("CENTER", self.Health, "TOP", 0, 2)
	
	self.RaidIcon = RaidIcon
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

local function CreatePlayerPet(self, ...)
	self:SetSize(unpack(C.UnitFrame.PlayerPetSize))
	self:SetPoint("TOPRIGHT", _G["oUF_SoraPlayer"], "BOTTOMLEFT", -4,-4)

	CreatePowerBar(self, ...)
	CreateHealthBar(self, ...)

	CreateTags(self, ...)
	CreateRaidIcon(self, ...)
	RegisterForClicks(self, ...)
end

local function OnPlayerLogin(self, event, ...)
	oUF:RegisterStyle("PlayerPet", CreatePlayerPet)
	oUF:SetActiveStyle("PlayerPet")
	oUF:Spawn("pet", "oUF_SoraPlayerPet")
end

local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		OnPlayerLogin(self, event, ...)
	end
end)
﻿-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local function CreatePower(self, ...)
    local power = CreateFrame("StatusBar", nil, self)
    power:SetPoint("BOTTOM")
    power:SetSize(self:GetWidth(), 2)
    power:SetStatusBarTexture(DB.Statusbar)
    
    power.bg = power:CreateTexture(nil, "BACKGROUND")
    power.bg:SetAllPoints()
    power.bg:SetTexture(DB.Statusbar)
    power.bg:SetVertexColor(0.12, 0.12, 0.12)
    power.bg.multiplier = 0.12
    
    power.Smooth = true
    power.colorPower = true
    power.frequentUpdates = true
    power.shadow = S.MakeShadow(power, 2)
    
    self.Power = power
end

local function CreateHealth(self, ...)
    local health = CreateFrame("StatusBar", nil, self)
    health:SetPoint("TOP", self)
    health:SetStatusBarTexture(DB.Statusbar)
    health:SetSize(self:GetWidth(), self:GetHeight() - 4)
    
    health.bg = health:CreateTexture(nil, "BACKGROUND")
    health.bg:SetAllPoints()
    health.bg:SetTexture(DB.Statusbar)
    health.bg:SetVertexColor(0.12, 0.12, 0.12)
    health.bg.multiplier = 0.12
    
    health.Smooth = true
    health.colorTapping = true
    health.colorDisconnected = true
    health.colorClass = true
    health.colorReaction = true
    health.colorHealth = true
    health.frequentUpdates = true
    health.shadow = S.MakeShadow(health, 2)
    
    self.Health = health
end

local function CreateTag(self, ...)
    local nameTag = S.MakeText(self.Health, 9)
    nameTag:SetPoint("TOPLEFT", 1, -2)
    self:Tag(nameTag, "[Sora:Name]")

    local healthTag = S.MakeText(self.Health, 9)
    healthTag:SetPoint("BOTTOMRIGHT", self.Health, 1, 1)
    self:Tag(healthTag, "[Sora:PerHealth]")
end

local function CreateRaidIcon(self, ...)
    local RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
    RaidIcon:SetSize(16, 16)
    RaidIcon:SetPoint("CENTER", self.Health, "TOP", 0, 2)
    
    self.RaidIcon = RaidIcon
end

local function RegisterForEvent(self, ...)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetScript("OnEnter", UnitFrame_OnEnter)
end

local function RegisterStyle(self, ...)
    self:RegisterForClicks("AnyUp")
    self:SetPoint("TOPRIGHT", _G["oUF_Sora_Player"], "BOTTOMLEFT", -4, -4)
    self:SetSize(C.UnitFrame.PlayerPet.Width, C.UnitFrame.PlayerPet.Height)
    
    CreatePower(self, ...)
    CreateHealth(self, ...)
    
    CreateTag(self, ...)
    CreateRaidIcon(self, ...)

    RegisterForEvent(self, ...)
end

local function OnPlayerLogin(self, event, ...)
    oUF:RegisterStyle("oUF_Sora_PlayerPet", RegisterStyle)
    oUF:SetActiveStyle("oUF_Sora_PlayerPet")
    
    local oUFFrame = oUF:Spawn("pet", "oUF_Sora_PlayerPet")
end

local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, ...)
    end
end)

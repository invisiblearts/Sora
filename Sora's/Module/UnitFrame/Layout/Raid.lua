-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local function OnUnitThreatUpdate(self, event, unit, ...)
    if not self.unit == unit then
        return
    end
    
    local status = UnitThreatSituation(unit)
    local r, g, b, a = 0.00, 0.00, 0.00, 1.00
    
    if status and status > 1 then
        a = 0.60
        r, g, b = GetThreatStatusColor(status)
    end
    
    self.Power.shadow:SetBackdropBorderColor(r, g, b, a)
    self.Health.shadow:SetBackdropBorderColor(r, g, b, a)
end

local function CreatePower(self, ...)
    local power = CreateFrame("StatusBar", nil, self)
    power:SetPoint("BOTTOM", self)
    power:SetSize(self:GetWidth(), 2)
    power:SetStatusBarTexture(DB.Statusbar)
    
    power.bg = power:CreateTexture(nil, "BACKGROUND")
    power.bg:SetTexture(DB.Statusbar)
    power.bg:SetAllPoints()
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
    health.colorClassNPC = true
    health.colorClassPet = true
    health.colorReaction = true
    health.colorHealth = true
    health.frequentUpdates = true
    health.shadow = S.MakeShadow(health, 2)
    
    self.Health = health
end

local function CreateTag(self, ...)
    local NameTag = S.MakeText(self.Health, 10)
    NameTag:SetPoint("CENTER", 0, 0)
    self:Tag(NameTag, "[Sora:Color][Sora:Name]|r")
        
    local StatusTag = S.MakeText(self.Health, 7)
    StatusTag:SetPoint("CENTER", 0, -10)
    self:Tag(StatusTag, "[Sora:Color][Sora:Status]|r")
end

local function CreateRange(self, ...)
    self.Range = {
        insideAlpha = 1.00,
        outsideAlpha = 0.40,
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

local function CreateReadyCheckIcon(self, ...)
    local ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
    ReadyCheck:SetSize(16, 16)
    ReadyCheck:SetPoint("CENTER", 0, 0)
    self.ReadyCheck = ReadyCheck
end

local function RegisterForEvent(self, ...)
    self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", OnUnitThreatUpdate)
    self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", OnUnitThreatUpdate)
end

local function RegisterStyle(self, ...)
    self:RegisterForClicks("AnyUp")
    self:SetSize(C.UnitFrame.Raid.Width, C.UnitFrame.Raid.Height)
    
    CreatePower(self, ...)
    CreateHealth(self, ...)
    
    CreateTag(self, ...)
    CreateRange(self, ...)
    CreateRaidIcon(self, ...)
    CreateCombatIcon(self, ...)
    CreateLFDRoleIcon(self, ...)
    CreateReadyCheckIcon(self, ...)
end

local function OnPlayerLogin(self, event, ...)
    CompactRaidFrameManager:UnregisterAllEvents()
    CompactRaidFrameManager.Show = function() end
    CompactRaidFrameManager:Hide()
    
    CompactRaidFrameContainer:UnregisterAllEvents()
    CompactRaidFrameContainer.Show = function() end
    CompactRaidFrameContainer:Hide()
    
    oUF:RegisterStyle("oUF_Sora_Raid", RegisterStyle)
    oUF:SetActiveStyle("oUF_Sora_Raid")
    
    local Width = C.UnitFrame.Raid.Width
    local Height = C.UnitFrame.Raid.Height
    local Parent = CreateFrame("Frame", nil, UIParent)
    Parent:SetPoint(unpack(C.UnitFrame.Raid.Postion))
    Parent:SetSize(Width * 5 + 8 * 4, Height * 5 + 8 * 4)
    
    local oUFFrame = oUF:SpawnHeader("oUF_Sora_Raid", nil, "raid,party,solo",
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
        "columnAnchorPoint", "TOP"
    )
    oUFFrame:SetPoint("TOPLEFT", Parent, "TOPLEFT", 0, 0)
end

local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, ...)
    end
end)

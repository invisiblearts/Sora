-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))

-- Variables
local HPTag, PPTag, NameTag, Portrait = nil

-- Begin
local function PortraitFadeIn(...)
    UIFrameFadeOut(HPTag, 0.5, 1, 0)
    UIFrameFadeOut(PPTag, 0.5, 1, 0)
    UIFrameFadeOut(NameTag, 0.5, 1, 0)
    UIFrameFadeIn(Portrait, 0.5, 0, 0.3)
end

local function PortraitFadeOut(...)
    UIFrameFadeIn(HPTag, 0.5, 0, 1)
    UIFrameFadeIn(PPTag, 0.5, 0, 1)
    UIFrameFadeIn(NameTag, 0.5, 0, 1)
    UIFrameFadeOut(Portrait, 0.5, 0.3, 0)
end

local function CreatePower(self, ...)
    local power = CreateFrame("StatusBar", nil, self)
    power:SetPoint("BOTTOM", self)
    power:SetSize(self:GetWidth(), 4)
    power:SetStatusBarTexture(DB.Statusbar)
    
    power.bg = power:CreateTexture(nil, "BACKGROUND")
    power.bg:SetTexture(DB.Statusbar)
    power.bg:SetAllPoints()
    power.bg:SetVertexColor(0.12, 0.12, 0.12)
    power.bg.multiplier = 0.2
    
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
    health:SetSize(self:GetWidth(), self:GetHeight() - 8)
    
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
    NameTag = S.MakeText(self.Health, 11)
    NameTag:SetAlpha(0)
    NameTag:SetPoint("LEFT", 2, 0)
    self:Tag(NameTag, "[Sora:Level] [Sora:Color][name]")
    
    HPTag = S.MakeText(self.Health, 11)
    HPTag:SetAlpha(0)
    HPTag:SetPoint("RIGHT", 0, 0)
    self:Tag(HPTag, "[Sora:Color][Sora:HP]" .. " | " .. '[Sora:PerHP]')
    
    PPTag = S.MakeText(self.Power, 9)
    PPTag:SetAlpha(0)
    PPTag:SetPoint("RIGHT", 0, 0)
    self:Tag(PPTag, "[Sora:PP]" .. " | " .. "[Sora:PerPP]")
end

local function CreateAura(self, ...)
    local spacing = 4
    local size = (self:GetWidth() + 4 * 9) / 10
    local auras = CreateFrame("Frame", nil, self)
    auras:SetSize(self:GetWidth(), size * 3 + spacing * 2)
    auras:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -spacing)
    
    auras.num = 30
    auras.numBuffs = 10
    auras.gap = true
    auras.size = size
    auras.spacing = spacing
    auras["growth-y"] = "DOWN"
    auras["growth-x"] = "RIGHT"
    auras.onlyShowPlayer = false
    auras.disableCooldown = false
    auras.initialAnchor = "TOPLEFT"
    
    auras.PostCreateIcon = function(self, button)
        if not button.shadow then
            button.shadow = S.MakeShadow(button, 2)
            
            button.icon:SetAllPoints()
            button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            
            button.count = S.MakeText(button, 10)
            button.count:SetPoint("BOTTOMRIGHT", 3, 0)
        end
    end
    
    self.Auras = auras
end

local function CreateCastbar(self, ...)
    local height = C.UnitFrame.FocusTarget.Height - 4
    local width = self:GetWidth() - C.UnitFrame.FocusTarget.Width - 8 - height;
    
    local Castbar = CreateFrame("StatusBar", nil, self)
    Castbar:SetSize(width, height)
    Castbar:SetStatusBarTexture(DB.Statusbar)
    Castbar:SetStatusBarColor(95 / 255, 182 / 255, 255 / 255)
    Castbar:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -height - 4, 8)
    
    Castbar.Shadow = S.MakeShadow(Castbar, 2)
    Castbar.Shadow:SetBackdrop({
        edgeSize = 3,
        edgeFile = DB.GlowTex,
        bgFile = DB.Statusbar,
        insets = {left = 3, right = 3, top = 3, bottom = 3},
    })
    Castbar.Shadow:SetBackdropColor(0, 0, 0, 0.5)
    Castbar.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
    
    Castbar.Text = S.MakeText(Castbar, 10)
    Castbar.Text:SetPoint("LEFT", 2, 0)
    
    Castbar.Time = S.MakeText(Castbar, 10)
    Castbar.Time:SetPoint("RIGHT", -2, 0)
    
    Castbar.Icon = Castbar:CreateTexture(nil, "ARTWORK")
    Castbar.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    Castbar.Icon:SetPoint("LEFT", Castbar, "RIGHT", 4, 0)
    Castbar.Icon:SetSize(Castbar:GetHeight(), Castbar:GetHeight())
    Castbar.Icon.Shadow = S.MakeTextureShadow(Castbar, Castbar.Icon, 2)
    
    Castbar.SafeZone = Castbar:CreateTexture(nil, "OVERLAY")
    Castbar.SafeZone:SetVertexColor(1.0, 0.1, 0.0, 0.6)
    
    if S.Castbar then
        Castbar.Lag = S.MakeText(Castbar, 10)
        Castbar.Lag:Hide()
        Castbar.Lag:SetPoint("CENTER", -2, 17)
        self:RegisterEvent("UNIT_SPELLCAST_SENT", S.Castbar.OnCastSent)
        
        Castbar.CastingColor = {95 / 255, 182 / 255, 255 / 255}
        Castbar.CompleteColor = {20 / 255, 208 / 255, 0 / 255}
        Castbar.FailColor = {255 / 255, 12 / 255, 0 / 255}
        Castbar.ChannelingColor = {95 / 255, 182 / 255, 255 / 255}
        
        Castbar.OnUpdate = S.Castbar.OnCastbarUpdate
        Castbar.PostCastStart = S.Castbar.PostCastStart
        Castbar.PostChannelStart = S.Castbar.PostCastStart
        Castbar.PostCastStop = S.Castbar.PostCastStop
        Castbar.PostChannelStop = S.Castbar.PostChannelStop
        Castbar.PostCastFailed = S.Castbar.PostCastFailed
        Castbar.PostCastInterrupted = S.Castbar.PostCastFailed
    end
    
    self.Castbar = Castbar
end

local function CreatePortrait(self, ...)
    Portrait = CreateFrame("PlayerModel", nil, self.Health)
    Portrait:SetAlpha(0.3)
    Portrait:SetAllPoints()
    Portrait:SetFrameLevel(self.Health:GetFrameLevel() + 1)
    
    self.Portrait = Portrait
end

local function CreateRaidIcon(self, ...)
    local RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
    RaidIcon:SetSize(16, 16)
    RaidIcon:SetPoint("CENTER", self.Health, "TOP", 0, 2)
    
    self.RaidIcon = RaidIcon
end

local function CreateCombatIcon(self, ...)
    local Leader = self.Health:CreateTexture(nil, "OVERLAY")
    Leader:SetSize(16, 16)
    Leader:SetPoint("TOPLEFT", self, -7, 9)
    self.Leader = Leader
    
    local Assistant = self.Health:CreateTexture(nil, "OVERLAY")
    Assistant:SetAllPoints(Leader)
    self.Assistant = Assistant
    
    local MasterLooter = self.Health:CreateTexture(nil, "OVERLAY")
    MasterLooter:SetSize(16, 16)
    MasterLooter:SetPoint("LEFT", Leader, "RIGHT")
    self.MasterLooter = MasterLooter
end

local function RegisterForEvent(self, ...)
    self:HookScript("OnLeave", function(self, event, ...)
        if not UnitAffectingCombat("player") then
            PortraitFadeIn()
        end
    end)
    
    self:HookScript("OnEnter", function(self, event, ...)
        if not UnitAffectingCombat("player") then
            PortraitFadeOut()
        end
    end)
end

local function RegisterStyle(self, ...)
    self:RegisterForClicks("AnyUp")
    self:SetPoint(unpack(C.UnitFrame.Focus.Postion))
    self:SetSize(C.UnitFrame.Focus.Width, C.UnitFrame.Focus.Height)
    
    CreatePower(self, ...)
    CreateHealth(self, ...)
    
    CreateTag(self, ...)
    CreateAura(self, ...)
    CreateCastbar(self, ...)
    CreatePortrait(self, ...)
    CreateRaidIcon(self, ...)
    CreateCombatIcon(self, ...)
    
    RegisterForEvent(self, ...)
end

local function OnPlayerLogin(self, event, ...)
    oUF:RegisterStyle("oUF_Sora_Focus", RegisterStyle)
    oUF:SetActiveStyle("oUF_Sora_Focus")
    
    local oUFFrame = oUF:Spawn("focus", "oUF_Sora_Focus")
end

local function OnPlayerRegenEnable(self, event, ...)
    PortraitFadeIn()
end

local function OnPlayerRegenDisable(self, event, ...)
    PortraitFadeOut()
end

local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:RegisterEvent("PLAYER_REGEN_ENABLED")
Event:RegisterEvent("PLAYER_REGEN_DISABLED")
Event:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, ...)
    elseif event == "PLAYER_REGEN_ENABLED" then
        OnPlayerRegenEnable(self, event, ...)
    elseif event == "PLAYER_REGEN_DISABLED" then
        OnPlayerRegenDisable(self, event, ...)
    end
end)

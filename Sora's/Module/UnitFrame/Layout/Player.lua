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

local function SetPower(self, ...)
    local power = CreateFrame("StatusBar", nil, self)
    power:SetPoint("BOTTOM")
    power:SetSize(self:GetWidth(), 4)
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

local function SetHealth(self, ...)
    local health = CreateFrame("StatusBar", nil, self)
    health:SetPoint("TOP")
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

local function SetTag(self, ...)
    NameTag = S.MakeText(self.Health, 12)
    NameTag:SetAlpha(0.00)
    NameTag:SetPoint("LEFT", 4, 0)
    self:Tag(NameTag, "[Sora:Level][Sora:Rare][Sora:Color][Sora:Name]|r")
    
    HPTag = S.MakeText(self.Health, 12)
    HPTag:SetAlpha(0.00)
    HPTag:SetPoint("RIGHT", -4, 0)
    self:Tag(HPTag, "[Sora:Color][Sora:Health]|r | [Sora:Color][Sora:PerHealth]|r")
    
    PPTag = S.MakeText(self.Power, 9)
    PPTag:SetAlpha(0.00)
    PPTag:SetPoint("RIGHT", -4, 0)
    self:Tag(PPTag, "[Sora:Power] | [Sora:PerPower]")
end

local function SetDebuff(self, ...)
    local spacing = 4
    local size = (self:GetWidth() - 4 * 8) / 9
    
    local debuffs = CreateFrame("Frame", nil, self)
    debuffs:SetSize(self:GetWidth(), size * 2 + spacing)
    debuffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -spacing)
    
    debuffs.num = 18
    debuffs.size = size
    debuffs.spacing = spacing
    debuffs["growth-y"] = "DOWN"
    debuffs["growth-x"] = "RIGHT"
    debuffs.disableCooldown = false
    debuffs.initialAnchor = "TOPLEFT"
    
    debuffs.PostCreateIcon = function(self, icon, ...)
        if not icon.isProcessed then
            icon.shadow = S.MakeShadow(icon, 2)
            
            icon.icon:SetAllPoints()
            icon.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            
            icon.count = S.MakeText(icon, 10)
            icon.count:SetPoint("BOTTOMRIGHT", 3, 0)
            
            icon.isProcessed = true
        end
    end
    
    self.Debuffs = debuffs
end

local function SetCastbar(self, ...)
    local Castbar = CreateFrame("StatusBar", nil, self)
    Castbar:SetStatusBarTexture(DB.Statusbar)
    Castbar:SetStatusBarColor(95 / 255, 182 / 255, 255 / 255)
    Castbar:SetSize(C.ActionBar.Size * 18 + C.ActionBar.Space * 16 - 24, 24)
    Castbar:SetPoint("BOTTOMLEFT", "MultiBarBottomRightButton1", "TOPLEFT", 0, C.ActionBar.Size + C.ActionBar.Space * 2)
    
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
    Castbar.Icon:SetSize(Castbar:GetHeight(), Castbar:GetHeight())
    Castbar.Icon:SetPoint("LEFT", Castbar, "RIGHT", C.ActionBar.Space, 0)
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

local function SetPortrait(self, ...)
    Portrait = CreateFrame("PlayerModel", nil, self.Health)
    Portrait:SetAlpha(0.3)
    Portrait:SetAllPoints()
    Portrait:SetFrameLevel(self.Health:GetFrameLevel() + 1)
    
    self.Portrait = Portrait
end

local function SetRaidIcon(self, ...)
    local RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
    RaidIcon:SetSize(16, 16)
    RaidIcon:SetPoint("CENTER", self.Health, "TOP", 0, 0)
    
    self.RaidIcon = RaidIcon
end

local function SetMiscIcon(self, ...)
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
    
    local Resting = self.Health:CreateTexture(nil, "OVERLAY")
    Resting:SetSize(16, 16)
    Resting:SetPoint("TOPRIGHT", self.Health, "TOPLEFT", 0, 4)
    self.Resting = Resting
    
    local Combat = self.Health:CreateTexture(nil, "OVERLAY")
    Combat:SetSize(16, 16)
    Combat:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMLEFT", 0, -4)
    self.Combat = Combat
end

local function SetClassIcons(self, ...)
    if DB.MyClass == "DEATHKNIGHT" then
        local Runes = {}
        
        for i = 1, 6 do
            local Rune = CreateFrame("StatusBar", nil, self)
            Rune:SetStatusBarTexture(DB.Statusbar)
            Rune:SetSize((self:GetWidth() - 20) / 6, 4)
            Rune:SetStatusBarColor(0.50, 0.33, 0.67)
            
            Rune.BG = Rune:CreateTexture(nil, "BACKGROUND")
            Rune.BG:SetAllPoints()
            Rune.BG:SetTexture(DB.Statusbar)
            Rune.BG:SetVertexColor(0.12, 0.12, 0.12)
            Rune.Shadow = S.MakeShadow(Rune, 2)
            
            if i == 1 then
                Rune:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 4)
            else
                Rune:SetPoint("LEFT", Runes[i - 1], "RIGHT", 4, 0)
            end
            
            Runes[i] = Rune
        end
        
        self.Runes = Runes
    else
        local Colors = {}
        Colors["MAGE"] = {0.83, 0.50, 0.83}
        Colors["MONK"] = {0.00, 0.80, 0.60}
        Colors["PALADIN"] = {1.00, 1.00, 0.40}
        Colors["WARLOCK"] = {0.67, 0.33, 0.67}
        
        local ClassIcons = {}
        
        for i = 1, 8 do
            local ClassIcon = CreateFrame("StatusBar", nil, self)
            ClassIcon:SetStatusBarTexture(DB.Statusbar)
            ClassIcon:SetStatusBarColor(unpack(Colors[DB.MyClass] or {0.81, 0.03, 0.03}))
            
            ClassIcon.BG = CreateFrame("StatusBar", nil, self)
            ClassIcon.BG:SetFrameLevel(0)
            ClassIcon.BG:SetStatusBarTexture(DB.Statusbar)
            ClassIcon.BG:SetStatusBarColor(0.12, 0.12, 0.12)
            ClassIcon.BG.Shadow = S.MakeShadow(ClassIcon.BG, 2)
            
            ClassIcons[i] = ClassIcon
        end
        
        ClassIcons.PostUpdate = function(element, cur, max, hasMaxChanged, powerType, event)
            if not max then
                return
            end
            
            if hasMaxChanged then
                for i = max, 8 do
                    ClassIcons[i]:ClearAllPoints()
                    ClassIcons[i].BG:ClearAllPoints()
                end
                
                for i = 1, max do
                    ClassIcons[i]:SetSize((self:GetWidth() - (max - 1) * 4) / max, 4)
                    ClassIcons[i].BG:SetSize((self:GetWidth() - (max - 1) * 4) / max, 4)
                    
                    if i == 1 then
                        ClassIcons[i]:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 4)
                        ClassIcons[i].BG:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 4)
                    else
                        ClassIcons[i]:SetPoint("LEFT", ClassIcons[i - 1], "RIGHT", 4, 0)
                        ClassIcons[i].BG:SetPoint("LEFT", ClassIcons[i - 1], "RIGHT", 4, 0)
                    end
                end
            end
        end
        
        self.ClassIcons = ClassIcons
    end
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
    self:SetPoint(unpack(C.UnitFrame.Player.Postion))
    self:SetSize(C.UnitFrame.Player.Width, C.UnitFrame.Player.Height)
    
    SetPower(self, ...)
    SetHealth(self, ...)
    
    SetTag(self, ...)
    SetDebuff(self, ...)
    SetCastbar(self, ...)
    SetPortrait(self, ...)
    SetRaidIcon(self, ...)
    SetMiscIcon(self, ...)
    SetClassIcons(self, ...)
    
    RegisterForEvent(self, ...)
end

local function OnPlayerLogin(self, event, ...)
    oUF:RegisterStyle("oUF_Sora_Player", RegisterStyle)
    oUF:SetActiveStyle("oUF_Sora_Player")
    
    local oUFFrame = oUF:Spawn("player", "oUF_Sora_Player")
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

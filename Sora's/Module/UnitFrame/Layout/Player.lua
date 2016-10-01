-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local HPTag, PPTag, NameTag, Portrait = nil

local function CreatePowerBar(self, ...)
    local Power = CreateFrame("StatusBar", nil, self)
    Power:SetPoint("BOTTOM")
    Power:SetSize(self:GetWidth(), 4)
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
    Health:SetSize(self:GetWidth(), self:GetHeight() - 8)
    
    Health.BG = Health:CreateTexture(nil, "BACKGROUND")
    Health.BG:SetAllPoints()
    Health.BG:SetTexture(DB.Statusbar)
    Health.BG:SetVertexColor(0.12, 0.12, 0.12)
    Health.BG.multiplier = 0.2
    
    Health.Smooth = true
    Health.colorClass = true
    Health.frequentUpdates = true
    Health.Shadow = S.MakeShadow(Health, 2)
    
    self.Health = Health
end

local function CreateTag(self, ...)
    NameTag = S.MakeText(self.Health, 11)
    NameTag:SetAlpha(0)
    NameTag:SetPoint("LEFT", 2, 0)
    self:Tag(NameTag, "[Sora:Level] [Sora:Color][name]")
    
    HPTag = S.MakeText(self.Health, 11)
    HPTag:SetAlpha(0)
    HPTag:SetPoint("RIGHT", 0, 0)
    self:Tag(HPTag, "[Sora:Color][Sora:HP]" .. " | " .. "[Sora:PerHP]")
    
    PPTag = S.MakeText(self.Power, 9)
    PPTag:SetAlpha(0)
    PPTag:SetPoint("RIGHT", 0, 0)
    self:Tag(PPTag, "[Sora:PP]" .. " | " .. "[Sora:PerPP]")
end

local function CreateCombat(self, ...)
    local Combat = self.Health:CreateTexture(nil, "OVERLAY")
    Combat:SetSize(18, 18)
    Combat:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMLEFT", 0, -4)
    
    self.Combat = Combat
end

local function CreateDebuff(self, ...)
    local Size, Spacing = 20, 4
    local Debuffs = CreateFrame("Frame", nil, self)
    
    Debuffs.size = Size
    Debuffs.spacing = Spacing
    Debuffs["growth-y"] = "DOWN"
    Debuffs["growth-x"] = "RIGHT"
    Debuffs.disableCooldown = false
    Debuffs.initialAnchor = "TOPLEFT"
    Debuffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
    Debuffs:SetSize(self:GetWidth(), Size * 3 + Spacing * 2)
    Debuffs.num = floor((self:GetWidth() + Spacing) / (Size + Spacing)) * 3
    
    Debuffs.PostCreateIcon = function(self, btn)
        if not btn.Shadow then
            btn.Shadow = S.MakeShadow(btn, 2)
            
            btn.icon:SetAllPoints()
            btn.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            
            btn.count = S.MakeText(btn, 10)
            btn.count:SetPoint("BOTTOMRIGHT", 3, 0)
        end
    end
    
    self.Debuffs = Debuffs
end

local function CreateCastbar(self, ...)
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

local function CreateResting(self, ...)
    local Resting = self.Health:CreateTexture(nil, "OVERLAY")
    Resting:SetSize(18, 18)
    Resting:SetPoint("TOPRIGHT", self.Health, "TOPLEFT", 0, 4)
    
    self.Resting = Resting
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
    RaidIcon:SetPoint("CENTER", self.Health, "TOP", 0, 0)
    
    self.RaidIcon = RaidIcon
end

local function CreateRunes(self, ...)
    if DB.MyClass ~= "DEATHKNIGHT" then
        return
    end
    
    local Runes = {}
    
    for i = 1, 6 do
        local Rune = CreateFrame("StatusBar", nil, self)
        Rune:SetStatusBarTexture(DB.Statusbar)
        Rune:SetSize((self:GetWidth() - 25) / 6, 4)
        Rune:SetStatusBarColor(0.50, 0.33, 0.67)
        
        Rune.BG = Rune:CreateTexture(nil, "BACKGROUND")
        Rune.BG:SetAllPoints()
        Rune.BG:SetTexture(DB.Statusbar)
        Rune.BG:SetVertexColor(0.12, 0.12, 0.12)
        Rune.Shadow = S.MakeShadow(Rune, 2)
        
        if i == 1 then
            Rune:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 4)
        else
            Rune:SetPoint("LEFT", Runes[i - 1], "RIGHT", 5, 0)
        end
        
        Runes[i] = Rune
    end
    
    self.Runes = Runes
end

local function CreateCPoints(self, ...)
    local CPoints = {}
    
    for i = 1, MAX_COMBO_POINTS do
        local CPoint = CreateFrame("StatusBar", nil, self)
        CPoint:SetStatusBarTexture(DB.Statusbar)
        CPoint:SetStatusBarColor(0.81, 0.03, 0.03)
        CPoint:SetSize((self:GetWidth() - (MAX_COMBO_POINTS - 1) * 5) / MAX_COMBO_POINTS, 4)
        
        CPoint.BG = CPoint:CreateTexture(nil, "BACKGROUND")
        CPoint.BG:SetAllPoints()
        CPoint.BG:SetTexture(DB.Statusbar)
        CPoint.BG:SetVertexColor(0.12, 0.12, 0.12)
        CPoint.Shadow = S.MakeShadow(CPoint, 2)
        
        if i == 1 then
            CPoint:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 4)
        else
            CPoint:SetPoint("LEFT", CPoints[i - 1], "RIGHT", 5, 0)
        end
        
        CPoints[i] = CPoint
    end
    
    self.CPoints = CPoints
end

local function CreateClassIcons(self, ...)
    if DB.MyClass ~= "MAGE" and DB.MyClass ~= "MONK" and DB.MyClass ~= "PALADIN" and DB.MyClass ~= "WARLOCK" then
        return
    end
    
    
    local Colors = {}
    Colors["MAGE"] = {0.83, 0.50, 0.83}
    Colors["MONK"] = {0.00, 0.80, 0.60}
    Colors["PALADIN"] = {1.00, 1.0, 0.40}
    Colors["WARLOCK"] = {0.67, 0.33, 0.67}
    
    local ClassIcons = {}
    
    for i = 1, 8 do
        local ClassIcon = CreateFrame("StatusBar", nil, self)
        ClassIcon:SetStatusBarTexture(DB.Statusbar)
        ClassIcon:SetStatusBarColor(unpack(Colors[DB.MyClass]))
        
        ClassIcon.BG = CreateFrame("StatusBar", nil, self)
        ClassIcon.BG:SetFrameLevel(0)
        ClassIcon.BG:SetStatusBarTexture(DB.Statusbar)
        ClassIcon.BG:SetStatusBarColor(0.12, 0.12, 0.12)
        ClassIcon.BG.Shadow = S.MakeShadow(ClassIcon.BG, 2)
        
        ClassIcons[i] = ClassIcon
    end
    
    ClassIcons.PostUpdate = function(element, cur, max, hasMaxChanged, powerType, event)
        if not max then return end
        
        if hasMaxChanged then
            for i = max, 8 do
                ClassIcons[i]:ClearAllPoints()
                ClassIcons[i].BG:ClearAllPoints()
            end
            
            for i = 1, max do
                ClassIcons[i]:SetSize((self:GetWidth() - (max - 1) * 5) / max, 4)
                ClassIcons[i].BG:SetSize((self:GetWidth() - (max - 1) * 5) / max, 4)
                
                if i == 1 then
                    ClassIcons[i]:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 4)
                    ClassIcons[i].BG:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 4)
                else
                    ClassIcons[i]:SetPoint("LEFT", ClassIcons[i - 1], "RIGHT", 5, 0)
                    ClassIcons[i].BG:SetPoint("LEFT", ClassIcons[i - 1], "RIGHT", 5, 0)
                end
            end
        end
    end
    
    self.ClassIcons = ClassIcons
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

local function RegisterForClicks(self, ...)
    self.menu = function(self)
        local unit = self.unit:sub(1, -2)
        local cunit = self.unit:gsub("^%l", string.upper)
        
        if cunit == "Vehicle" then cunit = "Pet" end
        
        if unit == "party" or unit == "partypet" then
            ToggleDropDownMenu(1, nil, _G["PartyMemberFrame" .. self.id .. "DropDown"], "cursor", 0, 0)
        elseif _G[cunit .. "FrameDropDown"] then
            ToggleDropDownMenu(1, nil, _G[cunit .. "FrameDropDown"], "cursor", 0, 0)
        end
    end
    
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:RegisterForClicks("AnyUp")
end

local function CreatePlayer(self, ...)
    self:SetSize(unpack(C.UnitFrame.PlayerSize))
    self:SetPoint(unpack(C.UnitFrame.PlayerPostion))
    
    CreatePowerBar(self, ...)
    CreateHealthBar(self, ...)
    
    CreateRunes(self, ...)
    CreateClassIcons(self, ...)
    
    CreateTag(self, ...)
    CreateCombat(self, ...)
    CreateDebuff(self, ...)
    CreateCastbar(self, ...)
    CreateResting(self, ...)
    CreateCPoints(self, ...)
    CreatePortrait(self, ...)
    CreateRaidIcon(self, ...)
    CreateCombatIcon(self, ...)
    RegisterForClicks(self, ...)
end

local function OnPlayerLogin(self, event, ...)
    oUF:RegisterStyle("Player", CreatePlayer)
    oUF:SetActiveStyle("Player")
    
    local Frame = oUF:Spawn("player", "oUF_SoraPlayer")
    Frame:HookScript("OnLeave", function()
        if not UnitAffectingCombat("player") then
            UIFrameFadeOut(HPTag, 0.5, 1, 0)
            UIFrameFadeOut(PPTag, 0.5, 1, 0)
            UIFrameFadeOut(NameTag, 0.5, 1, 0)
            UIFrameFadeIn(Portrait, 0.5, 0, 0.3)
        end
    end)
    Frame:HookScript("OnEnter", function()
        if not UnitAffectingCombat("player") then
            UIFrameFadeIn(HPTag, 0.5, 0, 1)
            UIFrameFadeIn(PPTag, 0.5, 0, 1)
            UIFrameFadeIn(NameTag, 0.5, 0, 1)
            UIFrameFadeOut(Portrait, 0.5, 0.3, 0)
        end
    end)
end

local function OnPlayerRegenEnable(self, event, ...)
    UIFrameFadeOut(HPTag, 0.5, 1, 0)
    UIFrameFadeOut(PPTag, 0.5, 1, 0)
    UIFrameFadeOut(NameTag, 0.5, 1, 0)
    UIFrameFadeIn(Portrait, 0.5, 0, 0.3)
end

local function OnPlayerRegenDisable(self, event, ...)
    UIFrameFadeIn(HPTag, 0.5, 0, 1)
    UIFrameFadeIn(PPTag, 0.5, 0, 1)
    UIFrameFadeIn(NameTag, 0.5, 0, 1)
    UIFrameFadeOut(Portrait, 0.5, 0.3, 0)
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

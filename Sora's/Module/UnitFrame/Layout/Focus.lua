-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local HPTag, PPTag, NameTag, Portrait = nil

local function CreatePowerBar(self, ...)
    local Power = CreateFrame("StatusBar", nil, self)
    Power:SetPoint("BOTTOM", self)
    Power:SetSize(self:GetWidth(), 4)
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
    Health:SetSize(self:GetWidth(), self:GetHeight() - 8)
    
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
    self:Tag(HPTag, "[Sora:Color][Sora:HP]" .. " | " .. '[Sora:PerHP]')
    
    PPTag = S.MakeText(self.Power, 9)
    PPTag:SetAlpha(0)
    PPTag:SetPoint("RIGHT", 0, 0)
    self:Tag(PPTag, "[Sora:PP]" .. " | " .. "[Sora:PerPP]")
end

local function CreateAura(self, ...)
    local Size, Spacing = 20, 4
    local Auras = CreateFrame("Frame", nil, self)
    Auras:SetSize(self:GetWidth(), Size * 3 + Spacing * 2)
    Auras:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -Spacing)
    
    Auras.gap = true
    Auras.size = Size
    Auras.spacing = Spacing
    Auras["growth-y"] = "DOWN"
    Auras["growth-x"] = "RIGHT"
    Auras.onlyShowPlayer = false
    Auras.disableCooldown = false
    Auras.initialAnchor = "TOPLEFT"
    Auras.num = floor((self:GetWidth() + Spacing) / (Size + Spacing)) * 3
    Auras.numBuffs = floor((self:GetWidth() + Spacing) / (Size + Spacing)) * 2
    
    Auras.PostCreateIcon = function(self, btn)
        if not btn.Shadow then
            btn.Shadow = S.MakeShadow(btn, 2)
            
            btn.icon:SetAllPoints()
            btn.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            
            btn.count = S.MakeText(btn, 10)
            btn.count:SetPoint("BOTTOMRIGHT", 3, 0)
        end
    end
    
    Auras.PostUpdateIcon = function(self, unit, btn, index, offset, filter, isDebuff)
        local Caster = select(8, UnitAura(unit, index, btn.filter))
        if btn.debuff then
            if Caster == "player" or Caster == "vehicle" then
                btn.icon:SetDesaturated(false)
            elseif not UnitPlayerControlled(unit) then -- If Unit is Player Controlled dont desaturate debuffs
                btn:SetBackdropColor(0, 0, 0)
                btn.icon:SetDesaturated(true)
                btn.overlay:SetVertexColor(0.3, 0.3, 0.3)
            end
        end
    end
    
    self.Auras = Auras
end

local function CreateCastbar(self, ...)
    local focusTargtWidth, focusTargtHeight = unpack(C.UnitFrame.FocusTargetSize)
    
    local height = focusTargtHeight - 4
    local width = self:GetWidth() - focusTargtWidth - 8 - height;
    
    local Castbar = CreateFrame("StatusBar", nil, self)
    Castbar:SetSize(width, height)
    Castbar:SetStatusBarTexture(DB.Statusbar)
    Castbar:SetStatusBarColor(95 / 255, 182 / 255, 255 / 255)
    Castbar:SetPoint("BOTTOMLEFT", _G["oUF_SoraFocus"], "TOPLEFT", focusTargtWidth + 4, 4 + 4)
    
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

local function CreateFocus(self, ...)
    self:SetSize(unpack(C.UnitFrame.FocusSize))
    self:SetPoint(unpack(C.UnitFrame.FocusPostion))
    
    CreatePowerBar(self, ...)
    CreateHealthBar(self, ...)
    
    CreateTag(self, ...)
    CreateAura(self, ...)
    CreateCastbar(self, ...)
    CreatePortrait(self, ...)
    CreateRaidIcon(self, ...)
    CreateCombatIcon(self, ...)
    RegisterForClicks(self, ...)
end

local function OnPlayerLogin(self, event, ...)
    oUF:RegisterStyle("Focus", CreateFocus)
    oUF:SetActiveStyle("Focus")
    
    local Frame = oUF:Spawn("focus", "oUF_SoraFocus")
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

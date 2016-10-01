-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))

-- Variables
local width, height = 48, 6

-- Begin
local function SetAnchor(self, ...)
    self:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -C.MiniMap.ERBarHeight)
    self:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0, -C.MiniMap.ERBarHeight * 4)
end

local function OnLeave(self, event, ...)
    GameTooltip:Hide()
end

local function OnExperienceBarEnter(self, event, ...)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:ClearLines()
    
    GameTooltip:AddLine(self.onEnterInfoLine:GetText(), 0.40, 0.78, 1.00)
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine("经验：", self.onEnterValueLine:GetText(), 1.00, 1.00, 1.00)
    GameTooltip:AddDoubleLine("休息：", self.onEnterRestedLine:GetText(), 1.00, 1.00, 1.00)
    
    GameTooltip:Show()
end

local function OnReputationBarEnter(self, event, ...)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:ClearLines()
    
    GameTooltip:AddLine(self.onEnterInfoLine:GetText(), 0.40, 0.78, 1.00)
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine("声望：", self.onEnterValueLine:GetText(), 1.00, 1.00, 1.00)
    
    GameTooltip:Show()
end

local function SetExperienceBar(self, ...)
    local experience = CreateFrame("StatusBar", nil, self)
    experience:SetSize(width, height)
    experience:SetStatusBarTexture(DB.Statusbar)
    experience:SetPoint("TOPLEFT", Minimap, "TOPRIGHT", 8, -height * 6)
    
    experience.rested = CreateFrame("StatusBar", nil, experience)
    experience.rested:SetAllPoints(experience)
    experience.rested:SetStatusBarTexture(DB.Statusbar)
    experience.shadow = S.MakeShadow(experience, 2)
    
    experience.text = S.MakeText(experience, 10)
    experience.text:SetText("N/A")
    experience.text:SetPoint("CENTER", 0, -4)
    self:Tag(experience.text, "[perxp]%")
    
    experience.bg = experience.rested:CreateTexture(nil, "BACKGROUND")
    experience.bg:SetTexture(DB.Statusbar)
    experience.bg:SetAllPoints()
    experience.bg:SetVertexColor(0.12, 0.12, 0.12)
    
    experience:SetScript("OnLeave", OnLeave)
    experience:SetScript("OnEnter", OnExperienceBarEnter)
    
    experience.onEnterInfoLine = S.MakeText(experience, 10)
    experience.onEnterInfoLine:ClearAllPoints()
    self:Tag(experience.onEnterInfoLine, "[class] - Lv.[level]")
    
    experience.onEnterValueLine = S.MakeText(experience, 10)
    experience.onEnterValueLine:ClearAllPoints()
    self:Tag(experience.onEnterValueLine, "[curxp]/[maxxp] - [perxp]%")
    
    experience.onEnterRestedLine = S.MakeText(experience, 10)
    experience.onEnterRestedLine:ClearAllPoints()
    self:Tag(experience.onEnterRestedLine, "[currested] - [perrested]%")
    
    self.Experience = experience
    self.Experience.Rested = experience.rested
end

local function SetReputationBar(self, ...)
    local reputation = CreateFrame("StatusBar", nil, self)
    reputation:SetSize(width, height)
    reputation:SetStatusBarTexture(DB.Statusbar)
    reputation:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMRIGHT", 8, height * 7)
    
    reputation.colorStanding = true
    reputation.shadow = S.MakeShadow(reputation, 2)
    
    reputation.text = S.MakeText(reputation, 10)
    reputation.text:SetText("N/A")
    reputation.text:SetPoint("CENTER", 0, -4)
    self:Tag(reputation.text, "[perrep]%")
    
    reputation.bg = reputation:CreateTexture(nil, "BACKGROUND")
    reputation.bg:SetTexture(DB.Statusbar)
    reputation.bg:SetAllPoints()
    reputation.bg:SetVertexColor(0.12, 0.12, 0.12)
    
    reputation:SetScript("OnLeave", OnLeave)
    reputation:SetScript("OnEnter", OnReputationBarEnter)
    
    reputation.onEnterInfoLine = S.MakeText(reputation, 10)
    reputation.onEnterInfoLine:ClearAllPoints()
    self:Tag(reputation.onEnterInfoLine, "[reputation] - [standing]")
    
    reputation.onEnterValueLine = S.MakeText(reputation, 10)
    reputation.onEnterValueLine:ClearAllPoints()
    self:Tag(reputation.onEnterValueLine, "[currep]/[maxrep] - [perrep]%")
    
    self.Reputation = reputation
end

local function OnPlayerLogin(self, event, ...)
    oUF:RegisterStyle("ERBar", function(self, ...)
        SetAnchor(self, ...)
        SetExperienceBar(self, ...)
        SetReputationBar(self, ...)
    end)
    
    oUF:SetActiveStyle("ERBar")
    oUF:Spawn("player", "oUF_Sora_ERBar")
end

-- Event
local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, ...)
    end
end)

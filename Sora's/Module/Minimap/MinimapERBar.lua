-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))

-- Variables
local width, height = 48, 6

-- Begin
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
    experience:SetStatusBarTexture(DB.Statusbar)
    experience:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
    experience:SetSize(C.MiniMap.Width, C.MiniMap.BarHeight)
    
    experience.rested = CreateFrame("StatusBar", nil, experience)
    experience.rested:SetAllPoints(experience)
    experience.rested:SetStatusBarTexture(DB.Statusbar)
    experience.shadow = S.MakeShadow(experience, 2)
    
    experience.text = S.MakeText(experience, 12)
    experience.text:SetText("N/A")
    experience.text:SetPoint("CENTER", 0, 5)
    self:Tag(experience.text, "[perxp]%")
    
    experience.bg = experience.rested:CreateTexture(nil, "BACKGROUND")
    experience.bg:SetTexture(DB.Statusbar)
    experience.bg:SetAllPoints()
    experience.bg:SetVertexColor(0.12, 0.12, 0.12)
    
    experience:SetScript("OnLeave", OnLeave)
    experience:SetScript("OnEnter", OnExperienceBarEnter)
    
    experience.onEnterInfoLine = S.MakeText(experience, 12)
    experience.onEnterInfoLine:ClearAllPoints()
    self:Tag(experience.onEnterInfoLine, "[class] - Lv.[level]")
    
    experience.onEnterValueLine = S.MakeText(experience, 12)
    experience.onEnterValueLine:ClearAllPoints()
    self:Tag(experience.onEnterValueLine, "[curxp]/[maxxp] - [perxp]%")
    
    experience.onEnterRestedLine = S.MakeText(experience, 12)
    experience.onEnterRestedLine:ClearAllPoints()
    self:Tag(experience.onEnterRestedLine, "[currested] - [perrested]%")
    
    self.Experience = experience
    self.Experience.Rested = experience.rested
end

local function SetReputationBar(self, ...)
    local reputation = CreateFrame("StatusBar", nil, self)
    reputation:SetStatusBarTexture(DB.Statusbar)
    reputation:SetPoint("TOP", self, "TOP", 0, 0)
    reputation:SetSize(C.MiniMap.Width, C.MiniMap.BarHeight)
    
    reputation.colorStanding = true
    reputation.shadow = S.MakeShadow(reputation, 2)
    
    reputation.text = S.MakeText(reputation, 12)
    reputation.text:SetText("N/A")
    reputation.text:SetPoint("CENTER", 0, 5)
    self:Tag(reputation.text, "[perrep]%")
    
    reputation.bg = reputation:CreateTexture(nil, "BACKGROUND")
    reputation.bg:SetTexture(DB.Statusbar)
    reputation.bg:SetAllPoints()
    reputation.bg:SetVertexColor(0.12, 0.12, 0.12)
    
    reputation:SetScript("OnLeave", OnLeave)
    reputation:SetScript("OnEnter", OnReputationBarEnter)
    
    reputation.onEnterInfoLine = S.MakeText(reputation, 12)
    reputation.onEnterInfoLine:ClearAllPoints()
    self:Tag(reputation.onEnterInfoLine, "[reputation] - [standing]")
    
    reputation.onEnterValueLine = S.MakeText(reputation, 12)
    reputation.onEnterValueLine:ClearAllPoints()
    self:Tag(reputation.onEnterValueLine, "[currep]/[maxrep] - [perrep]%")
    
    self.Reputation = reputation
end

local function RegisterStyle(self, ...)
    self:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -C.MiniMap.BarHeight * 5 - 3 * 8)
    self:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0, -C.MiniMap.BarHeight * 8 - 4 * 8)
    
    SetExperienceBar(self, ...)
    SetReputationBar(self, ...)
end

local function OnPlayerLogin(self, event, ...)
    oUF:RegisterStyle("oUF_Sora_ERBar", RegisterStyle)
    oUF:SetActiveStyle("oUF_Sora_ERBar")
    
    local oUFFrame = oUF:Spawn("player", "oUF_Sora_ERBar")
end

-- Event
local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, ...)
    end
end)

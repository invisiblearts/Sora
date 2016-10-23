-- Engine
local S, C, L, DB = unpack(select(2, ...))
local _G, tsort, tinsert = _G, table.sort, tinsert

-- Variables
local BuffAnchor, DebuffAnchor = nil, nil

-- Begin
local function HookAuraButtonOnUpdate(self, elapsed, ...)
    if self.timeLeft >= BUFF_DURATION_WARNING_TIME then
        self:SetAlpha(1.00)
    else
        self:SetAlpha(BuffFrame.BuffAlphaValue)
    end
end

local function HookAuraButtonUpdateDuration(self, timeLeft, ...)
    if timeLeft then
        if timeLeft < BUFF_DURATION_WARNING_TIME then
            self.duration:SetTextColor(1.00, 0.00, 0.00)
        else
            self.duration:SetTextColor(0.96, 0.82, 0.10)
        end
    end
end

local function HookDebuffButtonUpdateAnchors(buttonName, index, ...)
    local auras = {}
    
    for i = 1, DEBUFF_MAX_DISPLAY do
        local aura = _G["DebuffButton" .. i]
        
        if aura and aura:IsShown() then
            table.insert(auras, aura)
        end
    end
    
    for key, value in pairs(auras) do
        value:ClearAllPoints()
        value:SetSize(C.Aura.Size, C.Aura.Size)
        
        if key == 1 then
            value:SetPoint("TOPRIGHT", DebuffAnchor, 0, 0)
        elseif key % 8 == 1 then
            value:SetPoint("TOP", auras[key - 8], "BOTTOM", 0, -C.Aura.Space)
        else
            value:SetPoint("RIGHT", auras[key - 1], "LEFT", -C.Aura.Space, 0)
        end
    end
end

local function HookBuffFrameUpdateAllBuffAnchors(self, ...)
    local auras = {}
    
    for i = 1, BUFF_MAX_DISPLAY do
        local aura = _G["BuffButton" .. i]
        
        if aura and aura:IsShown() then
            table.insert(auras, aura)
        end
    end
    
    for i = 1, #auras do
        auras[i].timeLeft = auras[i].timeLeft or 31 * 24 * 60 * 60
    end
    
    table.sort(auras, function(l, r)
        local result = false
        
        if l and not r then
            result = true
        elseif not l and r then
            result = false
        elseif not l and not r then
            result = false
        else
            result = l.timeLeft > r.timeLeft
        end
        
        return result
    end)
    
    for key, value in pairs(auras) do
        value:ClearAllPoints()
        value:SetSize(C.Aura.Size, C.Aura.Size)
        
        if key == 1 then
            value:SetPoint("TOPRIGHT", BuffAnchor, 0, 0)
        elseif key % 12 == 1 then
            value:SetPoint("TOP", auras[key - 12], "BOTTOM", 0, -C.Aura.Space)
        else
            value:SetPoint("RIGHT", auras[key - 1], "LEFT", -C.Aura.Space, 0)
        end
    end
end

local function OnPlayerLogin(self, event, ...)
    SetCVar("buffDurations", 1)
    
    BuffAnchor = CreateFrame("Frame", nil, UIParent)
    BuffAnchor:SetPoint(unpack(C.Aura.Postion))
    BuffAnchor:SetSize(C.Aura.Size * 12 + C.Aura.Size * 11, C.Aura.Size * 3 + C.Aura.Space * 2)
    
    DebuffAnchor = CreateFrame("Frame", nil, UIParent)
    DebuffAnchor:SetSize(C.Aura.Size * 8 + C.Aura.Size * 7, C.Aura.Size * 2 + C.Aura.Space)
    DebuffAnchor:SetPoint("TOPRIGHT", BuffAnchor, "BOTTOMRIGHT", 0, -C.Aura.Space)
    
    hooksecurefunc("AuraButton_OnUpdate", HookAuraButtonOnUpdate)
    hooksecurefunc("AuraButton_UpdateDuration", HookAuraButtonUpdateDuration)
    hooksecurefunc("DebuffButton_UpdateAnchors", HookDebuffButtonUpdateAnchors)
    hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", HookBuffFrameUpdateAllBuffAnchors)
end

-- Event
local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, ...)
    end
end)

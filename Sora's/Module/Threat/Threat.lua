﻿-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Variables
local bars, threats = nil, nil

-- Begin
local function UpdateThreat(unit)
    local name = UnitName(unit)
    local guid = UnitGUID(unit)
    local _, class = UnitClass(unit)
    
    if not guid then
        return
    end
    
    local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation(unit, "target")
    
    if not rawPercent then
        return
    end
    
    local threat = {}
    threat.guid = guid
    threat.name = name
    threat.status = status
    threat.isTanking = isTanking
    threat.rawPercent = rawPercent
    threat.classColor = RAID_CLASS_COLORS[class]
    
    table.insert(threats, threat)
end

local function UpdateAllThreats()
    threats = {}
    
    local mobiUnit = nil
    
    if UnitCanAttack("player", "target") then
        mobiUnit = "target"
    elseif UnitCanAttack("player", "targettarget") then
        mobiUnit = "targettarget"
    else
        return
    end
    
    UpdateThreat("pet", mobiUnit)
    UpdateThreat("player", mobiUnit)
    
    UpdateThreat("target", mobiUnit)
    UpdateThreat("targettarget", mobiUnit)
    
    for i = 1, 5 do
        UpdateThreat("party" .. i, mobiUnit)
        UpdateThreat("party" .. i .. "pet", mobiUnit)
    end
    
    for i = 1, 40 do
        UpdateThreat("raid" .. i, mobiUnit)
        UpdateThreat("raid" .. i .. "pet", mobiUnit)
    end
    
    local tempThreats = {}
    
    for k, v in pairs(threats) do
        tempThreats[v.guid] = v
    end
    
    table.wipe(threats)
    for k, v in pairs(tempThreats) do
        table.insert(threats, v)
    end
    
    table.sort(threats, function(l, r)
        local flag = false
        
        if not l.rawPercent and r.rawPercent then
            flag = false
        elseif l.rawPercent and not r.rawPercent then
            flag = true
        elseif l.rawPercent and r.rawPercent then
            flag = l.rawPercent > r.rawPercent
        end
        
        return flag
    end)
end

local function UpdateAllThreatBars()
    if #threats < 2 then
        for i = 1, 4 do
            bars[i]:Hide()
        end
    else
        for i = 1, 4 do
            if not bars[i] or not threats[i] then
                bars[i]:Hide()
            else
                local bar, threat = bars[i], threats[i]
                
                bar:Show()
                bar:SetValue(threat.rawPercent / 255 * 100)
                bar:SetStatusBarColor(threat.classColor.r, threat.classColor.g, threat.classColor.b)
                
                bar.infoText:SetText(i .. " - " .. threat.name)
                bar.valueText:SetText(("%2.f%%"):format(threat.rawPercent / 255 * 100))
            end
        end
    end
end


local function OnPlayerLogin(self, event, ...)
    bars = {}
    
    for i = 1, 4 do
        local bar = CreateFrame("StatusBar", nil, UIParent)
        bar:SetSize(256, 12)
        bar:SetMinMaxValues(0, 130)
        bar:SetStatusBarTexture(DB.Statusbar)
        
        bar.shadow = S.MakeShadow(bar, 2)
        bar.bg = bar:CreateTexture(nil, "BACKGROUND")
        bar.bg:SetTexture(DB.Statusbar)
        bar.bg:SetAllPoints()
        bar.bg:SetVertexColor(0.12, 0.12, 0.12)
        
        bar.infoText = S.MakeText(bar, 8)
        bar.infoText:SetPoint("LEFT", bar, "LEFT", 4, 0)
        
        bar.valueText = S.MakeText(bar, 8)
        bar.valueText:SetPoint("RIGHT", bar, "RIGHT", -4, 0)
        
        if i == 1 then
            bar:SetPoint("TOP", UIParent, "CENTER", -384, -190)
        else
            bar:SetPoint("TOP", bars[i - 1], "BOTTOM", 0, -4)
        end
        
        table.insert(bars, bar)
    end
end

local function OnPlayerTargetChanged(self, event, ...)
    UpdateAllThreats()
    UpdateAllThreatBars()
end

local function OnUnitThreatListUpdate(self, event, ...)
    UpdateAllThreats()
    UpdateAllThreatBars()
end

local function OnUnitThreatSituationUpdate(self, event, ...)
    UpdateAllThreats()
    UpdateAllThreatBars()
end

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:RegisterEvent("PLAYER_TARGET_CHANGED")
Event:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
Event:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
Event:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, ...)
    elseif event == "PLAYER_TARGET_CHANGED" then
        OnPlayerTargetChanged(self, event, ...)
    elseif event == "UNIT_THREAT_LIST_UPDATE" then
        OnUnitThreatListUpdate(self, event, ...)
    elseif event == "UNIT_THREAT_SITUATION_UPDATE" then
        OnUnitThreatSituationUpdate(self, event, ...)
    end
end)
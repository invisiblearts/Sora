-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local Width, Height = 256, 3
local ThreatList, ThreatFlag = {}, {}
local MainFrame = CreateFrame("Frame", nil, UIParent)
local Tank = CreateFrame("StatusBar", nil, MainFrame)

-- 更新仇恨列表
local function GetThreat(unit, pet)
    if UnitName(pet or unit) == UNKNOWN or not UnitIsVisible(pet or unit) then return end
    local isTanking, _, _, rawPercent = UnitDetailedThreatSituation(pet or unit, "target")
    local name = pet and UnitName(pet) or UnitName(unit)
    for index, value in ipairs(ThreatList) do
        if value.name == name then
            tremove(ThreatList, index)
            break
        end
    end
    tinsert(ThreatList, {
        name = name,
        class = select(2, UnitClass(unit)),
        rawPercent = rawPercent or 0,
        isTanking = isTanking or false,
    })
end
local function AddThreat(unit, pet)
    if UnitExists(pet) then
        GetThreat(unit)
        GetThreat(unit, pet)
    elseif GetNumGroupMembers() > 0 then
        GetThreat(unit)
    end
end
local function UpdateThreat()
    wipe(ThreatList)
    if UnitExists("target") and UnitCanAttack("player", "target") then
        AddThreat("player", "pet")
        
        if GetNumGroupMembers() > 0 then
            if IsInRaid() then
                for i = 1, GetNumGroupMembers() + 1 do
                    AddThreat("raid" .. i, "raid" .. i .. "pet")
                end
            else
                for i = 1, GetNumGroupMembers() do
                    AddThreat("party" .. i, "party" .. i .. "pet")
                end
            end
        end
    end
end

-- 更新仇恨标签
local function FormatName(name)
    if strupper(name) ~= name then
        return name:sub(1, 3)
    else
        return name:sub(1, 9)
    end
end
local function SortThreat(a, b)
    return a.rawPercent > b.rawPercent
end
local function UpdateThreatFlag()
    for key, value in ipairs(ThreatFlag) do value:Hide() end
    
    for key, value in ipairs(ThreatList) do
        if ThreatList[key].isTanking then
            local CLASS_COLORS = RAID_CLASS_COLORS[value.class]
            Tank.Arrow:SetVertexColor(CLASS_COLORS.r, CLASS_COLORS.g, CLASS_COLORS.b)
            Tank.Name:SetText(FormatName(value.name))
            Tank.Name:SetTextColor(CLASS_COLORS.r, CLASS_COLORS.g, CLASS_COLORS.b)
            Tank.Flag:Show()
            tremove(ThreatList, key)
            break
        end
    end
    
    table.sort(ThreatList, SortThreat)
    
    for key, value in pairs(ThreatFlag) do
        if ThreatList[key] then
            local CLASS_COLORS = RAID_CLASS_COLORS[ThreatList[key].class]
            value.Arrow:SetVertexColor(CLASS_COLORS.r, CLASS_COLORS.g, CLASS_COLORS.b)
            value.Name:SetText(FormatName(ThreatList[key].name))
            value.Name:SetTextColor(CLASS_COLORS.r, CLASS_COLORS.g, CLASS_COLORS.b)
            value:SetValue(ThreatList[key].rawPercent)
            value:Show()
        end
    end
end

-- 显隐控制
local function Fade()
    local Flag = false
    for key, value in pairs(ThreatList) do
        if value.rawPercent ~= 0 then Flag = true end
        if value.isTanking and (value.name == UnitName("player") or value.name == UnitName("pet")) then Flag = true end
    end
    if Flag and MainFrame:GetAlpha() < 0.05 then
        UIFrameFadeIn(MainFrame, 0.5, 0, 1)
    elseif not Flag and MainFrame:GetAlpha() > 0.95 then
        UIFrameFadeOut(MainFrame, 0.5, 1, 0)
    end
end

local function OnPlayerLogin(self, event, ...)
    MainFrame:SetAlpha(0)
    MainFrame:SetSize(Width, Height)
    MainFrame:SetBackdropColor(1, 1, 1)
    MainFrame:SetPoint(unpack(C.Threat.Postion))
    MainFrame:SetBackdrop({bgFile = DB.ThreatBar})
    MainFrame.Shadow = S.MakeShadow(MainFrame, 2)
    
    Tank:SetAllPoints()
    Tank:SetStatusBarTexture(DB.Solid)
    Tank:SetStatusBarColor(0, 0, 0, 0)
    
    Tank:SetMinMaxValues(0, 130)
    Tank:SetValue(100)
    
    Tank.Flag = Tank:CreateTexture(nil, "OVERLAY")
    Tank.Flag:SetSize(1, 2)
    Tank.Flag:SetVertexColor(0, 0, 0)
    Tank.Flag:SetPoint("LEFT", Tank:GetStatusBarTexture(), "RIGHT", 0, 0)
    
    Tank.Arrow = Tank:CreateTexture(nil, "OVERLAY")
    Tank.Arrow:SetSize(24, 24)
    Tank.Arrow:SetTexture(DB.ArrowT)
    Tank.Arrow:SetPoint("BOTTOM", Tank.Flag, "TOP", 0, 0)
    
    Tank.Name = S.MakeText(Tank, 10)
    Tank.Name:SetPoint("BOTTOM", Tank.Arrow, "TOP", 0, -8)
    
    for i = 1, 3 do
        local StatusBar = CreateFrame("StatusBar", nil, MainFrame)
        StatusBar:SetValue(0)
        StatusBar:SetAllPoints()
        StatusBar:SetMinMaxValues(0, 130)
        StatusBar:SetStatusBarTexture(DB.Solid)
        StatusBar:SetStatusBarColor(0, 0, 0, 0)
        
        StatusBar.Flag = StatusBar:CreateTexture(nil, "OVERLAY")
        StatusBar.Flag:SetSize(1, 2)
        StatusBar.Flag:SetVertexColor(0, 0, 0)
        StatusBar.Flag:SetPoint("LEFT", StatusBar:GetStatusBarTexture(), "RIGHT", 0, 0)
        
        StatusBar.Arrow = StatusBar:CreateTexture(nil, "OVERLAY")
        StatusBar.Arrow:SetHeight(16)
        StatusBar.Arrow:SetWidth(16)
        StatusBar.Arrow:SetTexture(DB.Arrow)
        StatusBar.Arrow:SetPoint("TOP", StatusBar.Flag, "BOTTOM", 0, -1)
        
        StatusBar.Name = S.MakeText(StatusBar, 10)
        StatusBar.Name:SetPoint("TOP", StatusBar.Arrow, "BOTTOM", 1, 3)
        
        ThreatFlag[i] = StatusBar
    end
end

local function OnPlayerTargetChanged(self, event, ...)
    wipe(ThreatList)
    UpdateThreat()
    Fade()
    UpdateThreatFlag()
end

local function OnUnitThreatListUpdate(self, event, ...)
    UpdateThreat()
    Fade()
    UpdateThreatFlag()
end

local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:RegisterEvent("PLAYER_TARGET_CHANGED")
Event:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
Event:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, ...)
    elseif event == "PLAYER_TARGET_CHANGED" then
        OnPlayerTargetChanged(self, event, ...)
    elseif event == "UNIT_THREAT_LIST_UPDATE" then
        OnUnitThreatListUpdate(self, event, ...)
    end
end)

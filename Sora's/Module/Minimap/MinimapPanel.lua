-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))

-- Variables
local width, height = 48, 6

-- Begin
local function OnLeave(self, ...)
    GameTooltip:Hide()
end

-- PingPanel
local function OnPingPanelEnter(self, ...)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:ClearLines()
    
    local _, _, latencyHome, latencyWorld = GetNetStats()
    GameTooltip:AddLine("延迟：", 0.40, 0.78, 1.00)
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine("本地延迟：", latencyHome, 1.00, 1.00, 1.00)
    GameTooltip:AddDoubleLine("世界延迟：", latencyWorld, 1.00, 1.00, 1.00)
    
    GameTooltip:Show()
end

local function OnPingPanelUpdate(self, elapsed, ...)
    self.timer = self.timer + elapsed
    
    if self.timer > 3 then
        local _, _, latencyHome, latencyWorld = GetNetStats()
        local value = (latencyHome > latencyWorld) and latencyHome or latencyWorld
        
        self:SetValue(value)
        self.text:SetText(value .. "ms")
        
        if value > 499 then
            self:SetStatusBarColor(1.00, 0.00, 0.00)
        elseif value > 249 then
            self:SetStatusBarColor(1.00, 1.00, 0.00)
        else
            self:SetStatusBarColor(0.00, 0.40, 1.00)
        end
        
        self.timer = 0
    end
end

local function SetPingPanel()
    local bar = CreateFrame("StatusBar", nil, UIParent)
    bar:SetSize(width, height)
    bar:SetMinMaxValues(0, 1000)
    bar:SetStatusBarTexture(DB.Statusbar)
    bar:SetStatusBarColor(0.00, 0.40, 1.00)
    bar:SetPoint("TOPLEFT", Minimap, "TOPRIGHT", 8, 0)
    
    bar.text = S.MakeText(bar, 10)
    bar.text:SetText("0ms")
    bar.text:SetPoint("CENTER", 0, -4)
    
    bar.shadow = S.MakeShadow(bar, 2)
    bar.bg = bar:CreateTexture(nil, "BACKGROUND")
    bar.bg:SetTexture(DB.Statusbar)
    bar.bg:SetAllPoints()
    bar.bg:SetVertexColor(0.12, 0.12, 0.12)
    
    bar.timer = 0
    bar:SetScript("OnLeave", OnLeave)
    bar:SetScript("OnEnter", OnPingPanelEnter)
    bar:SetScript("OnUpdate", OnPingPanelUpdate)
end

-- AddOnPanel
local addons = {}

local function UpdateAddons()
    UpdateAddOnMemoryUsage()
    local addonCount = GetNumAddOns()
    
    if addonCount == #addons then
        return
    end
    
    addons = {}
    for i = 1, addonCount do
        local _ = nil
        local addon = {}
        
        addon.isLoaded = IsAddOnLoaded(i)
        _, addon.addonName = GetAddOnInfo(i)
        addon.addonMemory = GetAddOnMemoryUsage(i)
        
        addons[i] = addon
    end
    
    table.sort(addons, function(l, r)
        if l and r then
            return l.addonMemory > r.addonMemory
        end
    end)
end

local function OnAddOnPanelMouseDown(self, ...)
    UpdateAddOnMemoryUsage()
    local before = gcinfo()
    collectgarbage()
    UpdateAddOnMemoryUsage()
    
    print(format("|cff66C6FF%s:|r %s", "共释放内存：", S.FormatMemory(before - gcinfo())))
end

local function OnAddOnPanelEnter(self, ...)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:ClearLines()
    
    local currMemory = 0
    for key, value in pairs(addons) do
        currMemory = currMemory + value.addonMemory
    end
    
    GameTooltip:AddDoubleLine(
        "总共内存使用：",
        S.FormatMemory(currMemory),
        0.40, 0.78, 1.00, 0.84, 0.75, 0.65
    )
    GameTooltip:AddLine(" ")
    
    for key, value in pairs(addons) do
        if value.isLoaded then
            currMemory = currMemory + value.addonMemory
            
            GameTooltip:AddDoubleLine(
                value.addonName,
                S.FormatMemory(value.addonMemory),
                1.00, 1.00, 1.00, 0.00, 1.00, 0.00
        )
        end
    end
    
    GameTooltip:Show()
end

local function OnAddOnPanelUpdate(self, elapsed, ...)
    self.timer = self.timer + elapsed
    
    if self.timer > 3 then
        UpdateAddons()
        
        local currMemory = 0
        for key, value in pairs(addons) do
            currMemory = currMemory + value.addonMemory
        end
        
        self:SetValue(currMemory)
        self.text:SetText(S.FormatMemory(currMemory))
        
        if currMemory > 20480 then
            self:SetStatusBarColor(1.00, 0.00, 0.00)
        elseif currMemory > 12288 then
            self:SetStatusBarColor(1.00, 1.00, 0.00)
        else
            self:SetStatusBarColor(0.00, 0.40, 1.00)
        end
        
        self.timer = 0
    end
end

local function SetAddOnPanel()
    local bar = CreateFrame("StatusBar", nil, UIParent)
    bar:SetSize(width, height)
    bar:SetMinMaxValues(0, 20480)
    bar:SetStatusBarTexture(DB.Statusbar)
    bar:SetStatusBarColor(0.00, 0.40, 1.00)
    bar:SetPoint("TOPLEFT", Minimap, "TOPRIGHT", 8, -height * 3)
    
    bar.text = S.MakeText(bar, 10)
    bar.text:SetText("N/A")
    bar.text:SetPoint("CENTER", 0, -4)
    
    bar.shadow = S.MakeShadow(bar, 2)
    bar.bg = bar:CreateTexture(nil, "BACKGROUND")
    bar.bg:SetTexture(DB.Statusbar)
    bar.bg:SetAllPoints()
    bar.bg:SetVertexColor(0.12, 0.12, 0.12)
    
    bar.timer = 0
    bar:SetScript("OnLeave", OnLeave)
    bar:SetScript("OnEnter", OnAddOnPanelEnter)
    bar:SetScript("OnUpdate", OnAddOnPanelUpdate)
    bar:SetScript("OnMouseDown", OnAddOnPanelMouseDown)
end

-- ClockPanel
local function OnClockPanelEnter(self, ...)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:ClearLines()
    
    GameTooltip:AddLine(date "%A, %B %d", 0.40, 0.78, 1.00)
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine(TIMEMANAGER_TOOLTIP_LOCALTIME, GameTime_GetLocalTime(true), 0.75, 0.90, 1.00, 1.00, 1.00, 1.00)
    GameTooltip:AddDoubleLine(TIMEMANAGER_TOOLTIP_REALMTIME, GameTime_GetGameTime(true), 0.75, 0.90, 1.00, 1.00, 1.00, 1.00)
    
    GameTooltip:Show()
end

local function OnClockPanelUpdate(self, elapsed, ...)
    self.timer = self.timer + elapsed
    
    if self.timer > 1 then
        self.text:SetText(GameTime_GetLocalTime(true))
        
        self.timer = 0
    end
end

local function SetClockPanel()
    local clock = CreateFrame("Frame", nil, UIParent)
    clock:SetSize(width, height * 3)
    clock:SetPoint("LEFT", Minimap, "RIGHT", 8, 4)
    
    clock.text = S.MakeText(clock, 14)
    clock.text:SetAllPoints()
    
    clock.timer = 0
    clock:SetScript("OnLeave", OnLeave)
    clock:SetScript("OnEnter", OnClockPanelEnter)
    clock:SetScript("OnUpdate", OnClockPanelUpdate)
    
    GameTimeFrame:Hide()
    TimeManagerClockButton:Hide()
end

-- GoldPanel
local function OnGoldPanelEnter(self, ...)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:ClearLines()
    
    local money = GetMoney()
    local gold = floor(money / 100 / 100)
    local sliver = floor((money - gold * 100 * 100) / 100)
    local copper = floor((money - gold * 100 * 100 - sliver * 100))
    
    GameTooltip:AddDoubleLine(
        "我的货币：",
        ("%d|cffffd700G|r %d|cffc7c7cfS|r %d|cffb87333C|r"):format(gold, sliver, copper),
        0.40, 0.78, 1.00, 1.00, 1.00, 1.00
    )
    GameTooltip:Show()
end

local function OnGoldPanelUpdate(self, elapsed, ...)
    self.timer = self.timer + elapsed
    
    if self.timer > 3 then
        local money = GetMoney()
        local gold = floor(money / 100 / 100)
        
        self:SetValue(money / 100 / 100)
        self.text:SetText(("%d|cffffd700G|r"):format(gold))
        
        self.timer = 0
    end
end

local function SetGoldPanel()
    local bar = CreateFrame("StatusBar", nil, UIParent)
    bar:SetSize(width, height)
    bar:SetMinMaxValues(0, 200000)
    bar:SetStatusBarTexture(DB.Statusbar)
    bar:SetStatusBarColor(0.00, 0.40, 1.00)
    bar:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMRIGHT", 8, height * 4)
    
    bar.text = S.MakeText(bar, 10)
    bar.text:SetText("N/A")
    bar.text:SetPoint("CENTER", 0, -4)
    
    bar.shadow = S.MakeShadow(bar, 2)
    bar.bg = bar:CreateTexture(nil, "BACKGROUND")
    bar.bg:SetTexture(DB.Statusbar)
    bar.bg:SetAllPoints()
    bar.bg:SetVertexColor(0.12, 0.12, 0.12)
    
    bar.timer = 0
    bar:SetScript("OnLeave", OnLeave)
    bar:SetScript("OnEnter", OnGoldPanelEnter)
    bar:SetScript("OnUpdate", OnGoldPanelUpdate)
end

-- DurabilityPanel
local solts = {1, 3, 5, 6, 7, 8, 9, 10, 16, 17}

local function OnDurabilityPanelEnter(self, ...)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:ClearLines()
    
    local maxDurability, currDurability = 0, 0
    
    for key, value in pairs(solts) do
        if GetInventoryItemLink("player", value) ~= nil then
            local curr, max = GetInventoryItemDurability(value)
            
            if curr and max then
                maxDurability = maxDurability + max
                currDurability = currDurability + curr
            end
        end
    end
    
    local value = currDurability / maxDurability * 100
    
    GameTooltip:AddDoubleLine(
        "装备耐久：",
        string.format("%.2f%%", value),
        0.40, 0.78, 1.00, 1.00, 1.00, 1.00
    )
    GameTooltip:Show()
end

local function OnDurabilityPanelUpdate(self, elapsed, ...)
    self.timer = self.timer + elapsed
    
    if self.timer > 3 then
        local maxDurability, currDurability = 0, 0
        
        for key, value in pairs(solts) do
            if GetInventoryItemLink("player", value) ~= nil then
                local curr, max = GetInventoryItemDurability(value)
                
                if curr and max then
                    maxDurability = maxDurability + max
                    currDurability = currDurability + curr
                end
            end
        end
        
        local value = currDurability / maxDurability * 100
        
        if value < 10 then
            self:SetStatusBarColor(1.00, 0.00, 0.00)
        elseif value < 30 then
            self:SetStatusBarColor(1.00, 1.00, 0.00)
        else
            self:SetStatusBarColor(0.00, 0.40, 1.00)
        end
        
        self:SetValue(value)
        self.text:SetText(string.format("%d%%", value))
        
        self.timer = 0
    end
end

local function SetDurabilityPanel()
    local bar = CreateFrame("StatusBar", nil, UIParent)
    bar:SetSize(width, height)
    bar:SetMinMaxValues(0, 100)
    bar:SetStatusBarTexture(DB.Statusbar)
    bar:SetStatusBarColor(0.00, 0.40, 1.00)
    bar:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMRIGHT", 8, height)
    
    bar.text = S.MakeText(bar, 10)
    bar.text:SetText("N/A")
    bar.text:SetPoint("CENTER", 0, -4)
    
    bar.shadow = S.MakeShadow(bar, 2)
    bar.bg = bar:CreateTexture(nil, "BACKGROUND")
    bar.bg:SetTexture(DB.Statusbar)
    bar.bg:SetAllPoints()
    bar.bg:SetVertexColor(0.12, 0.12, 0.12)
    
    bar.timer = 0
    bar:SetScript("OnLeave", OnLeave)
    bar:SetScript("OnEnter", OnDurabilityPanelEnter)
    bar:SetScript("OnUpdate", OnDurabilityPanelUpdate)
end

local function OnPlayerLogin(self, event, ...)
    SetPingPanel()
    SetGoldPanel()
    SetClockPanel()
    SetAddOnPanel()
    SetDurabilityPanel()
end

-- Event
local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, ...)
    end
end)

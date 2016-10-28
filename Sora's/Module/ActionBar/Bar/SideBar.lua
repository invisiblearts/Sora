-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Variables
local leftAnchor, rightAnchor = nil, nil

-- Begin
local function OnEnter(self, event, ...)
    for i = 1, NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarLeftButton" .. i]:SetAlpha(1.00)
        local button = _G["MultiBarRightButton" .. i]:SetAlpha(1.00)
    end
end

local function OnLeave(self, event, ...)
    for i = 1, NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarLeftButton" .. i]:SetAlpha(0.33)
        local button = _G["MultiBarRightButton" .. i]:SetAlpha(0.33)
    end
end

local function SetAnchor(self, event, ...)
    local width = C.ActionBar.Size * 2 + C.ActionBar.Space
    local height = C.ActionBar.Size * 9 + C.ActionBar.Space * 8
    
    leftAnchor = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
    leftAnchor:SetPoint("LEFT", 8, 0)
    leftAnchor:SetSize(width, height)
    leftAnchor:SetScript("OnEnter", OnEnter)
    leftAnchor:SetScript("OnLeave", OnLeave)
    
    rightAnchor = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
    rightAnchor:SetPoint("RIGHT", -8, 0)
    rightAnchor:SetSize(width, height)
    rightAnchor:SetScript("OnEnter", OnEnter)
    rightAnchor:SetScript("OnLeave", OnLeave)
end

local function SetMultiBarLeft(self, event, ...)
    MultiBarLeft:SetParent(leftAnchor)
    MultiBarLeft:EnableMouse(false)
    for i = 1, NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarLeftButton" .. i]
        button:ClearAllPoints()
        button:SetSize(C.ActionBar.Size, C.ActionBar.Size)
        
        button:SetAlpha(0.33)
        button:SetScript("OnEnter", OnEnter)
        button:SetScript("OnLeave", OnLeave)
        
        if i == 1 then
            button:SetPoint("TOPLEFT", leftAnchor, 0, 0)
        elseif i % 9 == 1 then
            button:SetPoint("LEFT", _G["MultiBarLeftButton" .. i - 6], "RIGHT", C.ActionBar.Space, 0)
        else
            button:SetPoint("TOP", _G["MultiBarLeftButton" .. i - 1], "BOTTOM", 0, -C.ActionBar.Space)
        end
    end
end

local function SetMultiBarRight(self, event, ...)
    MultiBarRight:SetParent(rightAnchor)
    MultiBarRight:EnableMouse(false)
    for i = 1, NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarRightButton" .. i]
        button:ClearAllPoints()
        button:SetSize(C.ActionBar.Size, C.ActionBar.Size)
        
        button:SetAlpha(0.33)
        button:SetScript("OnEnter", OnEnter)
        button:SetScript("OnLeave", OnLeave)
        
        if i == 1 then
            button:SetPoint("TOPRIGHT", rightAnchor, 0, 0)
        elseif i % 9 == 1 then
            button:SetPoint("RIGHT", _G["MultiBarRightButton" .. i - 6], "LEFT", -C.ActionBar.Space, 0)
        else
            button:SetPoint("TOP", _G["MultiBarRightButton" .. i - 1], "BOTTOM", 0, -C.ActionBar.Space)
        end
    end
end


local function RegisterForStateDriver(self, event, ...)
    RegisterStateDriver(leftAnchor, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
    RegisterStateDriver(rightAnchor, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
end

local function OnPlayerLogin(self, event, ...)
    SetAnchor(self, event, ...)
    SetMultiBarLeft(self, event, ...)
    SetMultiBarRight(self, event, ...)
    
    RegisterForStateDriver(self, event, ...)
end

-- Event
local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, ...)
    end
end)

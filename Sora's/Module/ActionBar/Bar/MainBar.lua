-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local Parent = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
Parent:SetPoint(unpack(C.ActionBar.MainBarPostion))
Parent:SetSize(C.ActionBar.Size * 18 + C.ActionBar.Space * 17, C.ActionBar.Size * 2 + C.ActionBar.Space)

-- 设置主动做条布局
MainMenuBarArtFrame:SetParent(Parent)
MainMenuBarArtFrame:EnableMouse(false)
for i = 1, NUM_ACTIONBAR_BUTTONS do
    local Button = _G["ActionButton" .. i]
    Button:ClearAllPoints()
    Button:SetSize(C.ActionBar.Size, C.ActionBar.Size)
    
    if i == 1 then
        Button:SetPoint("BOTTOMLEFT", Parent, C.ActionBar.Size * 3 + C.ActionBar.Space * 3, 0)
    else
        Button:SetPoint("LEFT", _G["ActionButton" .. i - 1], "RIGHT", C.ActionBar.Space, 0)
    end
end

-- 设置左下动作条布局
MultiBarBottomLeft:SetParent(Parent)
MultiBarBottomLeft:EnableMouse(false)
for i = 1, NUM_ACTIONBAR_BUTTONS do
    local Button = _G["MultiBarBottomLeftButton" .. i]
    Button:ClearAllPoints()
    Button:SetSize(C.ActionBar.Size, C.ActionBar.Size)
    
    if i == 1 then
        Button:SetPoint("TOPLEFT", Parent, C.ActionBar.Size * 3 + C.ActionBar.Space * 3, 0)
    else
        Button:SetPoint("LEFT", _G["MultiBarBottomLeftButton" .. i - 1], "RIGHT", C.ActionBar.Space, 0)
    end
end

-- 设置右下动作条布局
MultiBarBottomRight:SetParent(Parent)
MultiBarBottomRight:EnableMouse(false)
for i = 1, NUM_ACTIONBAR_BUTTONS do
    local Button = _G["MultiBarBottomRightButton" .. i]
    Button:ClearAllPoints()
    Button:SetSize(C.ActionBar.Size, C.ActionBar.Size)
    
    if i == 1 then
        Button:SetPoint("TOPLEFT", Parent)
    elseif i == 4 then
        Button:SetPoint("TOP", _G["MultiBarBottomRightButton" .. i - 3], "BOTTOM", 0, -C.ActionBar.Space)
    elseif i == 7 then
        Button:SetPoint("TOPRIGHT", Parent, -1 * (C.ActionBar.Size * 2 + C.ActionBar.Space * 2), 0)
    elseif i == 10 then
        Button:SetPoint("TOP", _G["MultiBarBottomRightButton" .. i - 3], "BOTTOM", 0, -C.ActionBar.Space)
    else
        Button:SetPoint("LEFT", _G["MultiBarBottomRightButton" .. i - 1], "RIGHT", C.ActionBar.Space, 0)
    end
end

-- 设置动作条驱动状态
RegisterStateDriver(Parent, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")

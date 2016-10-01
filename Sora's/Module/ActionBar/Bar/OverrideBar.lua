-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local Parent = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
Parent:SetPoint(unpack(C.ActionBar.MainBarPostion))
Parent:SetSize(C.ActionBar.Size * 12 + C.ActionBar.Space * 11, C.ActionBar.Size)

-- 设置载具条布局
OverrideActionBar:SetParent(Parent)
OverrideActionBar:EnableMouse(false)
OverrideActionBar:SetScript("OnShow", nil)
OverrideActionBar.LeaveButton:Hide()

for i = 1, 6 do
    local button = _G["OverrideActionBarButton" .. i]
    
    if not button then
        break
    end
    
    button:ClearAllPoints()
    button:SetSize(C.ActionBar.Size, C.ActionBar.Size)
    
    if i == 1 then
        button:SetPoint("BOTTOMLEFT", Parent, 0, 0)
    else
        button:SetPoint("LEFT", _G["OverrideActionBarButton" .. i - 1], "RIGHT", C.ActionBar.Space, 0)
    end
end

-- 设置动作条驱动状态
RegisterStateDriver(Parent, "visibility", "[petbattle] hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
RegisterStateDriver(OverrideActionBar, "visibility", "[overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")

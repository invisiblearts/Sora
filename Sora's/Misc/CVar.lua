-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local function OnPlayerLogin(self, event, ...)
    -- 反和谐
    SetCVar("overrideArchive", 0)
    
    -- 姓名板最远显示距离
    SetCVar("nameplateMaxDistance", 40)
    
    -- 还原经典战斗文字效果
    SetCVar("floatingCombatTextCombatDamageDirectionalScale", 0)
    
    -- 以1920宽度为基准，自动适配分辨率，可通过调整scale的值微调整体比例
    local scale = 1.00
    local value = UIParent:GetScale() / (1920 / UIParent:GetWidth())
    UIParent:SetScale(scale * value)
end

-- Event
local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, ...)
    end
end)

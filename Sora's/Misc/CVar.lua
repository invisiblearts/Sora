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
end

-- Event
local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, ...)
    end
end)

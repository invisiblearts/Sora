-- Engine
-- local S, C, L, DB = unpack(select(2, ...))

-- Begin
local function OnPlayerLogin(self, event, ...)
    SetCVar("overrideArchive", 0)
end

-- Event
local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, ...)
    end
end)

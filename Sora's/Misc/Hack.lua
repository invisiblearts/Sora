-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local function HackAurora()
    if not AuroraConfig then
        return
    end
    
    AuroraConfig.__hacked = true
    AuroraConfig.enableFont = false
end

local function HackAdiBags()
    if not AdiBagsDB or AdiBagsDB.__hacked then
        return
    end
    
    if not AdiBagsDB.profiles then
        AdiBagsDB.profiles = {}
    end
    
    if not AdiBagsDB.profiles.Default then
        AdiBagsDB.profiles.Default = {}
    end
    
    if not AdiBagsDB.profiles.Default.virtualStacks then
        AdiBagsDB.profiles.Default.virtualStacks = {}
    end
    
    if not AdiBagsDB.profiles.Default.bagFont then
        AdiBagsDB.profiles.Default.bagFont = {}
    end
    
    if not AdiBagsDB.profiles.Default.columnWidth then
        AdiBagsDB.profiles.Default.columnWidth = {}
    end
    
    if not AdiBagsDB.profiles.Default.sectionFont then
        AdiBagsDB.profiles.Default.sectionFont = {}
    end
    
    AdiBagsDB.__hacked = true
    AdiBagsDB.profiles.Default.scale = 1
    AdiBagsDB.profiles.Default.bagFont.size = 13
    AdiBagsDB.profiles.Default.sectionFont.size = 13
    AdiBagsDB.profiles.Default.columnWidth.Bank = 16
    AdiBagsDB.profiles.Default.columnWidth.Backpack = 16
    AdiBagsDB.profiles.Default.virtualStacks.freeSpace = false
end

local function OnPlayerLogin(self, event, ...)
    HackAurora()
    HackAdiBags()
end

-- Event
local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, ...)
    end
end)

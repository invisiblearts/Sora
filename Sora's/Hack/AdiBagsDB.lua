-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local function OnPlayerLogin(self, event, ...)
    if not AdiBagsDB or AdiBagsDB._hacked then
        return
    end
    
    AdiBagsDB = {
        ["_hacked"] = true,
        ["namespaces"] = {
            ["MoneyFrame"] = {
                ["profiles"] = {
                    ["Default"] = {
                        ["small"] = true,
                    },
                },
            },
        },
        ["profiles"] = {
            ["Default"] = {
                ["virtualStacks"] = {
                    ["freeSpace"] = false,
                },
                ["columnWidth"] = {
                    ["Bank"] = 16,
                    ["Backpack"] = 16,
                },
                ["bagFont"] = {
                    ["size"] = 13,
                },
                ["hideAnchor"] = true,
                ["sectionFont"] = {
                    ["size"] = 13,
                },
                ["positionMode"] = "manual",
                ["scale"] = 1,
            },
        },
    }
end

-- Event
local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, ...)
    end
end)

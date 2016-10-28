-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))

-- Variables
local spacing, iconSize = nil, nil
local whiteList = C.PlayerAuraWhiteList
local blackList = C.PlayerAuraBlackList

-- Begin
local function SetPlayerAuraTimer(self, ...)
    local auras = CreateFrame("Frame", nil, self)
    auras:SetAllPoints()
    
    auras.num = 16
    auras.size = iconSize
    auras.spacing = spacing
    auras["growth-y"] = "UP"
    auras["growth-x"] = "RIGHT"
    auras.disableCooldown = false
    auras.initialAnchor = "TOPLEFT"
    
    auras.PostCreateIcon = function(self, button)
        if not button.shadow then
            button.shadow = S.MakeShadow(button, 2)
            
            button.icon:SetAllPoints()
            button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            
            button.count = S.MakeText(button, 10)
            button.count:SetPoint("BOTTOMRIGHT", 3, 0)
        end
    end
    
    auras.CustomFilter = function(self, unit, icon, name, rank, _, count, _, duration, timeLeft, caster, _, _, spellID)
        local flag = (duration > 0 and duration < 60 and caster == "player" and not icon.isDebuff
                     and not blackList[spellID])
                     or whiteList[spellID]
        -- Sorry for its messiness. Why lua is so shitty?

        if flag then
            icon.timeLeft = timeLeft        
        end
        
        return flag
    end
    
    self.Auras = auras
end

local function RegisterStyle(self, ...)
    local player = _G["oUF_Sora_Player"]
    local playerWitdh = player:GetWidth()
    
    spacing = 4
    iconSize = (playerWitdh - 4 * 7) / 8
    
    self:SetSize(playerWitdh, iconSize)
    self:SetPoint("BOTTOMLEFT", player, "TOPLEFT", 0, 12)
    
    SetPlayerAuraTimer(self, ...)
end

local function OnPlayerLogin(self, event, ...)
    oUF:RegisterStyle("oUF_Sora_PlayerAuraTimer", RegisterStyle)
    oUF:SetActiveStyle("oUF_Sora_PlayerAuraTimer")
    
    oUF:Spawn("player", "oUF_Sora_PlayerAuraTimer")
end

-- Event
local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, unit, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, ...)
    end
end)

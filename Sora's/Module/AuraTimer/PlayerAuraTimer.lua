-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))

-- Variables
local spacing, iconSize = nil, nil

-- Begin
local function SetPlayerAuraTimer(self, ...)
    local auraTimers = CreateFrame("Frame", nil, self)
    auraTimers:SetAllPoints()
    
    auraTimers.num = 16
    auraTimers.size = iconSize
    auraTimers.spacing = spacing
    auraTimers["growth-y"] = "UP"
    auraTimers["growth-x"] = "RIGHT"
    auraTimers.disableCooldown = false
    auraTimers.initialAnchor = "TOPLEFT"
    
    auraTimers.PostCreateIcon = function(self, button)
        if not button.shadow then
            button.shadow = S.MakeShadow(button, 2)
            
            button.icon:SetAllPoints()
            button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            
            button.count = S.MakeText(button, 10)
            button.count:SetPoint("BOTTOMRIGHT", 3, 0)
        end
    end
    
    auraTimers.CustomFilter = function(self, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)
        local flag = false
        
        if duration > 0 and duration < 60 and caster == "player" and not icon.isDebuff then
            flag = true
        end
        
        return flag
    end
    
    self.AuraTimers = auraTimers
end

local function InitParent(self, ...)
    local player = _G["oUF_Sora_Player"]
    local playerWitdh = player:GetWidth()
    
    spacing = 4
    iconSize = (playerWitdh + 4 * 8) / 9
    
    self:SetSize(playerWitdh, iconSize)
    self:SetPoint("BOTTOMLEFT", player, "TOPLEFT", 0, 12)
end

local function OnPlayerLogin(self, event, ...)
    oUF:RegisterStyle("oUF_Sora_PlayerAuraTimer", function(self, ...)
        InitParent(self, ...)
        SetPlayerAuraTimer(self, ...)
    end)
    
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

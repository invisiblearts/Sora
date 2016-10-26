-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))

-- Variables
local spacing, iconSize, barWidth = nil, nil, nil
local whiteList = {
    [164812] = true, -- 月火术
    [164815] = true, -- 阳炎术
}

-- Begin
local function SetTargetAuraTimer(self, ...)
    local auras = CreateFrame("Frame", nil, self)
    auras:SetAllPoints()
    
    auras.num = 8
    auras.size = iconSize
    auras.spacing = spacing
    auras["growth-y"] = "UP"
    auras["growth-x"] = "RIGHT"
    auras.disableCooldown = true
    auras.initialAnchor = "TOPLEFT"
    
    auras.PostUpdateIcon = function(self, unit, icon, index, offest, ...)
        icon.nameText:SetText(icon.name)
        icon.bar:SetMinMaxValues(0, icon.duration)
        
        icon:SetScript("OnUpdate", function(self, elapsed, ...)
            local expires = self.timeLeft - GetTime()
            
            if expires > 0 and expires < 60 then
                self.bar:SetValue(expires)
                self.timeText:SetText(("%.1f"):format(expires))
            end
        end)
    end
    
    auras.PostCreateIcon = function(self, icon, ...)
        if not icon.isProcessed then
            icon.icon:SetAllPoints()
            icon.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            
            icon.count = S.MakeText(icon, 10)
            icon.count:SetPoint("BOTTOMRIGHT", 3, 0)
            
            icon.bar = CreateFrame("StatusBar", nil, icon)
            icon.bar:SetSize(barWidth, iconSize / 3)
            icon.bar:SetStatusBarTexture(DB.Statusbar)
            icon.bar:SetPoint("BOTTOMLEFT", icon, "BOTTOMRIGHT", spacing, 0)
            icon.bar:SetStatusBarColor(RAID_CLASS_COLORS[DB.MyClass].r, RAID_CLASS_COLORS[DB.MyClass].g, RAID_CLASS_COLORS[DB.MyClass].b)
            
            icon.bar.bg = icon.bar:CreateTexture(nil, "BACKGROUND")
            icon.bar.bg:SetTexture(DB.Statusbar)
            icon.bar.bg:SetAllPoints()
            icon.bar.bg:SetVertexColor(0.12, 0.12, 0.12)
            
            icon.timeText = S.MakeText(icon.bar, 12)
            icon.timeText:SetPoint("RIGHT", 0, 6)
            
            icon.nameText = S.MakeText(icon.bar, 12)
            icon.nameText:SetPoint("CENTER", -10, 6)
            
            icon.shadow = S.MakeShadow(icon, 2)
            icon.bar.shadow = S.MakeShadow(icon.bar, 2)
            
            icon.isProcessed = true
        end
    end
    
    auras.CustomFilter = function(self, unit, icon, name, rank, _, count, _, duration, timeLeft, caster, _, _, spellID)
        local flag = false
        
        if caster == "player" and icon.isDebuff and duration > 0 and (duration < 60 or whiteList[spellID]) then
            flag = true
            icon.name = name
            icon.duration = duration
            icon.timeLeft = timeLeft
        end
        
        return flag
    end
    
    self.Auras = auras
end

local function RegisterStyle(self, ...)
    local target = _G["oUF_Sora_Target"]
    local targetWitdh = target:GetWidth()
    
    spacing = 4
    iconSize = (targetWitdh - 4 * 7) / 8
    barWidth = targetWitdh - iconSize - spacing
    
    self:SetSize(iconSize, iconSize)
    self:SetPoint("BOTTOMLEFT", target, "TOPLEFT", 0, 12)
    
    SetTargetAuraTimer(self, ...)
end

local function OnPlayerLogin(self, event, ...)
    oUF:RegisterStyle("oUF_Sora_TargetAuraTimer", RegisterStyle)
    oUF:SetActiveStyle("oUF_Sora_TargetAuraTimer")
    
    oUF:Spawn("target", "oUF_Sora_TargetAuraTimer")
end

-- Event
local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, unit, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, ...)
    end
end)

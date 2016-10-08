-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))

-- Variables
local spacing, iconSize, barWidth = nil, nil, nil

-- Begin
local function SetTargetAuraTimer(self, ...)
    local auraTimers = CreateFrame("Frame", nil, self)
    auraTimers:SetAllPoints()
    
    auraTimers.num = 8
    auraTimers.size = iconSize
    auraTimers.spacing = spacing
    auraTimers["growth-y"] = "UP"
    auraTimers["growth-x"] = "RIGHT"
    auraTimers.disableCooldown = true
    auraTimers.initialAnchor = "TOPLEFT"
    
    auraTimers.PostUpdateIcon = function(self, unit, icon, index, offest, ...)
        icon.nameText:SetText(icon.name)
        icon.bar:SetMinMaxValues(0, icon.duration)
        
        icon.timer = 0
        icon:SetScript("OnUpdate", function(self, elapsed, ...)
            self.timer = self.expires - GetTime()
            
            if self.timer >= 0 and self.timer < 60 then
                self.bar:SetValue(self.timer)
                self.timeText:SetText(string.format("%.1f", self.timer))
            end
        end)
    end
    
    auraTimers.PostCreateIcon = function(self, icon, ...)
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
    
    auraTimers.CustomFilter = function(self, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)
        local flag = false
        
        if duration > 0 and duration < 60 and caster == "player" and icon.isDebuff then
            flag = true
        end
        
        return flag
    end
    
    self.AuraTimers = auraTimers
end

local function InitParent(self, ...)
    local target = _G["oUF_Sora_Target"]
    local targetWitdh = target:GetWidth()
    
    spacing = 4
    iconSize = (targetWitdh - 4 * 7) / 8
    barWidth = targetWitdh - iconSize - spacing
    
    self:SetSize(iconSize, iconSize)
    self:SetPoint("BOTTOMLEFT", target, "TOPLEFT", 0, 12)
end

local function OnPlayerLogin(self, event, ...)
    oUF:RegisterStyle("oUF_Sora_TargetAuraTimer", function(self, ...)
        InitParent(self, ...)
        SetTargetAuraTimer(self, ...)
    end)
    
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

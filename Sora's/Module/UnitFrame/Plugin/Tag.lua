-- Engine
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))

-- Begin
oUF.colors.power["MANA"] = {0.00, 0.56, 1.00}
oUF.colors.power["RAGE"] = {1.00, 0.00, 0.00}
oUF.colors.power["FOCUS"] = {1.00, 0.75, 0.25}
oUF.colors.power["ENERGY"] = {0.65, 0.65, 0.35}
oUF.colors.power["RUNIC_POWER"] = {0.44, 0.44, 0.44}

oUF.Tags.Methods["Sora:Color"] = function(unit, r)
    local _, class = UnitClass(unit)
    local reaction = UnitReaction(unit, "player")
    
    if UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit) then
        return "|cffA0A0A0"
    -- elseif UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)then
    -- return S.RGBToHex(oUF.colors.tapped)
    elseif UnitIsPlayer(unit) then
        return S.RGBToHex(oUF.colors.class[class])
    elseif reaction then
        return S.RGBToHex(oUF.colors.reaction[reaction])
    else
        return S.RGBToHex(1.0, 1.0, 1.0)
    end
end
oUF.Tags.Events["Sora:Color"] = "UNIT_REACTION UNIT_HEALTH UNIT_HAPPINESS"

oUF.Tags.Methods["Sora:HP"] = function(unit)
    return S.FormatInteger(UnitHealth(unit))
end
oUF.Tags.Events["Sora:HP"] = "UNIT_HEALTH"

oUF.Tags.Methods["Sora:PerHP"] = function(unit)
    return oUF.Tags.Methods["perhp"](unit) .. "%" or 0
end
oUF.Tags.Events["Sora:PerHP"] = "UNIT_HEALTH"

oUF.Tags.Methods["Sora:PP"] = function(unit)
    return S.FormatInteger(UnitPower(unit))
end
oUF.Tags.Events["Sora:PP"] = "UNIT_POWER"

oUF.Tags.Methods["Sora:PerPP"] = function(unit)
    return floor(UnitPower(unit) / UnitPowerMax(unit) * 100 + 0.5) .. "%"
end
oUF.Tags.Events["Sora:PerPP"] = "UNIT_POWER"

oUF.Tags.Methods["Sora:Level"] = function(unit)
    local c = UnitClassification(unit)
    local l = UnitLevel(unit)
    local d = GetQuestDifficultyColor(l)
    local str = l
    if l <= 0 then l = "??" end
    if c == "worldboss" then
        str = string.format("|cff%02x%02x%02xBoss|r", 250, 20, 0)
    elseif c == "eliterare" then
        str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR|r+", d.r * 255, d.g * 255, d.b * 255, l)
    elseif c == "elite" then
        str = string.format("|cff%02x%02x%02x%s|r+", d.r * 255, d.g * 255, d.b * 255, l)
    elseif c == "rare" then
        str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR|r", d.r * 255, d.g * 255, d.b * 255, l)
    else
        if not UnitIsConnected(unit) then
            str = "??"
        else
            if UnitIsPlayer(unit) then
                str = string.format("|cff%02x%02x%02x%s", d.r * 255, d.g * 255, d.b * 255, l)
            elseif UnitPlayerControlled(unit) then
                str = string.format("|cff%02x%02x%02x%s", d.r * 255, d.g * 255, d.b * 255, l)
            else
                str = string.format("|cff%02x%02x%02x%s", d.r * 255, d.g * 255, d.b * 255, l)
            end
        end
    end
    return str
end
oUF.Tags.Events["Sora:Level"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"

oUF.Tags.Methods["Sora:Info"] = function(unit)
    local _, class = UnitClass(unit)
    if class then
        if UnitIsDead(unit) then
            return S.RGBToHex(oUF.colors.class[class]) .. "死亡|r"
        elseif UnitIsGhost(unit) then
            return S.RGBToHex(oUF.colors.class[class]) .. "灵魂|r"
        elseif not UnitIsConnected(unit) then
            return S.RGBToHex(oUF.colors.class[class]) .. "离线|r"
        end
    end
end
oUF.Tags.Events["Sora:Info"] = "UNIT_HEALTH UNIT_CONNECTION"

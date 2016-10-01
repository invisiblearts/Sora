--- Variables ---
if (type(LibItemLevel) ~= "table") then return end
FreeUI_ftipUnitDB = FreeUI_ftipUnitDB or {}

local _, _G = _, _G
local LIL = LibItemLevel
local GameTooltip = _G["GameTooltip"]

local prefixColor, detailColor = "|cffffeeaa", "|cffffffff"
local lastScanRequest, nextScanRequest, nextScanInterval = 0, 0, 0
local lastInspectRequest, nextInspectRequest = 0, 0
local currentUNIT, currentGUID, currentINS, forceInspect

local LFG_LIST_LOADING = _G["LFG_LIST_LOADING"]
local UNKNOWN = _G["UNKNOWN"]
local FAILED = _G["FAILED"]
local NONE = _G["NONE"]

local locale = GetLocale()
local gearPrefix, specPrefix

if (locale == "zhCN") then
	gearPrefix = "装等: "
	specPrefix = "专精: "
elseif (locale == "zhTW") then
	gearPrefix = "裝等: "
	specPrefix = "專精: "
else
	gearPrefix = STAT_AVERAGE_ITEM_LEVEL..": "
	specPrefix = SPECIALIZATION..": "
end

--- Create Frame ---
local f = CreateFrame("Frame", "FreeUI_ftipUnitInfo")
f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
f:RegisterEvent("INSPECT_READY")
f:Hide()

--- Set Unit Info ---
local function SetUnitInfo(gear, spec)
	if (not gear and not spec) then return end

	local _, unit = GameTooltip:GetUnit()
	if (not unit or UnitGUID(unit) ~= currentGUID) then return end

	local gearLine, specLine
	for i = 2, GameTooltip:NumLines() do
		local line = _G["GameTooltipTextLeft"..i]
		local text = line:GetText()

		if (text) then
			if (strfind(text, gearPrefix)) then
				gearLine = line
			elseif (strfind(text, specPrefix)) then
				specLine = line
			end
		end
	end

	if (gear) then
		gear = prefixColor..gearPrefix..detailColor..gear
		if (gearLine) then
			gearLine:SetText(gear)
		else
			GameTooltip:AddLine(gear)
		end
	end

	if (spec) then
		spec = prefixColor..specPrefix..detailColor..spec
		if (specLine) then
			specLine:SetText(spec)
		else
			GameTooltip:AddLine(spec)
		end
	end

	GameTooltip:Show()
end

--- Player Specialization ---
local function PlayerSpec()
	if (UnitLevel("player") <= 10) then return NONE end

	local specIndex = GetSpecialization()
	if (specIndex) then
		return select(2, GetSpecializationInfo(specIndex))
	else
		return NONE
	end
end

--- Player Gear Info ---
local function PlayerGear()
	local _, gear = GetAverageItemLevel()
	if (gear > 0) then
		return format("%.1f", gear) 
	else
		return 0
	end
end

--- Unit Specialization ---
local function UnitSpec(unit)
	if (not unit or UnitGUID(unit) ~= currentGUID) then return end
	if (UnitLevel(unit) <= 10) then return NONE end

	local specID = GetInspectSpecialization(unit)
	if (specID and specID > 0) then
		return select(2, GetSpecializationInfoByID(specID))
	end
end

--- Unit Gear Info ---
local function UnitGear(unit)
	if (not unit or UnitGUID(unit) ~= currentGUID) then return end
	local gear, unknown, boa, pvp = LIL:GetUnitItemLevel(unit)

	if (gear > 0) then gear = format("%.1f", gear) end
	if (unknown == 0) then
		if (boa > 0) then gear = gear.." |cffe6cc80"..boa.." BOA" end
		if (pvp > 0) then gear = gear.." |cffa335ee"..pvp.." PVP" end
		return gear
	else
		if (gear == 0) then gear = FAILED end
		gear = gear.." |cffff0000"..unknown.." "..UNKNOWN
		return nil, gear
	end
end

--- Scan Current Unit ---
local function ScanUnit(unit, forced)
	if (UnitIsUnit(unit, "player")) then
		SetUnitInfo(PlayerGear(), PlayerSpec())
	else
		if (not unit or UnitGUID(unit) ~= currentGUID) then return end
		local Time, cachedGear, cachedSpec = GetTime()
		local timeSinceLastInspect = Time - lastInspectRequest
		forceInspect = forced or IsShiftKeyDown() or not FreeUI_ftipUnitDB[currentGUID]

		if (FreeUI_ftipUnitDB[currentGUID]) then
			if (Time - FreeUI_ftipUnitDB[currentGUID].Time > 1800) then
				forceInspect = true
			elseif (not currentINS) then
				if (not FreeUI_ftipUnitDB[currentGUID].Spec) then
					FreeUI_ftipUnitDB[currentGUID].Spec = UnitSpec(unit)
				end

				if (not FreeUI_ftipUnitDB[currentGUID].Gear) then
					FreeUI_ftipUnitDB[currentGUID].Gear = UnitGear(unit)
				end

				cachedSpec = FreeUI_ftipUnitDB[currentGUID].Spec
				cachedGear = FreeUI_ftipUnitDB[currentGUID].Gear

				if (not cachedSpec) then
					if (Time - lastScanRequest > 3.5) then
						cachedSpec = FAILED
					elseif (timeSinceLastInspect > 1.5) then
						forceInspect = true
					end
				end

				if (not cachedGear) then
					if (Time - lastScanRequest > 3.5) then
						_, cachedGear = UnitGear(unit)
					elseif (timeSinceLastInspect > 1.5) then
						forceInspect = true
					end
				elseif (cachedGear == 0) then
					forceInspect = true
					cachedGear = nil
				end
			end
		end
		currentINS = nil

		if (cachedGear or cachedSpec) then
			SetUnitInfo(cachedGear or LFG_LIST_LOADING, cachedSpec or LFG_LIST_LOADING)
		end

		if (not forceInspect) then
			if (cachedGear and cachedSpec) then return end
			if (UnitAffectingCombat("player")) then return end
		end

		if (not UnitIsVisible(unit)) then return end
		if (UnitIsDeadOrGhost("player") or UnitOnTaxi("player")) then return end
		if (InspectFrame and InspectFrame:IsShown()) then return end

		SetUnitInfo(LFG_LIST_LOADING, cachedSpec or LFG_LIST_LOADING)

		if (timeSinceLastInspect >= 1.5) then
			nextInspectRequest = 0
		else
			nextInspectRequest = 1.5 - timeSinceLastInspect
		end
		f:Show()
	end
end

--- Character Info Sheet ---
hooksecurefunc("PaperDollFrame_SetArmor", function(_, unit)
	if (unit ~= "player") then return end

	local total, equip = GetAverageItemLevel()
	if (total > 0) then total = format("%.1f", total) end
	if (equip > 0) then equip = format("%.1f", equip) end

	local ilvl = equip
	if (equip ~= total) then
		ilvl = equip.." / "..total
	end

	PaperDollFrame_SetItemLevel(CharacterStatsPane.ItemLevelFrame, unit)
	CharacterStatsPane.ItemLevelCategory:Show()
	CharacterStatsPane.ItemLevelFrame:Show()
	CharacterStatsPane.ItemLevelFrame.Value:SetText(ilvl)
	CharacterStatsPane.AttributesCategory:SetPoint("TOP", CharacterStatsPane.ItemLevelFrame, "BOTTOM", 0, -10)
end)

--- Handle Events ---
f:SetScript("OnEvent", function(self, event, ...)
    if (event == "UPDATE_MOUSEOVER_UNIT" and CanInspect("mouseover")) then
		currentUNIT, currentGUID = "mouseover", UnitGUID("mouseover")
		lastScanRequest = GetTime()
		nextScanInterval = 0
		ScanUnit(currentUNIT)
	elseif (event == "INSPECT_READY") then
		local guid = ...
		if (guid == currentGUID) then
			currentINS = true

			local spec = UnitSpec(currentUNIT)
			local gear = UnitGear(currentUNIT)

			if (spec or (gear and gear > 0)) then
				if (not FreeUI_ftipUnitDB[guid]) then FreeUI_ftipUnitDB[guid] = {} end
				if (gear) then FreeUI_ftipUnitDB[guid].Gear = gear end
				if (spec) then FreeUI_ftipUnitDB[guid].Spec = spec end
				FreeUI_ftipUnitDB[guid].Time = GetTime()
				FreeUI_ftipUnitDB[guid].Update = (FreeUI_ftipUnitDB[guid].Update or 0) + 1

				if (not (gear and spec) or (gear == 0 and FreeUI_ftipUnitDB[guid].Update == 1)) then
					ScanUnit(currentUNIT)
				else
					SetUnitInfo(gear, spec)
				end
			else
				ScanUnit(currentUNIT, true)
			end
		end
	elseif (event == "UNIT_INVENTORY_CHANGED") then
		local unit = ...
		if (UnitGUID(unit) == currentGUID) then
			ScanUnit(unit, true)
		end
	end
end)

f:SetScript("OnUpdate", function(self, elapsed)
	if (currentUNIT and UnitGUID(currentUNIT) == currentGUID) then
		if (forceInspect) then
			nextInspectRequest = nextInspectRequest - elapsed
			if (nextInspectRequest > 0) then return end
			self:Hide()

			lastInspectRequest = GetTime()
			NotifyInspect(currentUNIT)
		else
			nextScanRequest = nextScanRequest + elapsed
			if (nextScanRequest < nextScanInterval) then return end
			self:Hide()

			if (nextScanInterval < 0.5) then
				nextScanInterval = nextScanInterval + 0.1
			end
			nextScanRequest = 0
			ScanUnit(currentUNIT)
		end
	end
end)
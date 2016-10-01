local ADDON_NAME, ns = ...

local _, _G = _, _G
local GameTooltip = _G["GameTooltip"]

local locale, mainFont = GetLocale()
local BOSS, ELITE = BOSS, ELITE
local RARE, RAREELITE
if (locale == "zhCN") then
	mainFont = "Fonts\\ARKai_T.ttf"		-- 简体中文客户端主字体
	RARE = "稀有"
	RAREELITE = "稀有精英"
elseif (locale == "zhTW") then
	mainFont = "Fonts\\blei00d.ttf"		-- 繁体中文客户端主字体
	RARE = "稀有"
	RAREELITE = "稀有精英"
else
	mainFont = "Fonts\\FRIZQT__.ttf"
	RARE = "Rare"
	RAREELITE = "Rare Elite"
end

local cfg = {
	font = mainFont,
	fontflag = "OUTLINE",
	fontsize_header = 14,				--Tooltip显示的名称字体大小。
	fontsize_normal = 12,				--Tooltip显示的普通字体大小。
	fontsize_small = 10,				--Tooltip显示的装备比较字体大小。
	fontsize_value = 10,				--Tooltip显示的血量/能量值字体大小。
	scale = 1,							--Tooltip缩放，默认为1，小于1缩小，大于1放大。
	point = {"BOTTOMRIGHT", -25, 30},	--Tooltip不跟随鼠标时的位置，BOTTOMRIGHT代表右下，数字代表偏移值。
	cursor = 1,							--Tooltip是否跟随鼠标，0不跟随，1跟随，2非战斗状态跟随。
	cursormode = 1,						--Tooltip跟随鼠标方式，1鼠标右下，2鼠标正上方。
	cursoroffset = {40, -30},			--Tooltip跟随鼠标坐标偏移值。
	hpbar = 1,							--是否显示血量条，0不显示，1显示。
	hpbarText = 0,						--是否显示血量值，0不显示，1显示当前血量值，2显示当前血量值/最大血量值。
	powerbar = 0,						--是否显示能量条，0不显示，1显示。
	powerbarText = 0,					--是否显示能量值，0不显示，1显示当前能量值，2显示当前能量值/最大能量值。
	fadeOnUnit = 0,						--鼠标移开后Tooltip渐隐，0关闭，1开启。
	combathide = 0,						--战斗中隐藏指向玩家们的鼠标提示，0不隐藏，1隐藏。
	combathideALL = 0,					--战斗中隐藏所有鼠标提示，0不隐藏，1隐藏。
	showTitle = 0,						--是否显示头衔，0不显示，1显示。
	showGRank = 0,						--是否显示在公会中的阶级，0不显示，1显示。
	showCCbdr = 0,						--是否根据职业颜色染色Tooltip边框，0不染色，1染色。
	showRealm = 1,						--不同服务器显示服务器名，0不显示，1显示。如不显示会在名字后显示"*"号。
	opacity = 0.6,						--不透明度，取值在0和1之间，0完全透明，1完全不透明。
	bgcolor = {r = 0, g = 0, b = 0},	--Tooltip默认背景颜色，不建议更改。
	bdrcolor = {r = 0, g = 0, b = 0},	--Tooltip默认边框颜色，不建议更改。
	backdrop = {
		bgFile = "Interface\\AddOns\\FreebTip\\media\\blank",
		edgeFile = "Interface\\AddOns\\FreebTip\\media\\blank",
		edgeSize = 1,
	},
	normal = "Interface\\AddOns\\FreebTip\\media\\normal",
	pushed = "Interface\\AddOns\\FreebTip\\media\\pushed",
	disabled = "Interface\\AddOns\\FreebTip\\media\\disabled",
	highlight = "Interface\\AddOns\\FreebTip\\media\\highlight",
	statusbar = "Interface\\AddOns\\FreebTip\\media\\statusbar",
	sbHeight = 2,
	factionIconSize = 30,
	factionIconAlpha = 0,
}
ns.cfg = cfg

local RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
local qqColor = {r = 1, g = 0, b = 0}
local nilColor = {r = 1, g = 1, b = 1}
local tappedColor = {r = .6, g = .6, b = .6}
local deadColor = {r = .6, g = .6, b = .6}

local powerColors = {}
for power, color in next, PowerBarColor do
	powerColors[power] = color
end
powerColors["MANA"] = {r = .31, g = .45, b = .63}
powerColors["RAGE"] = {r = .69, g = .31, b = .31}

local classification = {
	elite = ("|cffFFCC00 %s|r"):format(ELITE),
	rare = ("|cffCC00FF %s|r"):format(RARE),
	rareelite = ("|cffCC00FF %s|r"):format(RAREELITE),
	worldboss = ("|cffFF0000?? %s|r"):format(BOSS)
}

GameTooltipText:SetFont(cfg.font, cfg.fontsize_normal, cfg.fontflag)
GameTooltipTextSmall:SetFont(cfg.font, cfg.fontsize_small, cfg.fontflag)
GameTooltipHeaderText:SetFont(cfg.font, cfg.fontsize_header, cfg.fontflag)

local factionIcon = {
	["Alliance"] = "Interface\\Timer\\Alliance-Logo",
	["Horde"] = "Interface\\Timer\\Horde-Logo",
}

local hex = function(r, g, b)
	if(r and not b) then
		r, g, b = r.r, r.g, r.b
	end

	return (b and format('|cff%02x%02x%02x', r * 255, g * 255, b * 255)) or "|cffFFFFFF"
end
ns.hex = hex

local numberize = function(val)
	if (locale == "zhCN" or locale == "zhTW") then
		if (val >= 1e8) then
			return ("%.1fE"):format(val / 1e8)
		elseif (val >= 1e6) then
			return ("%.0fW"):format(val / 1e4)
		elseif (val >= 1e4) then
			return ("%.1fW"):format(val / 1e4)
		else
			return ("%d"):format(val)
		end
	else
		if (val >= 1e6) then
			return ("%.0fm"):format(val / 1e6)
		elseif (val >= 1e3) then
			return ("%.0fk"):format(val / 1e3)
		else
			return ("%d"):format(val)
		end
	end
end
ns.numberize = numberize

local function unitColor(unit, mode)
	local colors
	
	if (UnitPlayerControlled(unit)) then
		local _, class = UnitClass(unit)
		if (class and UnitIsPlayer(unit)) then
			-- Players have color
			colors = RAID_CLASS_COLORS[class]
		elseif (UnitCanAttack(unit, "player")) then
			-- Hostiles are red
			colors = FACTION_BAR_COLORS[2]
		elseif (UnitCanAttack("player", unit)) then
			-- Units we can attack but which are not hostile are yellow
			colors = FACTION_BAR_COLORS[4]
		elseif (UnitIsPVP(unit)) then
			-- Units we can assist but are PvP flagged are green
			colors = FACTION_BAR_COLORS[6]
		end
	elseif (UnitIsTapDenied(unit, "player")) then
		colors = tappedColor
	end
	
	if (not colors) then
		local reaction = UnitReaction(unit, "player")
		colors = reaction and FACTION_BAR_COLORS[reaction] or nilColor
	end
	
	if (mode == 1) then
		return colors
	else
		return colors.r, colors.g, colors.b
	end
end
ns.unitColor = unitColor
GameTooltip_UnitColor = unitColor

local function getUnit(self)
	local _, unit = self and self:GetUnit()
	if(not unit) then
		local mFocus = GetMouseFocus()
		unit = mFocus and (mFocus.unit or mFocus:GetAttribute("unit")) or "mouseover"
	end

	return unit
end

FreebTip_Cache = {}
local Cache = FreebTip_Cache
local function getPlayer(unit)
	local guid = UnitGUID(unit)
	if not (Cache[guid]) then
		local class, _, race, _, _, name, realm = GetPlayerInfoByGUID(guid)
		if not name then return end

		local pvpname = UnitPVPName(unit) or name

		if (realm and strlen(realm) > 0) then
			if(cfg.showRealm) then
				realm = ("-"..realm)
			else
				realm = cfg.realmText
			end
		end

		Cache[guid] = {
			name = name,
			class = class,
			race = race,
			realm = realm,
			pvpname = pvpname
		}
	end
	return Cache[guid], guid
end

local function getTarget(unit)
	if(UnitIsUnit(unit, "player")) then
		return ("|cffff0000%s|r"):format(">"..strupper(YOU).."<")
	else
		return UnitName(unit)
	end
end

local function ShowTarget(self, unit)
	if (UnitExists(unit.."target")) then
		local tarRicon = GetRaidTargetIndex(unit.."target")
		local tar = ("%s %s"):format((tarRicon and ICON_LIST[tarRicon].."10|t") or "", getTarget(unit.."target"))

		self:AddLine(TARGET..":"..hex(unitColor(unit.."target"))..tar.."|r")
	end
end

local function hideLines(self)
	for i = 3, self:NumLines() do
		local tipLine = _G["GameTooltipTextLeft"..i]
		local tipText = tipLine:GetText()

		if(tipText == FACTION_ALLIANCE) then
			tipLine:SetText(nil)
			tipLine:Hide()
		elseif(tipText == FACTION_HORDE) then
			tipLine:SetText(nil)
			tipLine:Hide()
		elseif(tipText == PVP) then
			tipLine:SetText(nil)
			tipLine:Hide()
		end
	end
end

local function formatLines(self)
	local hidden = {}
	local numLines = self:NumLines()

	for i = 2, numLines do
		local tipLine = _G["GameTooltipTextLeft"..i]

		if(tipLine and not tipLine:IsShown()) then
			hidden[i] = tipLine
		end
	end

	for i, line in next, hidden do
		local nextLine = _G["GameTooltipTextLeft"..i+1]

		if(nextLine) then
			local point, relativeTo, relativePoint, x, y = line:GetPoint()
			nextLine:SetPoint(point, relativeTo, relativePoint, x, y)
		end
	end
end

local function GTCursor(self, owner)
	if (not self) then return end
	if (not owner) then owner = self:GetOwner() end

	local unit = UnitExists(getUnit(self))
	local parent = (owner == UIParent)

	if (parent and not unit) then return 2 end
	if (not cfg.cursor) then return 0 end
	if (cfg.cursor == 0) then return 0 end
	if (cfg.cursor ~= 1 and InCombatLockdown()) then return 0 end
	if (self:GetAnchorType() ~= "ANCHOR_NONE") then return end
	if (unit) then
		if (cfg.cursormode == 1) then
			return 1
		else
			return 2
		end
	else
		return 3
	end
end

local function GTCursorPosition(self, mode)
	if (mode == 2) then return "ANCHOR_CURSOR" end
	if (not mode) then mode = 1 end

	local scale = UIParent:GetScale() * self:GetScale()
	local mX, mY = GetCursorPosition()
	mX, mY = mX / scale, mY / scale

	if (mode == 1) then
		mX = mX + cfg.cursoroffset[1]
		mY = mY + cfg.cursoroffset[2]
		return mX, mY
	elseif (mode == 3) then
		local width, height = UIParent:GetWidth(), UIParent:GetHeight()
		if (mY < height / 2) then
			if (mX < width / 3 * 2) then
				return "ANCHOR_RIGHT"
			else
				return "ANCHOR_LEFT"
			end
		else
			if (mX < width / 3 * 2) then
				return "ANCHOR_BOTTOMRIGHT"
			else
				return "ANCHOR_BOTTOMLEFT"
			end
		end
	end
end
-------------------------------------------------------------------------------
--[[ GameTooltip HookScripts ]] --

local function OnSetUnit(self)
	if (cfg.combathide and cfg.combathide ~= 0 and InCombatLockdown()) then
		return self:Hide()
	end

	hideLines(self)

	if (not self.factionIcon) then
		self.factionIcon = self:CreateTexture(nil, "OVERLAY")
		self.factionIcon:SetPoint("TOPRIGHT", 8, 8)
		self.factionIcon:SetSize(cfg.factionIconSize,cfg.factionIconSize)
		self.factionIcon:SetAlpha(cfg.factionIconAlpha)
	end

	local unit = getUnit(self)
	local player, guid, isInGuild

	if (UnitExists(unit)) then
		self.ftipUnit = unit

		local isPlayer = UnitIsPlayer(unit)
		if (isPlayer) then
			player, guid, Name = getPlayer(unit)

			if (not cfg.showTitle or cfg.showTitle == 0) then
				Name = player and (player.name..(player.realm or ""))
			else
				Name = player and (player.pvpname..(player.realm or ""))
			end
			if (Name) then GameTooltipTextLeft1:SetText(Name) end

			local guild, gRank = GetGuildInfo(unit)
			if (guild and strlen(guild) > 0) then
				isInGuild = true

				if (not cfg.showGRank or cfg.showGRank == 0) then gRank = nil end
				GameTooltipTextLeft2:SetFormattedText("|cffE41F9B<%s>|r |cffA0A0A0%s|r", guild, gRank or "")
			end
		end

		local status = (UnitIsAFK(unit) and CHAT_FLAG_AFK) or (UnitIsDND(unit) and CHAT_FLAG_DND) or (not UnitIsConnected(unit) and "<DC>")
		if (status) then
			self:AppendText((" |cff00cc00%s|r"):format(status))
		end

		local ricon = GetRaidTargetIndex(unit)
		if (ricon) then
			local text = GameTooltipTextLeft1:GetText()
			GameTooltipTextLeft1:SetFormattedText(("%s %s"), ICON_LIST[ricon].."12|t", text)
		end

		local faction = UnitFactionGroup(unit)
		if (faction and factionIcon[faction]) then
			self.factionIcon:SetTexture(factionIcon[faction])
			self.factionIcon:Show()
		else
			self.factionIcon:Hide()
		end

		local isBattlePet = UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit)
		local level = isBattlePet and UnitBattlePetLevel(unit) or UnitLevel(unit)

		if (level) then
			local levelLine
			for i = (isInGuild and 3) or 2, self:NumLines() do
				local line = _G["GameTooltipTextLeft"..i]
				local text = line:GetText()
				if (text and text:find(LEVEL)) then
					levelLine = line
					break
				end
			end

			if (levelLine) then
				local creature = not isPlayer and UnitCreatureType(unit)
				local race = player and player.race or UnitRace(unit)
				local dead = UnitIsDeadOrGhost(unit) and hex(deadColor)..CORPSE.."|r"
				local classify = UnitClassification(unit)

				local class = player and hex(unitColor(unit))..(player.class or "").."|r"
				if (isBattlePet) then
					class = ("|cff80ACEF(%s)|r"):format(_G["BATTLE_PET_NAME_"..UnitBattlePetType(unit)])
				end

				local lvltxt, diff
				if (level == -1) then
					level = classification.worldboss
					lvltxt = level
				else
					level = ("%d"):format(level)
					diff = not isBattlePet and GetQuestDifficultyColor(level)
					lvltxt = ("%s%s|r%s"):format(hex(diff), level, (classify and classification[classify] or ""))
				end

				if (dead) then
					levelLine:SetFormattedText("%s %s", lvltxt, dead)
					GameTooltipStatusBar:Hide()
				else
					levelLine:SetFormattedText("%s %s", lvltxt, (creature or race) or "")

					if (cfg.hpbar and cfg.hpbar ~= 0) then
						GameTooltipStatusBar:SetStatusBarColor(unitColor(unit))
					else
						GameTooltipStatusBar:Hide()
					end

					if (cfg.powerbar and cfg.powerbar ~= 0) then
						local pMin, pMax = UnitPower(unit), UnitPowerMax(unit)

						if (pMin > 0) then
							FreebTipPowerBar:SetMinMaxValues(0, pMax)
							FreebTipPowerBar:SetValue(pMin)
							local pType, pToken = UnitPowerType(unit)
							local pColor = powerColors[pToken]
							FreebTipPowerBar:SetStatusBarColor(pColor.r, pColor.g, pColor.b)
							FreebTipPowerBar:Show()
						else
							FreebTipPowerBar:Hide()
						end
					end
				end

				if (class) then
					lvltxt = levelLine:GetText()
					levelLine:SetFormattedText("%s %s", lvltxt, class)
				end

				if (UnitIsPVP(unit) and UnitCanAttack("player", unit)) then
					lvltxt = levelLine:GetText()
					levelLine:SetFormattedText("%s |cff00FF00(%s)|r", lvltxt, PVP)
				end
			end
		end
		ShowTarget(self, unit)
	end
	formatLines(self)
end

local function tipCleared(self)
	if (self.factionIcon) then
		self.factionIcon:Hide()
	end

	self.ftipUpdate = 1
	self.ftipNumLines = 0
	self.ftipUnit = nil
end

local function GTUpdate(self, elapsed)
	if (GTCursor(self) == 1) then
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", UIParent,"BOTTOMLEFT", GTCursorPosition(self))
	end

	self.ftipUpdate = (self.ftipUpdate or 0) + elapsed
	if (self.ftipUpdate < 0.1) then return end
	if (not cfg.fadeOnUnit or cfg.fadeOnUnit == 0) then
		if (self.ftipUnit and not UnitExists(self.ftipUnit)) then self:Hide() return end
	end

	local ftipCursor = self:GetAnchorType()
	if (ftipCursor ~= self.ftipCursor) then
		if (not self.ftipUnit and GetMouseFocus() == WorldFrame) then
			self:SetBackdropColor(cfg.bgcolor.r, cfg.bgcolor.g, cfg.bgcolor.b, cfg.opacity)
		end
		self.ftipCursor = ftipCursor
	end

	if (cfg.showCCbdr and cfg.showCCbdr ~= 0 and not self:GetItem()) then
		local ftipBorder
		if (self.ftipUnit) then
			ftipBorder = unitColor(self.ftipUnit, 1)
		else
			ftipBorder = cfg.bdrcolor
		end
		if (hex(ftipBorder) ~= hex(self.ftipBorder)) then
			self:SetBackdropBorderColor(ftipBorder.r, ftipBorder.g, ftipBorder.b)
			self.ftipBorder = ftipBorder
		end
	end

	local ftipNumLines = self:NumLines()
	if (ftipNumLines ~= self.ftipNumLines) then
		formatLines(self)
		self.ftipNumLines = ftipNumLines
	end

	if (not self.ftipShown) then self:SetAlpha(1) self.ftipShown = true end
	
	self.ftipUpdate = 0
end

GameTooltip.FadeOut = function(self)
	if (not cfg.fadeOnUnit or cfg.fadeOnUnit == 0) then
		self:Hide()
	end
end

GameTooltip:HookScript("OnTooltipSetUnit", OnSetUnit)
GameTooltip:HookScript("OnTooltipCleared", tipCleared)
GameTooltip:HookScript("OnUpdate", GTUpdate)
GameTooltip:HookScript("OnShow", function(self) self:SetAlpha(0) self.ftipShown = nil end)

hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
	if (GTCursor(tooltip, parent)) then
		local mode = GTCursor(tooltip, parent)

		tooltip:ClearAllPoints()
		tooltip:SetOwner(parent, "ANCHOR_NONE")

		if (mode == 0) then
			tooltip:SetPoint(cfg.point[1], UIParent, cfg.point[1], cfg.point[2], cfg.point[3])
		elseif (mode == 1) then
			tooltip:SetPoint("TOPLEFT", UIParent,"BOTTOMLEFT", GTCursorPosition(tooltip))
		else
			tooltip:SetOwner(parent, GTCursorPosition(tooltip, mode))
		end
	end
end)

-------------------------------------------------------------------------------
--[[ GameTooltipStatusBar ]]--

GameTooltipStatusBar:SetStatusBarTexture(cfg.statusbar)
GameTooltipStatusBar:SetHeight(cfg.sbHeight)
GameTooltipStatusBar:ClearAllPoints()
GameTooltipStatusBar:SetPoint("BOTTOMLEFT", GameTooltipStatusBar:GetParent(), "TOPLEFT", 4, -6)
GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", GameTooltipStatusBar:GetParent(), "TOPRIGHT", -4, -6)

local gtSBbg = GameTooltipStatusBar:CreateTexture(nil, "BACKGROUND")
gtSBbg:SetAllPoints(GameTooltipStatusBar)
gtSBbg:SetTexture(cfg.statusbar)
gtSBbg:SetVertexColor(0.3, 0.3, 0.3, 0.5)

local function gtSBValChange(self, value)
	if (not value) then
		return
	end
	local vMin, vMax = self:GetMinMaxValues()
	if (value < vMin) or (value > vMax) then
		return
	end

	if (not self.text) then
		self.text = self:CreateFontString(nil, "OVERLAY")
		self.text:SetPoint("CENTER", GameTooltipStatusBar, 0, 0)
		self.text:SetFont(cfg.font, cfg.fontsize_value, "THICKOUTLINE")
	end

	if (cfg.hpbarText and cfg.hpbarText ~= 0) then
		local hp
		self.text:Show()
		if cfg.hpbarText == 1 then
			hp = numberize(self:GetValue())
		else
			hp = numberize(self:GetValue()).." / "..numberize(vMax)
		end
		self.text:SetText(hp)
	else
		self.text:Hide()
	end
end
GameTooltipStatusBar:HookScript("OnValueChanged", gtSBValChange)

-------------------------------------------------------------------------------
--[[ FreebTipPowerBar ]]--

local FreebTipPowerBar = CreateFrame("StatusBar", "FreebTipPowerBar", GameTooltipStatusBar)
FreebTipPowerBar:SetFrameLevel(GameTooltipStatusBar:GetFrameLevel())
FreebTipPowerBar:SetHeight(GameTooltipStatusBar:GetHeight())
FreebTipPowerBar:SetWidth(0)
FreebTipPowerBar:SetStatusBarTexture(cfg.statusbar)
FreebTipPowerBar:ClearAllPoints()
FreebTipPowerBar:SetPoint("TOPLEFT", GameTooltipStatusBar:GetParent(), "BOTTOMLEFT", 4, 6)
FreebTipPowerBar:SetPoint("TOPRIGHT", GameTooltipStatusBar:GetParent(), "BOTTOMRIGHT", -4, 6)
FreebTipPowerBar:Hide()

local gtPBbg = FreebTipPowerBar:CreateTexture(nil, "BACKGROUND")
gtPBbg:SetAllPoints(FreebTipPowerBar)
gtPBbg:SetTexture(cfg.statusbar)
gtPBbg:SetVertexColor(0.3, 0.3, 0.3, 0.5)

local function UpdatePower(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if (self.elapsed < .2) then return end
	self.elapsed = 0

	local unit = GameTooltip.ftipUnit

	if (UnitExists(unit)) then
		local pMin, pMax = UnitPower(unit), UnitPowerMax(unit)

		if (pMin > 0) then
			self:SetMinMaxValues(0, pMax)
			self:SetValue(pMin)
		end

		if (not self.text) then
			self.text = self:CreateFontString(nil, "OVERLAY")
			self.text:SetPoint("CENTER", self, "CENTER", 0, 0)
			self.text:SetFont(cfg.font, cfg.fontsize_value, "THICKOUTLINE")
		end

		if (cfg.powerbarText and cfg.powerbarText ~= 0) then
			local power
			self.text:Show()
			if cfg.powerbarText == 1 then
				power = numberize(self:GetValue())
			else
				power = numberize(self:GetValue()).." / "..numberize(pMax)
			end
			self.text:SetText(power)
		else
			self.text:Hide()
		end
	end
end
FreebTipPowerBar:SetScript("OnUpdate", UpdatePower)

-------------------------------------------------------------------------------
--[[ Style ]] --

local shopping = {
	"ShoppingTooltip1",
	"ShoppingTooltip2",
	"ItemRefShoppingTooltip1",
	"ItemRefShoppingTooltip2",
	"WorldMapCompareTooltip1",
	"WorldMapCompareTooltip2",
}

local tooltips = {
	"ChatMenu",
	"EmoteMenu",
	"LanguageMenu",
	"VoiceMacroMenu",
	"GameTooltip",
	"ItemRefTooltip",
	"WorldMapTooltip",
	"DropDownList1MenuBackdrop",
	"DropDownList2MenuBackdrop",
	"AutoCompleteBox",
	"FriendsTooltip",
	"FloatingBattlePetTooltip",
}

local itemUpdate = {}
local function style(frame)
	local frameName = frame and frame:GetName()
	if (not frameName) then return end
	frame:SetScale(cfg.scale)

	local ftipBD = frame.BackdropFrame or frame
	if (not frame.ftipBD) then
		ftipBD:SetBackdrop(cfg.backdrop)
		frame.ftipBD = true
	end

	ftipBD:SetBackdropColor(cfg.bgcolor.r, cfg.bgcolor.g, cfg.bgcolor.b, cfg.opacity)
	ftipBD:SetBackdropBorderColor(cfg.bdrcolor.r, cfg.bdrcolor.g, cfg.bdrcolor.b)

	if (cfg.showCCbdr and cfg.showCCbdr ~= 0 and frame.ftipUnit) then
		frame:SetBackdropBorderColor(unitColor(frame.ftipUnit))
	end

	if (frame.GetItem) then
		local _, item = frame:GetItem()
		if (item) then
			local quality = select(3, GetItemInfo(item))
			if (quality) then
				local r, g, b = GetItemQualityColor(quality)
				frame:SetBackdropBorderColor(r, g, b)
				itemUpdate[frameName] = nil
			else
				itemUpdate[frameName] = true
			end
		end
	end

	if (frame.hasMoney and frame.numMoneyFrames ~= frame.ftipNumMFrames) then
		for i = 1, frame.numMoneyFrames do
			_G[frameName.."MoneyFrame"..i.."PrefixText"]:SetFontObject(GameTooltipText)
			_G[frameName.."MoneyFrame"..i.."SuffixText"]:SetFontObject(GameTooltipText)
			_G[frameName.."MoneyFrame"..i.."GoldButtonText"]:SetFontObject(GameTooltipText)
			_G[frameName.."MoneyFrame"..i.."SilverButtonText"]:SetFontObject(GameTooltipText)
			_G[frameName.."MoneyFrame"..i.."CopperButtonText"]:SetFontObject(GameTooltipText)
		end
		frame.ftipNumMFrames = frame.numMoneyFrames
	end

	if (frame.shopping and not frame.ftipFontSet) then
		_G[frameName.."TextLeft1"]:SetFontObject(GameTooltipTextSmall)
		_G[frameName.."TextRight1"]:SetFontObject(GameTooltipText)
		_G[frameName.."TextLeft2"]:SetFontObject(GameTooltipHeaderText)
		_G[frameName.."TextRight2"]:SetFontObject(GameTooltipTextSmall)
		_G[frameName.."TextLeft3"]:SetFontObject(GameTooltipTextSmall)
		_G[frameName.."TextRight3"]:SetFontObject(GameTooltipTextSmall)
		_G[frameName.."TextRight4"]:SetFontObject(GameTooltipTextSmall)
		frame.ftipFontSet = true
	end

	if (frame.BattlePet and not frame.ftipBPfont) then
		frame.Name:SetFontObject(GameTooltipHeaderText)
		frame.BattlePet:SetFontObject(GameTooltipText)
		frame.PetType:SetFontObject(GameTooltipText)
		frame.Health:SetFontObject(GameTooltipText)
		frame.Level:SetFontObject(GameTooltipText)
		frame.Power:SetFontObject(GameTooltipText)
		frame.Speed:SetFontObject(GameTooltipText)
		frame.Owned:SetFontObject(GameTooltipText)
		frame.BorderTop:Hide()
		frame.BorderRight:Hide()
		frame.BorderBottom:Hide()
		frame.BorderLeft:Hide()
		frame.BorderTopLeft:Hide()
		frame.BorderTopRight:Hide()
		frame.BorderBottomLeft:Hide()
		frame.BorderBottomRight:Hide()
		frame.ftipBPfont = true
	end

	if (frame.Garrison and not frame.ftipGarrison) then
		frame.BorderTop:Hide()
		frame.BorderRight:Hide()
		frame.BorderBottom:Hide()
		frame.BorderLeft:Hide()
		frame.BorderTopLeft:Hide()
		frame.BorderTopRight:Hide()
		frame.BorderBottomLeft:Hide()
		frame.BorderBottomRight:Hide()
		frame.Background:Hide()
		frame.ftipGarrison = true
	end

	local ItemRefTooltipIndex = strmatch(frameName, "ItemRefTooltip(.*)")
	if (ItemRefTooltipIndex and not frame.ftipCloseButton) then
		if (strlen(ItemRefTooltipIndex) == 0) then
			_G["ItemRefCloseButton"]:Hide()
		end
		local CloseButton = CreateFrame("Button", nil, frame)
		CloseButton:SetPoint("TOPRIGHT", 1, 0)
		CloseButton:SetSize(32, 32)
		CloseButton:SetNormalTexture(cfg.normal)
		CloseButton:SetPushedTexture(cfg.pushed)
		CloseButton:SetDisabledTexture(cfg.disabled)
		CloseButton:SetHighlightTexture(cfg.highlight, "ADD")
		CloseButton:SetScript("OnClick", function(self) HideUIPanel(self:GetParent()) end)
		frame.ftipCloseButton = true
	end
end
ns.style = style

local function OverrideGetBackdropColor()
	return cfg.bgcolor.r, cfg.bgcolor.g, cfg.bgcolor.b, cfg.opacity
end
GameTooltip.GetBackdropColor = OverrideGetBackdropColor
GameTooltip:SetBackdropColor(OverrideGetBackdropColor)

local function OverrideGetBackdropBorderColor()
	return cfg.bdrcolor.r, cfg.bdrcolor.g, cfg.bdrcolor.b
end
GameTooltip.GetBackdropBorderColor = OverrideGetBackdropBorderColor
GameTooltip:SetBackdropBorderColor(OverrideGetBackdropBorderColor)

local function framehook(frame)
	frame:HookScript("OnShow", function(self)
		if (cfg.combathideALL and cfg.combathideALL ~= 0 and InCombatLockdown()) then
			return self:Hide()
		end
		style(self)
	end)
end

local frameload = CreateFrame("Frame")
frameload:RegisterEvent("ADDON_LOADED")
frameload:RegisterEvent("PLAYER_ENTERING_WORLD")
frameload:SetScript("OnEvent", function(self, event, arg1)
	if (event == "PLAYER_ENTERING_WORLD") then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")

		for i, tip in ipairs(tooltips) do
			local frame = _G[tip]
			if (frame) then
				framehook(frame)
			end
		end

		for i, tip in ipairs(shopping) do
			local frame = _G[tip]
			if (frame) then
				framehook(frame)
				frame.shopping = true
			end
		end

		local frame = _G["GarrisonFollowerAbilityWithoutCountersTooltip"]
		if (frame) then
			framehook(frame)
			frame.Garrison = true
		end
	elseif (arg1 == "Blizzard_PVPUI") then
		self:UnregisterEvent("ADDON_LOADED")

		local frame = _G["PVPRewardTooltip"]
		if (frame) then
			framehook(frame)
		end
	end
end)

local itemEvent = CreateFrame("Frame")
itemEvent:RegisterEvent("GET_ITEM_INFO_RECEIVED")
itemEvent:SetScript("OnEvent", function(self, event, arg1)
	for k in next, itemUpdate do
		local tip = _G[k]
		if (tip and tip:IsShown()) then
			style(tip)
		end
	end
end)
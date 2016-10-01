-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local Size, Space = 32, 5.6
local Width, Height, MaxAura = 220, 18, 40
local PlayerAuraList, TargetAuraList = {}, {}
local ClassColor = RAID_CLASS_COLORS[DB.MyClass]

local function CreateIcon()
	local Aura = CreateFrame("Frame", nil, UIParent)
	Aura:SetSize(Size, Size)
	
	Aura.Icon = Aura:CreateTexture(nil, "ARTWORK") 
	Aura.Icon:SetAllPoints()
	Aura.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	Aura.Icon.Shadow = S.MakeTextureShadow(Aura, Aura.Icon, 2)
	
	Aura.Count = S.MakeText(Aura, 10)
	Aura.Count:SetPoint("BOTTOMRIGHT", 3, -2)
	
	Aura.Cooldown = CreateFrame("Cooldown", nil, Aura) 
	Aura.Cooldown:SetAllPoints() 
	Aura.Cooldown:SetReverse(true)

	return Aura
end

local function CreateStatusBar()
	local Aura = CreateFrame("Frame", nil, UIParent)
	Aura:SetSize(Width, Height)
	
	Aura.Icon = Aura:CreateTexture(nil, "ARTWORK")
	Aura.Icon:SetPoint("LEFT")
	Aura.Icon:SetSize(Height, Height)
	Aura.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	Aura.Icon.Shadow = S.MakeTextureShadow(Aura, Aura.Icon, 2)

	Aura.Statusbar = CreateFrame("StatusBar", nil, Aura)
	Aura.Statusbar:SetPoint("BOTTOMRIGHT") 
	Aura.Statusbar:SetSize(Width-Height-4, Height/3)
	Aura.Statusbar:SetStatusBarTexture(DB.Statusbar) 
	Aura.Statusbar:SetStatusBarColor(ClassColor.r, ClassColor.g, ClassColor.b, 0.9)
	Aura.Statusbar.Shadow = S.MakeShadow(Aura.Statusbar, 2)

	Aura.Count = S.MakeText(Aura, 9)
	Aura.Count:SetPoint("BOTTOMRIGHT", Aura.Icon, 3, 0) 

	Aura.Time = S.MakeText(Aura.Statusbar, 10)
	Aura.Time:SetPoint("RIGHT", 0, 5) 

	Aura.Spellname = S.MakeText(Aura.Statusbar, 10)
	Aura.Spellname:SetPoint("CENTER", -10, 5)
		
	return Aura
end

local function UpdatePlayerAura()
	local Index = 0
	
	for i = 1, MaxAura do
		local Aura = nil
		local name, _, icon, count, _, duration, expires, caster = UnitBuff("player", i)

		if not name then
			break
		end

		if duration > 0 and duration < 60 and caster == "player"  then
			Index = Index + 1

			if not PlayerAuraList[Index] then
				Aura = CreateIcon()

				if Index == 1 then
					Aura:SetPoint("BOTTOMLEFT", _G["oUF_SoraPlayer"], "TOPLEFT", 0, 12)
				elseif Index%6 == 1 then
					Aura:SetPoint("BOTTOMLEFT", PlayerAuraList[Index-6], "TOPLEFT", 0, Space)
				else
					Aura:SetPoint("LEFT", PlayerAuraList[Index-1], "RIGHT", Space, 0)
				end

				PlayerAuraList[Index] = Aura
			else 
				Aura = PlayerAuraList[Index]
			end
			
			Aura.Icon:SetTexture(icon)
			Aura.Count:SetText(count > 1 and count or "")		
			CooldownFrame_Set(Aura.Cooldown, expires-duration, duration, 1)
			
			Aura:Show()
		end
	end
	
	for i = Index + 1, #PlayerAuraList do
		PlayerAuraList[i]:Hide()
		PlayerAuraList[i]:SetScript("OnUpdate", nil)
	end
end

local function UpdateTargetAura()
	local Index = 0
	local IsFriend = UnitIsFriend("player", "target") and "HELPFUL" or "HARMFUL"

	for i = 1, 40 do
		local Aura = nil
		local name, _, icon, count, _, duration, expires, caster = UnitAura("target", i, IsFriend)

		if not name then
			break
		end

		if duration > 0 and duration < 60 and caster == "player"  then
			Index = Index + 1

			if not TargetAuraList[Index] then
				Aura = CreateStatusBar()

				if Index == 1 then
					Aura:SetPoint("BOTTOM", _G["oUF_SoraTarget"], "TOP", 0, 4)
				else
					Aura:SetPoint("BOTTOM", TargetAuraList[Index-1], "TOP", 0, 4)
				end

				TargetAuraList[Index] = Aura
			else 
				Aura = TargetAuraList[Index]
			end
			
			Aura.Icon:SetTexture(icon)
			Aura.Spellname:SetText(name)
			Aura.Statusbar:SetMinMaxValues(0, duration)
			Aura.Count:SetText(count > 1 and count or "")	

			Aura.Timer = 0
			Aura:SetScript("OnUpdate", function(self, elapsed, ...)
				self.Timer = expires-GetTime()
				if self.Timer < 60 then
					self.Statusbar:SetValue(self.Timer)
					self.Time:SetFormattedText("%.1f", self.Timer)
				end
			end)
			
			Aura:Show()
		end
	end
	
	for i = Index+1, #TargetAuraList do
		TargetAuraList[i]:Hide()
		TargetAuraList[i]:SetScript("OnUpdate", nil)
	end
end

local function OnUnitAura(self, event, unit, ...)
	if unit == "player" then
		UpdatePlayerAura()
	elseif unit == "target" then
		UpdateTargetAura()
	end
end

local function OnPlayerTargetChanged(self, event, unit, ...)
	UpdateTargetAura()
end

local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("UNIT_AURA")
Event:RegisterEvent("PLAYER_TARGET_CHANGED")
Event:SetScript("OnEvent", function(self, event, unit, ...)
	if event == "UNIT_AURA" then
		OnUnitAura(self, event, unit, ...)
	elseif event == "PLAYER_TARGET_CHANGED" then
		OnPlayerTargetChanged(self, event, unit, ...)
	end
end)
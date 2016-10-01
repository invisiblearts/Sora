local _G = _G
local ReplaceBags = 0
local LastButtonBag, LastButtonBank, LastButtonReagent
local NUM_CONTAINER_FRAMES = NUM_CONTAINER_FRAMES
local NUM_BAG_FRAMES = NUM_BAG_FRAMES
local ContainerFrame_GetOpenFrame = ContainerFrame_GetOpenFrame
local BankFrame = BankFrame
local ReagentBankFrame = ReagentBankFrame
local BagHelpBox = BagHelpBox
local ButtonSetSize = 38
local ButtonSpacing = 1
local BagItemsPerRow = 12
local BankItemsPerRow = 18
local glow = "Interface\\AddOns\\Tbags\\glow"
SetSortBagsRightToLeft(false)
SetInsertItemsLeftToRight(true)
if (GetLocale() == "zhCN") then 
L = {};
WEAPON = "武器"
ARMOR = "护甲"
L["布甲"]="布"
L["皮甲"]="皮"
L["锁甲"]="锁"
L["板甲"]="板"

L["INVTYPE_SHIELD"]="盾"
L["INVTYPE_HOLDABLE"]="副手"
L["INVTYPE_HEAD"]="头"
L["INVTYPE_SHOULDER"]="肩"
L["INVTYPE_ROBE"]="胸"
L["INVTYPE_CHEST"]="胸"
L["INVTYPE_WAIST"]="腰"
L["INVTYPE_LEGS"]="腿"
L["INVTYPE_FEET"]="脚"
L["INVTYPE_WRIST"]="腕"
L["INVTYPE_HAND"]="手"
L["INVTYPE_WEAPONOFFHAND"]="副武"
elseif (GetLocale() == "zhTW") then 
L = {};
WEAPON = "武器"
ARMOR = "護甲"
L["布甲"]="布"
L["皮甲"]="皮"
L["锁甲"]="鎖"
L["板甲"]="鎧"
L["INVTYPE_SHIELD"]="盾"
L["INVTYPE_HOLDABLE"]="副手"
L["INVTYPE_HEAD"]="頭"
L["INVTYPE_SHOULDER"]="肩"
L["INVTYPE_CHEST"]="胸"
L["INVTYPE_WAIST"]="腰"
L["INVTYPE_LEGS"]="腿"
L["INVTYPE_FEET"]="腳"
L["INVTYPE_WRIST"]="腕"
L["INVTYPE_HAND"]="手"
L["INVTYPE_WEAPONOFFHAND"]="副武"					
else
WEAPON = "Weapon"
ARMOR = "Armor"
end


local function Kill(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
	end
	object.Show = function() return end
	object:Hide()
end

local function SetTemplate(f)
	f:SetBackdrop({
	  bgFile = "Interface\\Buttons\\WHITE8x8",
	  edgeFile = glow,
	  edgeSize = 2,
	insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
		
	f:SetBackdropColor(0, 0, 0,.4)
	f:SetBackdropBorderColor(0, 0, 0,1)
end

local function SetInside(obj, anchor)
	anchor = anchor or obj:GetParent()
	if obj:GetPoint() then obj:ClearAllPoints() end
	obj:SetPoint("TOPLEFT", anchor, "TOPLEFT", 3, -3)
	obj:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -3, 3)
end
--[[
local function StyleButton(button) 
	if button.SetHighlightTexture and not button.hover then
		local hover = button:CreateTexture("frame", nil, self)
		hover:SetTexture(1, 1, 1, 0.2)
		SetInside(hover)
		button.hover = hover
		button:SetHighlightTexture(hover)
	end

	if button.SetPushedTexture and not button.pushed then
		local pushed = button:CreateTexture("frame", nil, self)
		pushed:SetTexture(0.9, 0.8, 0.1, 0.3)
		SetInside(pushed)
		button.pushed = pushed
		button:SetPushedTexture(pushed)
	end

	if button.SetCheckedTexture and not button.checked then
		local checked = button:CreateTexture("frame", nil, self)
		checked:SetTexture(0,1,0,.3)
		SetInside(checked)
		button.checked = checked
		button:SetCheckedTexture(checked)
	end

	local cooldown = button:GetName() and _G[button:GetName().."Cooldown"]
	if cooldown then
		cooldown:ClearAllPoints()
		SetInside(cooldown)
	end
end
]]
local function FontString(parent, name, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetJustifyH("LEFT")
	if not name then
		parent.text = fs
	else
		parent[name] = fs
	end
	return fs
end

-- Skinning
local function SkinButton(f)
	if f:GetName() then
		local l = _G[f:GetName().."Left"]
		local m = _G[f:GetName().."Middle"]
		local r = _G[f:GetName().."Right"]

		if l then l:SetAlpha(0) end
		if m then m:SetAlpha(0) end
		if r then r:SetAlpha(0) end
	end

	if f.Left then f.Left:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end	
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.SetNormalTexture then f:SetNormalTexture("") end
	if f.SetHighlightTexture then f:SetHighlightTexture("") end
	if f.SetPushedTexture then f:SetPushedTexture("") end
	if f.SetDisabledTexture then f:SetDisabledTexture("") end
	SetTemplate(f)
end

local function StripTextures(object, kill)
	for i=1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region:GetObjectType() == "Texture" then
			if kill then Kill(region) else region:SetTexture(nil) end
		end
	end
end



local Boxes = {
	BagItemSearchBox,
	BankItemSearchBox,
}

local BlizzardBags = {
	CharacterBag0Slot,
	CharacterBag1Slot,
	CharacterBag2Slot,
	CharacterBag3Slot,
}

local BlizzardBank = {
	BankFrameBag1,
	BankFrameBag2,
	BankFrameBag3,
	BankFrameBag4,
	BankFrameBag5,
	BankFrameBag6,
	BankFrameBag7,
}

function SkinBagButton(Button)
	if Button.IsSkinned then return end

	local Icon = _G[Button:GetName()  ..  "IconTexture"]
	local Quest = _G[Button:GetName()  ..  "IconQuestTexture"]
	local JunkIcon = Button.JunkIcon
	local Border = Button.IconBorder
	local BattlePay = Button.BattlepayItemTexture

	Border:SetAlpha(0)

	Icon:SetTexCoord(.08, .92, .08, .92)
	SetInside(Icon,Button)
	if Quest then Quest:SetAlpha(0) end
	if JunkIcon then JunkIcon:SetAlpha(0) end
	if BattlePay then BattlePay:SetAlpha(0) end

	Button:SetNormalTexture("")
	Button:SetPushedTexture("")
	SetTemplate(Button)
	Button:SetBackdropColor(0, 0, 0,0)
--	StyleButton(Button)
	Button.IsSkinned = true

end

function HideBlizzard()
	local TokenFrame = _G["BackpackTokenFrame"]
	local Inset = _G["BankFrameMoneyFrameInset"]
	local Border = _G["BankFrameMoneyFrameBorder"]
	local BankClose = _G["BankFrameCloseButton"]
	local BankPortraitTexture = _G["BankPortraitTexture"]
	local BankSlotsFrame = _G["BankSlotsFrame"]

	TokenFrame:GetRegions():SetAlpha(0)
	Inset:Hide()
	Border:Hide()
	BankClose:Hide()
	BankPortraitTexture:Hide()
	Kill(BagHelpBox)
	BankFrame:EnableMouse(false)
	BankFrame:DisableDrawLayer("BACKGROUND")
	BankFrame:DisableDrawLayer("BORDER")
	BankFrame:DisableDrawLayer("OVERLAY")


	for i = 1, 12 do
		local CloseButton = _G["ContainerFrame" .. i .. "CloseButton"]
		CloseButton:Hide()
		for k = 1, 7 do
			local Container = _G["ContainerFrame" .. i]
			select(k, Container:GetRegions()):SetAlpha(0)
		end
	end

	for i = 1, BankFrame:GetNumRegions() do
		local Region = select(i, BankFrame:GetRegions())
		Region:SetAlpha(0)
	end

	for i = 1, BankSlotsFrame:GetNumRegions() do
		local Region = select(i, BankSlotsFrame:GetRegions())
		Region:SetAlpha(0)
	end

	for i = 1, 2 do
		local Tab = _G["BankFrameTab" .. i]
		Tab:Hide()
	end
end

function CreateReagentContainer()
	StripTextures(ReagentBankFrame)
	local Reagent = CreateFrame("Frame", "DuffedUI_Reagent", UIParent)
	local SwitchBankButton = CreateFrame("Button", nil, Reagent)
	local SortButton = CreateFrame("Button", nil, Reagent)
	local NumButtons = ReagentBankFrame.size
	local NumRows, LastRowButton, NumButtons, LastButton = 0, ReagentBankFrameItem1, 1, ReagentBankFrameItem1
	local Deposit = ReagentBankFrame.DespositButton
ReagentBankFrame:EnableMouse(false)
	Reagent:SetWidth(((ButtonSetSize + ButtonSpacing) * BankItemsPerRow) + 22 - ButtonSpacing)
	Reagent:SetPoint("BOTTOMRIGHT", DuffedUI_Bag, "BOTTOMLEFT", 0, 0)
	SetTemplate(Reagent)
	Reagent:SetFrameStrata(_G["DuffedUI_Bank"]:GetFrameStrata())
	Reagent:SetFrameLevel(_G["DuffedUI_Bank"]:GetFrameLevel())

	SwitchBankButton:SetSize(75, 23)
	SkinButton(SwitchBankButton)
	SwitchBankButton:SetPoint("BOTTOMLEFT", Reagent, "BOTTOMLEFT", 10, 7)
	FontString(SwitchBankButton,"Text", STANDARD_TEXT_FONT, 15,"THINOUTLINE")
	SwitchBankButton.Text:SetPoint("CENTER")
	SwitchBankButton.Text:SetText(BANK)
	SwitchBankButton:SetScript("OnClick", function()
		Reagent:Hide()
		_G["DuffedUI_Bank"]:Show()
		BankFrame_ShowPanel(BANK_PANELS[1].name)
		for i = 5, 11 do
			if (not IsBagOpen(i)) then OpenBag(i, 1) end
		end
	end)

	Deposit:SetParent(Reagent)
	Deposit:ClearAllPoints()
	Deposit:SetSize(120, 23)
	Deposit:SetPoint("BOTTOM", Reagent, "BOTTOM", 0, 7)
	SkinButton(Deposit)
--[[
	SortButton:SetSize(75, 23)
	SortButton:SetPoint("BOTTOMRIGHT", Reagent, "BOTTOMRIGHT", -85, 7)
	SkinButton(SortButton)
	FontString(SortButton,"Text", STANDARD_TEXT_FONT, 15,"THINOUTLINE")
	SortButton.Text:SetPoint("CENTER")
	SortButton.Text:SetText(BAG_FILTER_CLEANUP)
	SortButton:SetScript("OnClick", SortReagentBankBags)	
]]
	for i = 1, 98 do
		local Button = _G["ReagentBankFrameItem" .. i]
		local Icon = _G[Button:GetName() .. "IconTexture"]

		ReagentBankFrame:SetParent(Reagent)
		ReagentBankFrame:ClearAllPoints()
		ReagentBankFrame:SetAllPoints()

		Button:ClearAllPoints()
		Button:SetSize(ButtonSetSize, ButtonSetSize)
		Button:SetFrameStrata("HIGH")
		Button:SetFrameLevel(2)
		Button:SetNormalTexture("")
		Button:SetPushedTexture("")
		Button:SetHighlightTexture("")
		SetTemplate(Button)
		Button:SetBackdropColor(0, 0, 0,0)
		Button.IconBorder:SetAlpha(0)


		if (i == 1) then
			Button:SetPoint("TOPLEFT", Reagent, "TOPLEFT", 10, -10)
			LastRowButton = Button
			LastButton = Button
		elseif (NumButtons == BankItemsPerRow) then
			Button:SetPoint("TOPRIGHT", LastRowButton, "TOPRIGHT", 0, -(ButtonSpacing + ButtonSetSize))
			Button:SetPoint("BOTTOMLEFT", LastRowButton, "BOTTOMLEFT", 0, -(ButtonSpacing + ButtonSetSize))
			LastRowButton = Button
			NumRows = NumRows + 1
			NumButtons = 1
		else
			Button:SetPoint("TOPRIGHT", LastButton, "TOPRIGHT", (ButtonSpacing + ButtonSetSize), 0)
			Button:SetPoint("BOTTOMLEFT", LastButton, "BOTTOMLEFT", (ButtonSpacing + ButtonSetSize), 0)
			NumButtons = NumButtons + 1
		end
		Icon:SetTexCoord(.08, .92, .08, .92)
		SetInside(Icon)
		LastButton = Button
	end
	Reagent:SetHeight(((ButtonSetSize + ButtonSpacing) * (NumRows + 1) + 50) - ButtonSpacing)

	local Unlock = ReagentBankFrameUnlockInfo
	local UnlockButton = ReagentBankFrameUnlockInfoPurchaseButton
	StripTextures(Unlock)
	Unlock:SetAllPoints(Reagent)
	SetTemplate(Unlock)
	Unlock:SetBackdropColor(0, 0, 0,0)
	SkinButton(UnlockButton)
end

function CreateContainer(storagetype, ...)
	local Container = CreateFrame("Frame", "DuffedUI_" .. storagetype, UIParent)
	Container:SetScale(1)
	
	Container:SetPoint(...)
	Container:SetFrameStrata("MEDIUM")
	Container:SetFrameLevel(50)
	Container:Hide()
	Container:EnableMouse(true)
	Container:SetMovable(true)
	Container:SetUserPlaced(false)
	Container:SetClampedToScreen(false)
	Container:SetScript("OnMouseDown", function() Container:StartMoving() end)
	Container:SetScript("OnMouseUp", function() Container:StopMovingOrSizing() end)
	SetTemplate(Container)
	

	if (storagetype == "Bag") then
	Container:SetWidth(((ButtonSetSize + ButtonSpacing) * BagItemsPerRow) + 22 - ButtonSpacing)
		local Sort = BagItemAutoSortButton
		local SortButton = CreateFrame("Button", nil, Container)
		local BagsContainer = CreateFrame("Frame", nil, UIParent)
		local ToggleBagsContainer = CreateFrame("Frame")

		BagsContainer:SetParent(Container)
		BagsContainer:SetWidth(10)
		BagsContainer:SetHeight(10)
		BagsContainer:SetPoint("BOTTOM", Container, "TOP", 0, 3)
		BagsContainer:Hide()
		SetTemplate(BagsContainer)
--[[
		SortButton:SetSize(75, 23)
		SortButton:ClearAllPoints()
		SortButton:SetPoint("BOTTOMRIGHT", Container, "BOTTOMRIGHT", -100, 7)
		SortButton:SetFrameLevel(Container:GetFrameLevel() + 1)
		SortButton:SetFrameStrata(Container:GetFrameStrata())
		StripTextures(SortButton)
		SkinButton(SortButton)

		SortButton:SetScript('OnMouseDown', function(self, button) 
		if InCombatLockdown() then return end
		if button == "RightButton" then JPack:Pack(nil, 1) else JPack:Pack(nil, 2) end
		end)
		FontString(SortButton,"Text", STANDARD_TEXT_FONT, 15,"THINOUTLINE")
		SortButton.Text:SetPoint("CENTER")
		SortButton.Text:SetText("JPack")
		SortButton.ClearAllPoints = function() return end
		]]
		
		
		Sort:SetSize(75, 23)
		Sort:ClearAllPoints()
		Sort:SetPoint("BOTTOMRIGHT", Container, "BOTTOMRIGHT", -10, 7)
		Sort:SetFrameLevel(Container:GetFrameLevel() + 1)
		Sort:SetFrameStrata(Container:GetFrameStrata())
		StripTextures(Sort)
		SkinButton(Sort)
		Sort:SetScript("OnClick", SortBags)
		
--		Sort:SetScript('OnMouseDown', function(self, button) 
--		if InCombatLockdown() then return end
--		if button == "RightButton" then JPack:Pack(nil, 1) else JPack:Pack(nil, 2) end
--		end)
		FontString(Sort,"Text", STANDARD_TEXT_FONT, 15,"THINOUTLINE")
		Sort.Text:SetPoint("CENTER")
		Sort.Text:SetText(BAG_FILTER_CLEANUP)
		Sort.ClearAllPoints = function() return end
--		Sort.SetPoint = function() return end

		ToggleBagsContainer:SetHeight(BagItemSearchBox:GetHeight())
		ToggleBagsContainer:SetWidth(20)
		ToggleBagsContainer:SetPoint("TOPRIGHT", Container, "TOPRIGHT", -12, -6)
		ToggleBagsContainer:SetParent(Container)
		ToggleBagsContainer:EnableMouse(true)
		SkinButton(ToggleBagsContainer)
		ToggleBagsContainer.Text = ToggleBagsContainer:CreateFontString("button")
		ToggleBagsContainer.Text:SetPoint("CENTER", ToggleBagsContainer, "CENTER",0,1)
		ToggleBagsContainer.Text:SetFont(STANDARD_TEXT_FONT, 15)
		ToggleBagsContainer.Text:SetText("B")
		ToggleBagsContainer.Text:SetTextColor(.4, .4, .4)
		ToggleBagsContainer:SetScript("OnMouseUp", function(self, button)
			local Purchase = BankFramePurchaseInfo
			if (button == "LeftButton") then
				local BanksContainer = _G["DuffedUI_Bank"].BagsContainer
				local Purchase = BankFramePurchaseInfo
				local ReagentButton = _G["DuffedUI_Bank"].ReagentButton
				if (ReplaceBags == 0) then
					ReplaceBags = 1
					BagsContainer:Show()
					BanksContainer:Show()
					BanksContainer:ClearAllPoints()
					ToggleBagsContainer.Text:SetTextColor(1, 1, 1)
					BanksContainer:SetPoint("BOTTOM", _G["DuffedUI_Bank"], "TOP", 0, 2)
				else
					ReplaceBags = 0
					BagsContainer:Hide()
					BanksContainer:Hide()
					ToggleBagsContainer.Text:SetTextColor(.4, .4, .4)
				end
			else
				if BankFrame:IsShown() then
					CloseBankFrame()
				else
					ToggleAllBags()
				end
			end
		end)

		for _, Button in pairs(BlizzardBags) do
			local Icon = _G[Button:GetName() .. "IconTexture"]

			Button:SetParent(BagsContainer)
			Button:ClearAllPoints()
			Button:SetWidth(ButtonSetSize)
			Button:SetHeight(ButtonSetSize)
			Button:SetFrameStrata("HIGH")
			Button:SetFrameLevel(2)
			Button:SetNormalTexture("")
			Button:SetPushedTexture("")
			Button:SetCheckedTexture("")
			SetTemplate(Button)
			Button.IconBorder:SetAlpha(0)
--			SkinButton(Button)
			if LastButtonBag then Button:SetPoint("LEFT", LastButtonBag, "RIGHT", 4, 0) else Button:SetPoint("TOPLEFT", BagsContainer, "TOPLEFT", 4, -4) end

			Icon:SetTexCoord(.08, .92, .08, .92)
			SetInside(Icon)
			LastButtonBag = Button
			BagsContainer:SetWidth((ButtonSetSize * getn(BlizzardBags)) + (ButtonSpacing * (getn(BlizzardBags) + 1)))
			BagsContainer:SetHeight(ButtonSetSize + (ButtonSpacing * 2))
		end
		
		Container.BagsContainer = BagsContainer
		Container.CloseButton = ToggleBagsContainer
		Container.SortButton = Sort
	else
	Container:SetWidth(((ButtonSetSize + ButtonSpacing) * BankItemsPerRow) + 22 - ButtonSpacing)
		local PurchaseButton = BankFramePurchaseButton
		local CostText = BankFrameSlotCost
		local TotalCost = BankFrameDetailMoneyFrame
		local Purchase = BankFramePurchaseInfo
		local BankBagsContainer = CreateFrame("Frame", nil, Container)
		local Sort = BankItemAutoSortButton

		CostText:ClearAllPoints()
		CostText:SetPoint("BOTTOMLEFT", 60, 10)
		TotalCost:ClearAllPoints()
		TotalCost:SetPoint("LEFT", CostText, "RIGHT", 0, 0)
		PurchaseButton:ClearAllPoints()
		PurchaseButton:SetPoint("BOTTOMRIGHT", -10, 10)
		SkinButton(PurchaseButton)
--		BankItemAutoSortButton:Hide()

		Sort:SetSize(75, 23)
		Sort:ClearAllPoints()
		Sort:SetPoint("BOTTOMRIGHT", Container, "BOTTOMRIGHT", -10, 7)
		Sort:SetFrameLevel(Container:GetFrameLevel() + 1)
		Sort:SetFrameStrata(Container:GetFrameStrata())
		StripTextures(Sort)
		SkinButton(Sort)
		Sort:SetScript("OnClick", function() if ReagentBankFrame:IsShown() then SortReagentBankBags() else SortBankBags() end end)
--		Sort:SetScript('OnMouseDown', function(self, button) 
--		if InCombatLockdown() then return end
--		if button == "RightButton" then JPack:Pack(nil, 1) else JPack:Pack(nil, 2) end
--		end)
		FontString(Sort,"Text", STANDARD_TEXT_FONT, 15,"THINOUTLINE")
		Sort.Text:SetPoint("CENTER")
		Sort.Text:SetText(BAG_FILTER_CLEANUP)
		Sort.ClearAllPoints = function() return end
		

		local SwitchReagentButton = CreateFrame("Button", nil, Container)
		SwitchReagentButton:SetSize(75, 23)
		SkinButton(SwitchReagentButton)
		SwitchReagentButton:SetPoint("BOTTOMLEFT", Container, "BOTTOMLEFT", 10, 7)
		FontString(SwitchReagentButton,"Text", STANDARD_TEXT_FONT, 15,"THINOUTLINE")
		SwitchReagentButton.Text:SetPoint("CENTER")
		SwitchReagentButton.Text:SetText(REAGENT_BANK)
		SwitchReagentButton:SetScript("OnClick", function()
			BankFrame_ShowPanel(BANK_PANELS[2].name)
			if (not ReagentBankFrame.isMade) then
				CreateReagentContainer()
				ReagentBankFrame.isMade = true
			else
				_G["DuffedUI_Reagent"]:Show()
			end
			for i = 5, 11 do CloseBag(i) end
		end)

		Purchase:ClearAllPoints()
		Purchase:SetWidth(Container:GetWidth() + 50)
		Purchase:SetHeight(70)
		Purchase:SetPoint("BOTTOMLEFT", SwitchReagentButton, "TOPLEFT", 0, -100)

		BankBagsContainer:SetSize(Container:GetWidth(), BankSlotsFrame.Bag1:GetHeight() + ButtonSpacing + ButtonSpacing)
		SetTemplate(BankBagsContainer)
		BankBagsContainer:SetPoint("BOTTOMLEFT", SwitchReagentButton, "TOPLEFT", 0, 2)
		BankBagsContainer:SetFrameLevel(Container:GetFrameLevel())
		BankBagsContainer:SetFrameStrata(Container:GetFrameStrata())

		for i = 1, 7 do
			local Bag = BankSlotsFrame["Bag" .. i]
			Bag:SetParent(BankBagsContainer)
			Bag:SetWidth(ButtonSetSize)
			Bag:SetHeight(ButtonSetSize)
			Bag.IconBorder:SetAlpha(0)
			Bag.icon:SetTexCoord(.08, .92, .08, .92)
			SetInside(Bag.icon)
--			SkinButton(Bag)
			Bag:ClearAllPoints()
			if i == 1 then Bag:SetPoint("TOPLEFT", BankBagsContainer, "TOPLEFT", ButtonSpacing, -ButtonSpacing) else Bag:SetPoint("LEFT", BankSlotsFrame["Bag" .. i-1], "RIGHT", ButtonSpacing, 0) end
		end

		BankBagsContainer:SetWidth((ButtonSetSize * 7) + (ButtonSpacing * (7 + 1)))
		BankBagsContainer:SetHeight(ButtonSetSize + (ButtonSpacing * 2))
		BankBagsContainer:Hide()

		BankFrame:EnableMouse(false)

		_G["DuffedUI_Bank"].BagsContainer = BankBagsContainer
		_G["DuffedUI_Bank"].ReagentButton = SwitchReagentButton
		Container.SortButton = SortButton
	end
end

function SetBagsSearchPosition()
	local BagItemSearchBox = BagItemSearchBox
	local BankItemSearchBox = BankItemSearchBox

	BagItemSearchBox:SetParent(_G["DuffedUI_Bag"])
	BagItemSearchBox:SetFrameLevel(_G["DuffedUI_Bag"]:GetFrameLevel() + 2)
	BagItemSearchBox:SetFrameStrata(_G["DuffedUI_Bag"]:GetFrameStrata())
	BagItemSearchBox:ClearAllPoints()
	BagItemSearchBox:SetPoint("TOPRIGHT", _G["DuffedUI_Bag"], "TOPRIGHT", -40, -6)
	StripTextures(BagItemSearchBox)
	SetTemplate(BagItemSearchBox)
	BagItemSearchBox:SetBackdropColor(0, 0, 0,0)
	BagItemSearchBox.SetParent = function() return end
	BagItemSearchBox.ClearAllPoints = function() return end
	BagItemSearchBox.SetPoint = function() return end
	BankItemSearchBox:Hide()
end

function T(t1,t2)
if t1 ==nil  or t2 ==nil then
return ""
elseif L[t1] and L[t2] then
return L[t1].."   "..L[t2]
elseif L[t1] then
return _G[t2]
elseif L[t2] then
return L[t2]
else 
return _G[t2]
end 
end

function Text(Button)
Button.t=Button:CreateFontString(nil,"OVERLAY")
Button.t:SetFont(STANDARD_TEXT_FONT,12,"OUTLINE")
Button.t:SetPoint("TOPRIGHT",2,0)
Button.t:SetText()
Button.t1=Button:CreateFontString(nil,"OVERLAY")
Button.t1:SetFont(STANDARD_TEXT_FONT,10,"OUTLINE")
Button.t1:SetPoint("BOTTOMRIGHT",2,-2)
Button.t1:SetText()
end

local Texts={}

local i,k=1,1
--[[
local levelAdjust={ 
["0"]=0,["1"]=8,["373"]=4,["374"]=8,["375"]=4,["376"]=4, 
["377"]=4,["379"]=4,["380"]=4,["445"]=0,["446"]=4,["447"]=8, 
["451"]=0,["452"]=8,["453"]=0,["454"]=4,["455"]=8,["456"]=0, 
["457"]=8,["458"]=0,["459"]=4,["460"]=8,["461"]=12,["462"]=16, 
["465"]=0,["466"]=4,["467"]=8,["468"]=0,["469"]=4,["470"]=8, 
["471"]=12,["472"]=16,["476"]=0,["477"]=4,["478"]=8,["479"]=0, 
["480"]=8,["491"]=0,["492"]=4,["493"]=8,["494"]=0,["495"]=4, 
["496"]=8,["497"]=12,["498"]=16,["501"]=0,["502"]=4, 
["503"]=8,["504"]=12,["505"]=16,["506"]=20,["507"]=24}

local heirloomLevels={10,10,10,10,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,79,82,85, 88,91,93,96,99,102,105,139,143,147,151,155,159,163,167,171,175,179,183,187, 279,293,306,320,333,347,404,424,443,463,530,540,550,560,570,580,590,595,600,605}

local timewalk={598,605,660}
]]

local Lv80_BOA = { 
	[42943] = 1, [42944] = 1, [42945] = 1, [42946] = 1,
	[42947] = 1, [42948] = 1, [42949] = 1, [42950] = 1,
	[42951] = 1, [42952] = 1, [42984] = 1, [42985] = 1,
	[42991] = 1, [42992] = 1, [44091] = 1, [44092] = 1,
	[44093] = 1, [44094] = 1, [44095] = 1, [44096] = 1,
	[44097] = 1, [44098] = 1, [44099] = 1, [44100] = 1,
	[44101] = 1, [44102] = 1, [44103] = 1, [44105] = 1,
	[44107] = 1, [48677] = 1, [48683] = 1, [48685] = 1,
	[48687] = 1, [48689] = 1, [48691] = 1, [48716] = 1,
	[48718] = 1, [50255] = 1, [69889] = 1, [69890] = 1, 
	[69893] = 1, [79131] = 1, [92948] = 1,
}

local Lv85_BOA = {
	[61931] = 1, [61935] = 1, [61936] = 1, [61937] = 1,
	[61942] = 1, [61958] = 1, [62023] = 1, [62024] = 1,
	[62025] = 1, [62026] = 1, [62027] = 1, [62029] = 1,
	[62038] = 1, [62039] = 1, [62040] = 1, [69887] = 1,
	[69888] = 1, [69892] = 1, [93841] = 1, [93843] = 1,
	[93844] = 1, [93845] = 1, [93846] = 1, [93847] = 1,
	[93848] = 1, [93848] = 1, [93850] = 1, [93851] = 1,
	[93852] = 1, [93853] = 1, [93855] = 1, [93856] = 1,
	[93857] = 1, [93858] = 1, [93859] = 1, [93860] = 1,
	[93861] = 1, [93862] = 1, [93863] = 1, [93864] = 1,
	[93865] = 1, [93866] = 1, [93867] = 1, [93876] = 1,
	[93885] = 1, [38886] = 1, [38887] = 1, [38888] = 1,
	[93889] = 1, [93890] = 1, [93891] = 1, [93892] = 1,
	[93893] = 1, [93894] = 1, [93895] = 1, [93896] = 1,
	[93897] = 1, [93898] = 1, [93899] = 1, [93900] = 1,
	[93902] = 1, [93903] = 1, [93904] = 1,
}

local Lv100_BOA = {
	[126948] = 1, [126949] = 1, [128318] = 1,
}

local Lv110_BOA = {
	[133595] = 1, [133596] = 1, [133597] = 1, [133598] = 1,
	[133585] = 1, 
}


--- BOA Item Level ---
local function BOALevel(ilvl, ulvl, id, upgrade)
	local level
	if ilvl == 1 then
		if Lv110_BOA[id] then
			return 815 - (110 - ulvl) * 10
		elseif Lv100_BOA[id] then
			if ulvl > 100 then ulvl = 100 end
		elseif Lv85_BOA[id] then
			if ulvl > 85 then ulvl = 85 end
		elseif Lv80_BOA[id] then
			if ulvl > 80 then ulvl = 80 end
		elseif ulvl > 60 and upgrade ~= 583 and upgrade ~= 582 then
			ulvl = 60
		elseif ulvl > 90 and upgrade ~= 583 then
			ulvl = 90
		elseif ulvl > 100 then
			ulvl = 100
		end
		if ulvl > 97 then
			level = 605 - (100 - ulvl) * 5
		elseif ulvl > 90 then
			level = 590 - (97 - ulvl) * 10
		elseif ulvl > 85 then
			level = 463 - (90 - ulvl) * 19.75
		elseif ulvl > 80 then
			level = 333 - (85 - ulvl) * 13.5
		elseif ulvl > 67 then
			level = 187 - (80 - ulvl) * 4
		elseif ulvl > 57 then
			level = 105 - (67 - ulvl) * 26 / 9
		elseif ulvl > 10 then
			level = ulvl + 5
		else
			level = 10
		end
	else
		if ulvl > 100 then
			ulvl = 100
		end
		if ilvl == 582 or ilvl == 569 or ilvl == 556 then
			level = ilvl + (620 - ilvl) / 10 * (ulvl - 90)
		else
			level = ilvl
		end
	end
	return floor(level + 0.5)
end

--- Scan Item Level ---
local function GetItemLevel(itemLink)
	if not lvlPattern then
		lvlPattern = gsub(ITEM_LEVEL, "%%d", "(%%d+)")
	end

	if not ScanTip then
		ScanTip = CreateFrame("GameTooltip","ScanTip",nil,"GameTooltipTemplate")
		ScanTip:SetOwner(UIParent,"ANCHOR_NONE")
	end
	ScanTip:ClearLines()
	ScanTip:SetHyperlink(itemLink)

	for i = 2, min(5, ScanTip:NumLines()) do
		local line = _G["ScanTipTextLeft"..i]:GetText()
		local itemLevel = strmatch(line, lvlPattern)
		if itemLevel then
			return tonumber(itemLevel)
		end
	end
end

function SlotUpdate(id, Button)
	local ItemLink = GetContainerItemLink(id, Button:GetID())
	local _, _, Lock = GetContainerItemInfo(id, Button:GetID())
	local IsQuestItem = GetContainerItemQuestInfo(id, Button:GetID())
--	local IsNewItem = C_NewItems.IsNewItem(id, Button:GetID())
--	local IsBattlePayItem = IsBattlePayItem(id, Button:GetID())
--	local NewItem = Button.NewItemTexture
--[[
	if IsNewItem then
		NewItem:SetAlpha(0)
		if not Button.Animation then
			Button.Animation = Button:CreateAnimationGroup()
			Button.Animation:SetLooping("BOUNCE")
			Button.FadeOut = Button.Animation:CreateAnimation("Alpha")
			Button.FadeOut:SetChange(1)
			Button.FadeOut:SetDuration(1)
			Button.FadeOut:SetSmoothing("IN_OUT")
		end
		Button.Animation:Play()
	else
		if Button.Animation and Button.Animation:IsPlaying() then Button.Animation:Stop() end
	end
]]
	
	
	if Button:GetID() ~= 0 then
	if Texts[id..Button:GetID()] ==nil then
	Text(Button)
	Texts[id..Button:GetID()] = 1
	else 
	Button.t:SetText()
	Button.t1:SetText()
	end
    if IsQuestItem then
	Button:SetBackdropBorderColor(1, 1, 0)
	elseif ItemLink then
	    local _, _, Rarity, lvl, reqLvl, Type,t1,_,t2 = GetItemInfo(ItemLink)
	    if not Lock and Rarity and Rarity>1 then
			local bonus = select(15, strsplit(":", ItemLink))
			local id = strmatch(ItemLink, "item:(%d+)")
			local ulvl = UnitLevel("player")
			bonus = tonumber(bonus) or 0
			id = tonumber(id) or 0

			if (Rarity) or (lvl) then
				if Rarity == 7 then
					level = BOALevel(lvl, ulvl, id, bonus)
				else
					level = GetItemLevel(ItemLink)
				end
			end	
			Button.t:SetText(level)  
			Button.t:SetTextColor(GetItemQualityColor(Rarity))
			Button.t1:SetText()
			if Type == ARMOR then 
			Button.t:SetText(level) 
			Button.t:SetTextColor(GetItemQualityColor(Rarity))
			    if (GetLocale() == "zhCN" or GetLocale() == "zhTW" ) then 
				Button.t1:SetText(T(t1,t2)) 
				else  
				Button.t1:SetText(_G[t2]) 
				end
			Button.t1:SetTextColor(GetItemQualityColor(Rarity))
			elseif Type == WEAPON then 
			Button.t:SetText(level)  
			Button.t:SetTextColor(GetItemQualityColor(Rarity))	
			Button.t1:SetText(t1)
			Button.t1:SetTextColor(GetItemQualityColor(Rarity))
			elseif level and level > 200 then
		Button.t:SetText(level)  Button.t:SetTextColor(GetItemQualityColor(Rarity))
			else
			Button.t:SetText()
			Button.t1:SetText()
			end
			Button:SetBackdropBorderColor(GetItemQualityColor(Rarity))
		else
		Button.t:SetText()
		Button.t1:SetText()
		Button:SetBackdropBorderColor(0, 0, 0,.9)
		end
	else
	Button.t:SetText()
	Button.t1:SetText()
	Button:SetBackdropColor(0, 0, 0,0)
	Button:SetBackdropBorderColor(0, 0, 0,.9)
	end
	end
end

function BagUpdate(id)
	local SetSize = GetContainerNumSlots(id)
	for Slot = 1, SetSize do
		local Button = _G["ContainerFrame" .. (id + 1) .. "Item" .. Slot]
		SlotUpdate(id, Button)
	end
end

function UpdateAllBags()
	local NumRows, LastRowButton, NumButtons, LastButton = 0, ContainerFrame1Item1, 1, ContainerFrame1Item1
	for Bag = 1, 5 do
		local ID = Bag - 1
		local Slots = GetContainerNumSlots(ID)
		for Item = 1,Slots do
			local Button = _G["ContainerFrame"  ..  Bag  ..  "Item"  ..  Item]
			local Money = ContainerFrame1MoneyFrame

			Button:ClearAllPoints()
			Button:SetSize(ButtonSetSize, ButtonSetSize)
			Button:SetScale(1)
			Button:SetFrameStrata("HIGH")
			Button:SetFrameLevel(2)

--			Button.newitemglowAnim:Stop()
--			Button.newitemglowAnim.Play = function() return end
--			Button.flashAnim:Stop()
--			Button.flashAnim.Play = function() return end

			Money:ClearAllPoints()
			Money:Show()
			Money:SetPoint("BOTTOMLEFT",DuffedUI_Bag,"BOTTOMLEFT", 25, 7)
			Money:SetFrameStrata("HIGH")
			Money:SetFrameLevel(2)
			Money:SetScale(1)
			if (Bag == 1 and Item == 1) then
				Button:SetPoint("TOPLEFT", _G["DuffedUI_Bag"], "TOPLEFT", 10, -25)
				LastRowButton = Button
				LastButton = Button
			elseif (NumButtons == BagItemsPerRow) then
				Button:SetPoint("TOPRIGHT", LastRowButton, "TOPRIGHT", 0, -(ButtonSpacing + ButtonSetSize))
				Button:SetPoint("BOTTOMLEFT", LastRowButton, "BOTTOMLEFT", 0, -(ButtonSpacing + ButtonSetSize))
				LastRowButton = Button
				NumRows = NumRows + 1
				NumButtons = 1
			else
				Button:SetPoint("TOPRIGHT", LastButton, "TOPRIGHT", (ButtonSpacing + ButtonSetSize), 0)
				Button:SetPoint("BOTTOMLEFT", LastButton, "BOTTOMLEFT", (ButtonSpacing + ButtonSetSize), 0)
				NumButtons = NumButtons + 1
			end
			SkinBagButton(Button)
			LastButton = Button
		end
		BagUpdate(ID)
	end
	_G["DuffedUI_Bag"]:SetHeight(((ButtonSetSize + ButtonSpacing) * (NumRows + 1) + 77) - ButtonSpacing)
end

function UpdateAllBankBags()
	local NumRows, LastRowButton, NumButtons, LastButton = 0, ContainerFrame1Item1, 1, ContainerFrame1Item1

	for Bag = 12, 6,-1 do
		local ID = Bag - 1
		local Slots = GetContainerNumSlots(ID)
		for Item = 1, Slots do
			local Button = _G["ContainerFrame"  ..  Bag  ..  "Item" .. Item]
			Button:ClearAllPoints()
			Button:SetWidth(ButtonSetSize, ButtonSetSize)
			Button:SetFrameStrata("HIGH")
			Button:SetFrameLevel(2)
			Button.IconBorder:SetAlpha(0)
			
			if i==2 then Text(Button) end
			
			if (Bag == 12 and Item == 1) then
				Button:SetPoint("TOPLEFT", _G["DuffedUI_Bank"], "TOPLEFT", 10, -10)
				LastRowButton = Button
				LastButton = Button
			elseif (NumButtons == BankItemsPerRow) then
				Button:SetPoint("TOPRIGHT", LastRowButton, "TOPRIGHT", 0, -(ButtonSpacing + ButtonSetSize))
				Button:SetPoint("BOTTOMLEFT", LastRowButton, "BOTTOMLEFT", 0, -(ButtonSpacing + ButtonSetSize))
				LastRowButton = Button
				NumRows = NumRows + 1
				NumButtons = 1
			else
				Button:SetPoint("TOPRIGHT", LastButton, "TOPRIGHT", (ButtonSpacing+ButtonSetSize), 0)
				Button:SetPoint("BOTTOMLEFT", LastButton, "BOTTOMLEFT", (ButtonSpacing+ButtonSetSize), 0)
				NumButtons = NumButtons + 1
			end
			SkinBagButton(Button)
			LastButton = Button
		end
		BagUpdate(ID)
	end
	
	for Bank = 1, 28 do
		local Button = _G["BankFrameItem" .. Bank]
		Button:ClearAllPoints()
		Button:SetSize(ButtonSetSize, ButtonSetSize)
		Button:SetFrameStrata("HIGH")
		Button:SetFrameLevel(2)
		Button.IconBorder:SetAlpha(0)

		BankFrameMoneyFrame:Hide()
		
		if (NumButtons == BankItemsPerRow) then
			Button:SetPoint("TOPRIGHT", LastRowButton, "TOPRIGHT", 0, -(ButtonSpacing + ButtonSetSize))
			Button:SetPoint("BOTTOMLEFT", LastRowButton, "BOTTOMLEFT", 0, -(ButtonSpacing + ButtonSetSize))
			LastRowButton = Button
			NumRows = NumRows + 1
			NumButtons = 1
		else
			Button:SetPoint("TOPRIGHT", LastButton, "TOPRIGHT", (ButtonSpacing + ButtonSetSize), 0)
			Button:SetPoint("BOTTOMLEFT", LastButton, "BOTTOMLEFT", (ButtonSpacing + ButtonSetSize), 0)
			NumButtons = NumButtons + 1
		end
		SkinBagButton(Button)
		SlotUpdate(-1, Button)
		LastButton = Button
	end
	
	_G["DuffedUI_Bank"]:SetHeight(((ButtonSetSize + ButtonSpacing) * (NumRows + 1) + 50) - ButtonSpacing)
end

ContainerFrame1Item1:SetScript("OnHide", function()
	_G["DuffedUI_Bag"]:Hide()
	if _G["DuffedUI_Reagent"] and _G["DuffedUI_Reagent"]:IsShown() then
		_G["DuffedUI_Reagent"]:Hide()
	end
end)

BankFrameItem1:SetScript("OnHide", function() _G["DuffedUI_Bank"]:Hide() end)
BankFrameItem1:SetScript("OnShow", function() _G["DuffedUI_Bank"]:Show() end)

CreateContainer("Bag", "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 200) 
CreateContainer("Bank", "BOTTOMRIGHT", DuffedUI_Bag, "BOTTOMLEFT", 0, 0)

HideBlizzard()
SetBagsSearchPosition()


function OpenBag(id, IsBank)
	if (not CanOpenPanels()) then
		if (UnitIsDead("player")) then NotWhileDeadError() end
		return
	end

	local SetSize = GetContainerNumSlots(id)
	local OpenFrame = ContainerFrame_GetOpenFrame()

	if OpenFrame.size and OpenFrame.size ~= SetSize then
		for i = 1, OpenFrame.size do
			local Button = _G[OpenFrame:GetName() .. "Item" .. i]
			Button:Hide()
		end
	end

	for i = 1, SetSize, 1 do
		local Index = SetSize - i + 1
		local Button = _G[OpenFrame:GetName() .. "Item" .. i]
		Button:SetID(Index)
		Button:Show()
	end
	OpenFrame.size = SetSize
	OpenFrame:SetID(id)
	OpenFrame:Show()

	if (id == 4 ) then UpdateAllBags()   elseif (id == 11) then UpdateAllBankBags()  end
end

function UpdateContainerFrameAnchors() end
function ToggleBag() ToggleAllBags() end
function ToggleBackpack() ToggleAllBags() end
function OpenAllBags() ToggleAllBags() end
function OpenBackpack() ToggleAllBags() end
function ToggleAllBags()
	if ContainerFrame1:IsShown() then
		if not BankFrame:IsShown() then
			_G["DuffedUI_Bag"]:Hide()
			CloseBag(0)
			for i = 1, 4 do CloseBag(i) end
		end
	elseif not GameMenuFrame:IsShown() then
		_G["DuffedUI_Bag"]:Show()
		OpenBag(0, 1)
		for i = 1, 4 do OpenBag(i, 1) end
	end

	if BankFrame:IsShown() and not ReagentBankFrame:IsShown() then
		_G["DuffedUI_Bank"]:Show()
		if i < 3 then i=i+1 end
		for i = 5, 11 do
			if not IsBagOpen(i) then OpenBag(i, 1) end
		end
	else
		_G["DuffedUI_Bank"]:Hide()
		for i = 5, 11 do CloseBag(i) end
	end
end

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("BAG_UPDATE")
EventFrame:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
EventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "BAG_UPDATE" then
		BagUpdate(...)
	elseif event == "PLAYERBANKSLOTS_CHANGED" then
		local ID = ...
		if ID <= 28 then
			local Button = _G["BankFrameItem" .. ID]
			SlotUpdate(-1, Button)
		else
			CloseBankFrame()
		end
	end
end)

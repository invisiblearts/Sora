--[[
	Operating under the following assumptions about how recipes are discovered:
	1) You must know the base rank of a recipe to receive higher ranked versions of it
	2) You must already know all recipes which are reagents for the recipe (unconfirmed)
--]]

local HookedButtons = {} -- [button] = true
local Undiscoverable = { -- List of rank 1 recipes that can't be obtained from nomi
	-- [recipeID] = recipeName,
	-- Quests
	[201513] = 'Dropped by |Hunit:Creature-0-0-0-0-93371-0|h[Mordvigbjorn]|h (Stormheim 72.6, 50.0)', -- Bear Tartare
	[201496] = 'Quest: |cffffff00|Hquest:39117|h[Shriek No More]|h|r, |Hunit:Creature-0-0-0-0-94117-0|h[Cecily Radcliffe]|h (Val\'sharah 36.0, 57.0)', -- Deep-Fried Mossgill
	[201512] = 'Quest: |cffffff00|Hquest:40988|h[Too Many Cooks]|h|r, |Hunit:Creature-0-0-0-0-101846-0|h[Nomi]|h (Dalaran)', -- Dried Mackerel Strips
	[201498] = 'Quest: |cffffff00|Hquest:37727|h[The Magister of Mixology]|h|r, |Hunit:Creature-0-0-0-0-89341-0|h[Magister Garuhod]|h (47.0, 41.4)', -- Faronaar Fizz
	[201514] = 'Quest: |cffffff00|Hquest:37536|h[Morale Booster]|h|r, |Hunit:Creature-0-0-0-0-88923-0|h[Sternfathom]|h (48.0, 48.6)', -- Fighter Chow
	[201497] = 'Quest: |cffffff00|Hquest:40078|h[A Heavy Burden]|h|r, |Hunit:Creature-0-0-0-0-92539-0|h[Havi]|h (Stormheim 60.2, 50.8)', -- Pickled Stormray
	[201413] = 'Quest: |cffffff00|Hquest:39867|h[I\'m Not Lion!]|h|r, |Hunit:Creature-0-0-0-0-95438-0|h[Ellias]|h (Highmountain 40.0, 52.2)', -- Salt and Pepper Shank
	[201499] = 'Quest chain: |cffffff00|Hquest:39789|h[Eating Into Our Business]|h|r, |Hunit:Creature-0-0-0-0-97258-0|h[Ootasa Galehoof]|h (Stormheim 51.2, 57.0)', -- Spiced Rib Roast
	[201503] = 'Sold by |Hunit:Creature-0-0-0-0-112226-0|h[Markus Hjolbruk]|h (Suramar 71.6, 48.8)', -- Koi-Scented Stormray
	
	-- Other stuff
	[201501] = '|cff1eff00|Hitem:141011|h[Surf]|h|r dropped by |Hunit:Creature-0-0-0-0-99720-0|h[Coastal Spikeback]|h (Suramar 76,50) |cff1eff00|Hitem:141012|h[Turf]|h|r dropped by |Hunit:Creature-0-0-0-0-110042-0|h[Heartwood Stag]|h (Suramar 65,45)', -- Suramar Surf and Turf
	[201502] = 'Quest: |cffffff00|Hquest:40102|h[Murlocs: The Next Generation]|h|r, |Hunit:Creature-0-0-0-0-98067-0|h[King Mrgl-Mrgl]|h (Highmountain 42.6, 10.8)', -- 'Barracuda Mrglgagh',
	[201500] = 'Dropped by |Hunit:Creature-0-0-0-0-110340-0|h[Myonix]|h (Suramar 40.8, 32.8)', -- Leybeque Ribs
	[201504] = 'Dropped (rarely) by Drogbar (Highmountain 53.3, 62.4)', -- Drogbar-Style Salmon
}

local Requisites = { -- List of recipes you must (probably) already know in order to discover a recipe from nomi
	-- While technically you need to know the previous rank of a spell to receive the next one,
	-- we'll use the base rank as the requirement for all ranks because it's more intuitive
	-- I only want to grey-out recipes that we can't learn because we don't know the base rank
	-- I only want to grey-out recipes that we can't learn because we don't know the base rank
	[201506] = {201501}, -- Azshari Salad: Suramar Surf and Turf
	[201508] = {201503}, -- Seed-Battered Fish Plate: Kio-Scented Stormray
	[201507] = {201502}, -- Nightborne Delicacy Platter: Barracuda Mrglgagh
	[201505] = {201500}, -- The Hungry Magister: Leybeque Ribs
	[201511] = {201504}, -- Fishbrul Special: Drogbar-Style Salmon
	
	[201515] = {201413, 201496, 201497, 201498, 201499}, -- Hearty Feast
	[201542] = {201515}, -- Hearty Feast
	[201562] = {201515}, -- Hearty Feast
	[201516] = {201500, 201501, 201502, 201503, 201504}, -- Lavish Suramar Feast
	[201543] = {201516}, -- Lavish Suramar Feast
	[201563] = {201516}, -- Lavish Suramar Feast
	
	[201538] = {201511}, -- Fishbrul Special
	[201558] = {201511}, -- Fishbrul Special
	[201534] = {201505}, -- The Hungry Magister
	[201554] = {201505}, -- The Hungry Magister
	[201535] = {201506}, -- Azshari Salad
	[201555] = {201506}, -- Azshari Salad
	[201536] = {201507}, -- Nightborne Delicacy Platter
	[201556] = {201507}, -- Nightborne Delicacy Platter
	[201537] = {201508}, -- Seed-Battered Fish Plate
	[201557] = {201508}, -- Seed-Battered Fish Plate
	
	[201531] = {201502}, -- Barracuda Mrglgagh
	[201551] = {201502}, -- Barracuda Mrglgagh
	[201533] = {201504}, -- Drogbar-Style Salmon
	[201553] = {201504}, -- Drogbar-Style Salmon
	[201539] = {201512}, -- Dried Mackerel Strips
	[201559] = {201512}, -- Dried Mackerel Strips
	[201541] = {201514}, -- Fighter Chow
	[201561] = {201514}, -- Fighter Chow
	[201530] = {201501}, -- Suramar Surf and Turf
	[201550] = {201501}, -- Suramar Surf and Turf
	[201524] = {201413}, -- Salt and Pepper Shank
	[201544] = {201413}, -- Salt and Pepper Shank
	[201526] = {201497}, -- Pickled Stormray
	[201546] = {201497}, -- Pickled Stormray
	[201532] = {201503}, -- Koi-Scented Stormray
	[201552] = {201503}, -- Koi-Scented Stormray
	[201528] = {201499}, -- Spiced Rib Roast
	[201548] = {201499}, -- Spiced Rib Roast
	[201525] = {201496}, -- Deep-Fried Mossgill
	[201545] = {201496}, -- Deep-Fried Mossgill
	[201540] = {201513}, -- Bear Tartare
	[201560] = {201513}, -- Bear Tartare
	[201529] = {201500}, -- Leybeque Ribs
	[201549] = {201500}, -- Leybeque Ribs
	[201527] = {201498}, -- Faronaar Fizz
	[201547] = {201498}, -- Faronaar Fizz
}

local IngredientList = { -- In the order they appear in Nomi's dialog options
	[124117] = {201506,201555,201544,201516,201563,201550,201524,201543,201530,201535}, -- Lean Shank
	[124121] = {201536,201547,201562,201507,201515,201527,201542,201556}, -- Wildfowl Egg
	[124119] = {201562,201549,201542,201529,201516,201548,201505,201528,201554,201534,201543,201515,201563}, -- Big Gamy Ribs
	[124118] = {201560,201554,201534,201505,201540}, -- Fatty Bearsteak
	[124120] = {201534,201551,201536,201529,201531,201563,201505,201507,201554,201556,201543,201549,201516}, -- Leyblood
	[124107] = {201511,201561,201541,201558,201538}, -- Cursed Queenfish
	[124108] = {201525,201545,201562,201542,201515,201558,201538,201511}, -- Mossgill Perch
	[124109] = {201534,201538,201516,201533,201505,201558,201554,201511,201543,201553,201563}, -- Highmountain Salmon
	[124110] = {201532,201508,201542,201537,201516,201563,201557,201552,201546,201526,201543,201515,201562}, -- Stormray
	[124111] = {201532,201506,201508,201555,201557,201516,201563,201550,201552,201537,201543,201530,201535}, -- Runescale Koi
	[124112] = {201551,201538,201531,201563,201558,201507,201536,201556,201543,201511,201516}, -- Black Barracuda
	[133680] = {201562,201684,201542,201516,201683,201685,201543,201515,201563}, -- Slabs of Bacon
	[133607] = {201539,201557,201537,201559,201508}, -- Silver Mackerel
}

local IngredientOrder = {
	124117, -- Lean Shank
	124121, -- Wildfowl Egg
	124119, -- Big Gamy Ribs
	124118, -- Fatty Bearsteak
	124120, -- Leyblood
	124107, -- Cursed Queenfish
	124108, -- Mossgill Perch
	124109, -- Highmountain Salmon
	124110, -- Stormray
	124111, -- Runescale Koi
	124112, -- Black Barracuda
	133680, -- Slabs of Bacon
	133607, -- Silver Mackerel
}

local LocalizedIngredientList = {} -- [itemID] = {itemName, itemLink}
local TooltipInfo = {} -- [button] = {[i] = 'recipe name?'}

local function GetRank(info)
	return not info.nextRecipeID and 3 or info.previousRecipeID and 2 or 1
end

local RecipeCache = {} -- [recipeID] = info

local f = CreateFrame('frame')

local RegisteredFrames = {} -- Holds a list of frames that should be registered for TRADE_SKILL_SHOW after our addon is finished
local Callback
local function RequestCookingStuff(callback)
	Callback = callback
	if C_TradeSkillUI.GetTradeSkillLine() ~= 185 then
		RegisteredFrames = {GetFramesRegisteredForEvent('TRADE_SKILL_SHOW')}
		for _, frame in pairs(RegisteredFrames) do
			frame:UnregisterEvent('TRADE_SKILL_SHOW')
		end
		f:RegisterEvent('TRADE_SKILL_SHOW')
		-- There seems to be no other way to prevent the tradeskill ui from opening when we call this function,
		-- so we have to make SURE that the event always get re-registered or we'll break the other tradeskills
		local opened = C_TradeSkillUI.OpenTradeSkill(185)
		if not opened then
			f:UnregisterEvent('TRADE_SKILL_SHOW')
			for _, frame in pairs(RegisteredFrames) do
				frame:RegisterEvent('TRADE_SKILL_SHOW')
			end
		end
	else
		f:GetScript('OnEvent')(f, 'TRADE_SKILL_LIST_UPDATE')
	end
end

-- Cache relevent recipe info for lookups
local function CacheRecipes()
	wipe(RecipeCache)
	for ingredientItemID, recipes in pairs(IngredientList) do
		for _, recipeID in pairs(recipes) do
			RecipeCache[recipeID] = C_TradeSkillUI.GetRecipeInfo(recipeID)
		end
	end
	for _, recipes in pairs(Requisites) do
		for _, recipeID in pairs(recipes) do
			RecipeCache[recipeID] = C_TradeSkillUI.GetRecipeInfo(recipeID)
		end
	end
end

local IsNomi = false -- Are we currently interacting with Nomi?
local function DecorateNomi()
	wipe(TooltipInfo)
	local i = 0
	for j = 1, #IngredientOrder do
		local ingredientItemID = IngredientOrder[j]
		local count = GetItemCount(ingredientItemID, true) or 0
		local _, _, _, _, ingredientIcon = GetItemInfoInstant(ingredientItemID)
		if count >= 5 then -- we have enough of an ingredient for nomi to display it
			i = i + 1
			local buttonName = 'GossipTitleButton' .. i
			local button = _G[buttonName]
			local buttonIcon = _G[buttonName .. 'GossipIcon'] -- check that the icon is for a work order, otherwise we might overwrite a quest button or something
			if button and button:IsShown() and buttonIcon and buttonIcon:GetTexture():lower() == 'interface\\gossipframe\\workordergossipicon' then
				if not HookedButtons[button] then
					button:HookScript('OnEnter', function(self)
						if not IsNomi then return end
						if TooltipInfo[self] and #TooltipInfo[self] > 0 then
							GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
							GameTooltip:AddLine('Potential Recipes')
							table.sort(TooltipInfo[self])
							for _, name in pairs(TooltipInfo[self]) do
								GameTooltip:AddLine(name)
							end
							GameTooltip:Show()
						end
					end)
					button:HookScript('OnLeave', function(self)
						GameTooltip_Hide()
					end)
					HookedButtons[button] = i
				end
				
				local ingredient, recipeList = LocalizedIngredientList[ingredientItemID], IngredientList[ingredientItemID]
				if ingredient and recipeList then -- and recipes then
					local unlearned = 0
					local canLearn = 0
					local ingredientName, ingredientLink = ingredient[1], ingredient[2]
					for _, recipeID in pairs(recipeList) do
						local info = RecipeCache[recipeID]
						if info and not info.learned then
							unlearned = unlearned + 1
							local learnable = true
							if Requisites[recipeID] then
								for _, requisiteID in pairs(Requisites[recipeID]) do
									-- we must know all requisites to be able to receive this item
									local requisiteInfo = RecipeCache[requisiteID] -- C_TradeSkillUI.GetRecipeInfo(requisiteID)
									if requisiteInfo and not requisiteInfo.learned then
										-- we're missing one of the requisites, can't make this
										learnable = false
										if not TooltipInfo[button] then
											TooltipInfo[button] = {}
										end
										local rank = GetRank(info)
										local name = format('|T%d:16|t |cffcccccc%s %d', info.icon, info.name, rank)
										tinsert(TooltipInfo[button], name)
										break
									end
								end
							end
							if learnable then
								canLearn = canLearn + 1
								if not TooltipInfo[button] then
									TooltipInfo[button] = {}
								end
								local rank = GetRank(info)
								local name = format('|T%d:16|t %s %d', info.icon, info.name, rank)
								tinsert(TooltipInfo[button], name)
							end
						end
					end
					--buttonIcon:SetTexture(ingredientIcon)
					if unlearned ~= 0 then
						if canLearn ~= 0 then
							button:SetFormattedText('|T%d:16|t %d [%s] x%d', ingredientIcon, canLearn, ingredientName, count)
						else
							-- button:SetText('|cff660000' .. canLearn .. ' [' .. ingredientName .. ']')
							button:SetFormattedText('|T%d:16|t |cff660000%d [%s] x%d|r', ingredientIcon, canLearn, ingredientName, count)
						end
					else
						button:SetFormattedText('|cff660000No more |T%d:16|t [%s]', ingredientIcon, ingredientName)
					end
					GossipResize(button)
				end
			else
				break
			end
		end
	end
end

f:SetScript('OnEvent', function(self, event, ...)
	if event == 'GOSSIP_SHOW' then
		local guid = UnitGUID('npc')
		if guid then
			local _, _, _, _, _, npcID = strsplit('-', guid)
			if npcID == '101846' then -- Nomi
				IsNomi = true
				RequestCookingStuff(DecorateNomi)
			end
		end
	elseif event == 'GOSSIP_CLOSED' then
		IsNomi = false
	elseif event == 'TRADE_SKILL_SHOW' then
		self:UnregisterEvent('TRADE_SKILL_SHOW')
		self:RegisterEvent('TRADE_SKILL_LIST_UPDATE')
		for _, frame in pairs(RegisteredFrames) do
			frame:RegisterEvent('TRADE_SKILL_SHOW')
		end
	elseif event == 'TRADE_SKILL_LIST_UPDATE' then
		self:UnregisterEvent('TRADE_SKILL_LIST_UPDATE')
		if Callback then
			CacheRecipes()
			Callback()
		end
		C_TradeSkillUI.CloseTradeSkill()
	elseif event == 'GET_ITEM_INFO_RECEIVED' then
		local itemID = ...
		if IngredientList[itemID] then
			local itemName, itemLink = GetItemInfo(itemID)
			LocalizedIngredientList[itemID] = {itemName, itemLink}
		end
	elseif event == 'PLAYER_LOGIN' then
		for itemID, recipes in pairs(IngredientList) do
			local itemName, itemLink = GetItemInfo(itemID)
			if itemName and itemLink then
				LocalizedIngredientList[itemID] = {itemName, itemLink}
			end
		end
	end
end)
f:RegisterEvent('GOSSIP_SHOW')
f:RegisterEvent('GOSSIP_CLOSED')
f:RegisterEvent('GET_ITEM_INFO_RECEIVED')
f:RegisterEvent('PLAYER_LOGIN')

local function OutputRecipes()
	local results = {}
	local unavailable = {}
	for j = 1, #IngredientOrder do
		local ingredientItemID = IngredientOrder[j]
		local ingredient, recipeList = LocalizedIngredientList[ingredientItemID], IngredientList[ingredientItemID]
		if ingredient and recipeList then
			local unlearned = 0
			local canLearn = 0
			local ingredientName, ingredientLink = ingredient[1], ingredient[2]
			for _, recipeID in pairs(recipeList) do
				local info = RecipeCache[recipeID]
				if info and not info.learned then
					unlearned = unlearned + 1
					local learnable = true
					if Requisites[recipeID] then
						-- todo: figure out why this isn't ignoring multiple ranks when we don't know its prerequisite
						for _, requisiteID in pairs(Requisites[recipeID]) do
							-- we must know all requisites to be able to receive this item
							local requisiteInfo = RecipeCache[requisiteID] --C_TradeSkillUI.GetRecipeInfo(requisiteID)
							if requisiteInfo and not requisiteInfo.learned then
								-- we're missing one of the requisites, can't make this
								learnable = false
								--break
								if not info.previousRecipeID then -- this is a rank 1 recipe and we can't learn it, so there is some other requirement
									if not unavailable[recipeID] then
										unavailable[recipeID] = {}
									end
									unavailable[recipeID][requisiteID] = true
								end
							end
						end
					end
					if learnable then
						if not results[ingredientLink] then
							results[ingredientLink] = {}
						end
						--if not info.previousRecipeID or not results[ingredientLink][info.previousRecipeID] then
							results[ingredientLink][recipeID] = true
						--end
						--tinsert(results[ingredientLink], recipeID)
					end
				end
			end
		end
	end
	
	for ingredientLink, recipes in pairs(results) do
		print('|cff66ff66Available|r ' .. ingredientLink .. ' |cff66ff66recipes:|r')
		--table.sort(recipes)
		for recipeID in pairs(recipes) do
			local prevRecipe = RecipeCache[recipeID].previousRecipeID
			if not prevRecipe or not recipes[prevRecipe] then -- skip higher ranks of the same item
				local recipeLink = GetSpellLink(recipeID)
				print(' |cff66ff66-|r ' .. recipeLink)
			end
		end
	end
	
	for recipeID, requisites in pairs(unavailable) do
		print('|cffffff66Missing|r ' .. GetSpellLink(recipeID) .. ' |cffffff66requisites:|r')
		for requisite in pairs(requisites) do
			--local prevRecipe = RecipeCache[recipeID].previousRecipeID
			--if not prevRecipe or not recipes[prevRecipe] then -- skip higher ranks of the same item
				local recipeLink = GetSpellLink(requisite)
				print(' |cffffff66-|r ' .. recipeLink)
			--end
		end
	end
	
	print('|cffffff66Missing recipes obtained from sources other than Nomi:|r')
	local i = 1
	for recipeID, description in pairs(Undiscoverable) do
		local info = RecipeCache[recipeID]
		if info and not info.learned then
			print(format('%d) %s %s', i, GetSpellLink(recipeID) or ('Recipe ' .. recipeID), description or '???'))
			i = i + 1
		end
	end
end

SLASH_NOMICAKES1, SLASH_NOMICAKES2 = '/nomicakes', '/nomi'

function SlashCmdList.NOMICAKES()
	RequestCookingStuff(OutputRecipes)
end
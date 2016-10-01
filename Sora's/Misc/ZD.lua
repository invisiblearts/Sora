--Inspect iLevels
local F = CreateFrame('Frame')
local slot = {'Head', 'Neck', 'Shoulder', 'Shirt', 'Chest', 'Waist', 'Legs', 'Feet', 'Wrist', 'Hands', 'Finger0', 'Finger1', 'Trinket0', 'Trinket1', 'Back', 'MainHand', 'SecondaryHand', 'Tabard'}

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
        ScanTip = CreateFrame("GameTooltip", "ScanTip", nil, "GameTooltipTemplate")
        ScanTip:SetOwner(UIParent, "ANCHOR_NONE")
    end
    ScanTip:ClearLines()
    ScanTip:SetHyperlink(itemLink)
    
    for i = 2, min(5, ScanTip:NumLines()) do
        local line = _G["ScanTipTextLeft" .. i]:GetText()
        local itemLevel = strmatch(line, lvlPattern)
        if itemLevel then
            return tonumber(itemLevel)
        end
    end
end

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

local bonus ={
["40"]="闪",["41"]="吸",["42"]="速",["43"]="磨",["499"]="火",["523"]="槽",["560"]="火",["561"]="火",["562"]="火",["563"]="槽",["564"]="槽",["565"]="槽",
}
local bonus1 ={
["566"]="英雄",["30"]="燎火",["567"]="史诗",["74"]="狂野 暴击溅射",["85"]="狂野 暴击溅射",["489"]="残酷 全溅射",["163"]="曙光 急速全能",["215"]="谐律 全能精通", --525 530 里面有一个督军监制
}
]]
local function CreateIlvText(slotName)
    local f = _G[slotName]
    f.ilv = f:CreateFontString(nil, 'OVERLAY')
    f.ilv:SetPoint('TOPRIGHT', f, 'TOPRIGHT', 2, 1)
    f.ilv:SetFont(STANDARD_TEXT_FONT, 12, 'THINOUTLINE')
    f.ilv1 = f:CreateFontString(nil, 'OVERLAY')
    f.ilv1:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 3, 0)
    f.ilv1:SetFont(STANDARD_TEXT_FONT, 12, 'THINOUTLINE')
--f.ilv:SetTextColor(0,1,0.6,1)
end
--[[
local function GetShuxing(link)
local geshu = select(1,strsplit(":", select(14,strsplit(":", string.match(link, "item[%-?%d:]+")))))
--local geshu = select(1,strsplit(":", select(14,strsplit(":", string.match(GetInventoryItemLink("player", 1), "item[%-?%d:]+")))))
local bo,bos=0,""
if tonumber(geshu) > 0 then
for i = 1 , geshu do
--			bo =select(1,strsplit(":", select(14+i,strsplit(":", string.match(link, "item[%-?%d:]+")))))
if bonus[bo] then bos=format("%s%s%s", bos,"  ",bonus[bo]) end
end
end
return format("%s",bos)
end
]]
local function CheckItem(unit, frame)
    if unit then
        for k, v in pairs(slot) do
            local f = _G[frame .. v .. 'Slot']
            local itemTexture = GetInventoryItemTexture(unit, k)
            
            if itemTexture then
                local itemLink = GetInventoryItemLink(unit, k)
                
                if (itemLink) then
                    local _, _, quality, lvl, _, _, _, _, slot = GetItemInfo(itemLink)
                    local bonus = select(15, strsplit(":", itemLink))
                    local id = strmatch(itemLink, "item:(%d+)")
                    local ulvl = UnitLevel("player")
                    bonus = tonumber(bonus) or 0
                    id = tonumber(id) or 0
                    
                    if (quality) or (lvl) then
                        if quality == 7 then
                            level = BOALevel(lvl, ulvl, id, bonus)
                        else
                            level = GetItemLevel(itemLink)
                        end
                        f.ilv:SetText(level)
                        f.ilv:SetTextColor(GetItemQualityColor(quality))
                        f.ilv1:SetTextColor(GetItemQualityColor(quality))
                    --				   f.ilv1:SetText(GetShuxing(ItemLink))
                    end
                end
            else
                f.ilv:SetText()
                f.ilv1:SetText()
            end
        --[[local ItemLink = GetInventoryItemLink(unit, k)
        if  ItemLink then
        local Name, _, Rarity, level, reqLvl, Type,t1,_,t2 = GetItemInfo(ItemLink)
        local arr={strsplit(":", string.match(ItemLink, "item[%-?%d:]+"))}
        local lvl = UnitLevel("player")
        --print(unpack(arr))
        if arr[1]=="102249"then print(unpack(arr))end
        level = level + (levelAdjust[arr[15]]
        --[[ or 0)
        f.ilv:SetText(level)
        f.ilv:SetTextColor(GetItemQualityColor(Rarity))
        f.ilv1:SetTextColor(GetItemQualityColor(Rarity))
        --				   f.ilv1:SetText(GetShuxing(ItemLink))
        else
        f.ilv:SetText()
        f.ilv1:SetText()
        end
        ]]
        end
    end
end

for _, v in pairs(slot) do CreateIlvText('Character' .. v .. 'Slot') end

CharacterFrame:HookScript('OnShow', function(self)
    CheckItem('player', 'Character')
    self:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
end)

CharacterFrame:HookScript('OnHide', function(self)
    self:UnregisterEvent('PLAYER_EQUIPMENT_CHANGED')
end)

CharacterFrame:HookScript('OnEvent', function(self, event)
    if event ~= 'PLAYER_EQUIPMENT_CHANGED' then return end
    CheckItem('player', 'Character')
end)


F:RegisterEvent('ADDON_LOADED')
F:SetScript('OnEvent', function(self, event, addon)
    if addon == 'Blizzard_InspectUI' then
        for k, v in pairs(slot) do CreateIlvText('Inspect' .. v .. 'Slot') end
        CheckItem(_G['InspectFrame'].unit, 'Inspect')
        _G['InspectFrame']:HookScript('OnShow', function()
            CheckItem(_G['InspectFrame'].unit, 'Inspect')
            self:RegisterEvent('INSPECT_READY')
            self:RegisterEvent('UNIT_MODEL_CHANGED')
            self:RegisterEvent('PLAYER_TARGET_CHANGED')
            self:SetScript('OnEvent', function()CheckItem(_G['InspectFrame'].unit, 'Inspect') end)
        end)
        _G['InspectFrame']:HookScript('OnHide', function()
            self:UnregisterEvent('PLAYER_TARGET_CHANGED')
            self:UnregisterEvent('UNIT_MODEL_CHANGED')
            self:UnregisterEvent('INSPECT_READY')
            self:SetScript('OnEvent', nil)
        end)
        self:UnregisterEvent('ADDON_LOADED')
        self:SetScript('OnEvent', nil)
    end
end)

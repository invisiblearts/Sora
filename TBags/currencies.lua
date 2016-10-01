--货币显示currencis display
--可以使用下列数据自己排序1-N 推荐 N<=6   use the number to order 1-N  suggest N<=6
Currency = {
--1
1220,--职业大厅资源
--2
1268,--上古神器
--3
1273,--破碎命运印记
--4
1191,--勇气点数
--5
1166,--时空扭曲徽章
--6
1275,--古怪硬币
--7
1155,--远古魔力
--8
1149, --盲目之眼
--9
1154,--考古 暗影币
--10
1171,--神器知识


980, --Dingy Iron Coins肮脏的铁币
738, --Lesser Charm of Good Fortune
944, --Artifact Fragment神器碎片
810, --Black Iron Fragment黑铁碎片
776, --Warforged Seal战火铸币
789, --Bloody Coin染血的铸币
241, --Champion's Seal冠军的印记
402, --Ironpaw Token铁掌印记
416, --Mark of the World Tree世界之树的印记
777, --Timeless Coin永恒铸币
391, --Tol Barad Commendation托尔巴拉德奖章
515, --Darkmoon Prize Ticket暗月票
390, --Conquest Points征服
994, --Seal of Tempered Fate钢化命运印记
392, --Honor Points荣誉
1129, --seal of inevitable fate 既定命运之币
--10
823, --Apexis Crystal埃匹希斯水晶
1226,--虚空碎片
--9
1101, --oil 原油
--7
824, --Garrison Resources要塞资源
}
--[[
for i = 1000 , 2000 do
if  GetCurrencyInfo(i)~= "" then 
print (i)
print (GetCurrencyInfo(i))
end
end
]]
local N = 10 --显示的货币数量 the amount of currencies to display
local Frame={}
local Text={}


for i =1,N/2 do 
function Icon(f)
      f:SetBackdrop({
            bgFile = select(3,GetCurrencyInfo(Currency[i])),
			edgeFile = 'Interface\\Buttons\\WHITE8x8', edgeSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0}
      })
      f:SetBackdropColor(1, 1, 1, 1)
      f:SetBackdropBorderColor(0, 0, 0, 1)
end
Frame[i] = CreateFrame("frame", nil, DuffedUI_Bag)
Icon(Frame[i])
Frame[i]:SetWidth(14)
Frame[i]:SetHeight(14)
local hintFunc = function(frame)
	GameTooltip:SetOwner(frame, "ANCHOR_TOP")
	GameTooltip:AddLine(GetCurrencyInfo(Currency[i]),1, 1, 1)
	GameTooltip:Show()
end
Frame[i]:SetScript("OnEnter", hintFunc)
if i == 1 then
Frame[i]:SetPoint("BOTTOMRIGHT",DuffedUI_Bag,"BOTTOMLEFT", 28, 22)
else
Frame[i]:SetPoint("BOTTOMLEFT",Text[i-1],"BOTTOMRIGHT" ,10, 0)
end
Text[i] = DuffedUI_Bag:CreateFontString(nil,"OVERLAY","NumberFontNormalSmall");
Text[i]:SetPoint("BOTTOMLEFT",Frame[i],"BOTTOMRIGHT" ,10, 0);
Text[i]:SetTextColor(1,1,1,1);
Text[i]:SetFont(STANDARD_TEXT_FONT, 14, "THINOUTLINE")
end

for i = N/2+1,N do 
function Icon(f)
      f:SetBackdrop({
            bgFile = select(3,GetCurrencyInfo(Currency[i])),
			edgeFile = 'Interface\\Buttons\\WHITE8x8', edgeSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0}
      })
      f:SetBackdropColor(1, 1, 1, 1)
      f:SetBackdropBorderColor(0, 0, 0, 1)
end
Frame[i] = CreateFrame("frame", nil, DuffedUI_Bag)
Icon(Frame[i])
Frame[i]:SetWidth(14)
Frame[i]:SetHeight(14)

local hintFunc = function(frame)
	GameTooltip:SetOwner(frame, "ANCHOR_TOP")
	GameTooltip:AddLine(GetCurrencyInfo(Currency[i]),1, 1, 1)
	GameTooltip:Show()
end
Frame[i]:SetScript("OnEnter", hintFunc)
if i == N/2+1 then
Frame[i]:SetPoint("BOTTOMRIGHT",DuffedUI_Bag,"BOTTOMLEFT", 28, 37)
else
Frame[i]:SetPoint("BOTTOMLEFT",Text[i-1],"BOTTOMRIGHT" ,10, 0)
end
Text[i] = DuffedUI_Bag:CreateFontString(nil,"OVERLAY","NumberFontNormalSmall");
Text[i]:SetPoint("BOTTOMLEFT",Frame[i],"BOTTOMRIGHT" ,10, 0);
Text[i]:SetTextColor(1,1,1,1);
Text[i]:SetFont(STANDARD_TEXT_FONT, 14, "THINOUTLINE")
end

Atext = DuffedUI_Bag:CreateFontString(nil,"OVERLAY");
Atext:SetPoint("TOPLEFT",DuffedUI_Bag,"TOPLEFT" ,10,-5 );
Atext:SetFont(STANDARD_TEXT_FONT, 14, "THINOUTLINE")

local LoadedFrame = CreateFrame("FRAME", "LoadedFrame");
LoadedFrame:RegisterEvent("ADDON_LOADED");
LoadedFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE");
LoadedFrame:RegisterEvent("ARTIFACT_XP_UPDATE");
LoadedFrame:RegisterEvent("UNIT_INVENTORY_CHANGED");
LoadedFrame:SetScript("OnEvent", function()
for i =1,N do 
Text[i]:SetText(select(2,GetCurrencyInfo(Currency[i])))
end
local show = HasArtifactEquipped() and not UnitHasVehicleUI("player")
	if (show) then
		local _, _, name, _, totalPower, traitsLearned = C_ArtifactUI.GetEquippedArtifactInfo()
		local numTraitsLearnable, power, powerForNextTrait = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(traitsLearned, totalPower);
Atext:SetText(name.." lv"..traitsLearned.." 神器能量"..totalPower.."("..power.."/"..powerForNextTrait..")")
	else
Atext:SetText()
	end
end)
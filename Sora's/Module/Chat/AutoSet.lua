-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local function OnPlayerLogin(self, event, unit, ...)
	FCF_SetLocked(ChatFrame1, nil)
	FCF_SetChatWindowFontSize(self, ChatFrame1, 12) 

	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetSize(450, 145)
	ChatFrame1:SetUserPlaced(true)
	ChatFrame1:SetPoint("BOTTOMLEFT", 28, 28)

	for i = 1, NUM_CHAT_WINDOWS do
		FCF_SetWindowAlpha(_G["ChatFrame"..i], 0)
	end

	FCF_SavePositionAndDimensions(ChatFrame1)
	FCF_SetLocked(ChatFrame1, 1)
end

local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, unit, ...)
	if event == "PLAYER_LOGIN" then
		OnPlayerLogin(self, event, unit, ...)
	end
end)


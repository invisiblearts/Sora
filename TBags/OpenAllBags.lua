
-- Copyright (c) 2009-2014, Sven Kirmess
local function EventHandler(self, event, ...)

	 if ( event == "PLAYER_ENTERING_WORLD" ) then
		self:RegisterEvent("AUCTION_HOUSE_CLOSED")
		self:RegisterEvent("AUCTION_HOUSE_SHOW")
		self:RegisterEvent("BANKFRAME_CLOSED")
		self:RegisterEvent("BANKFRAME_OPENED")
		self:RegisterEvent("FORGE_MASTER_CLOSED")
		self:RegisterEvent("FORGE_MASTER_OPENED")
		self:RegisterEvent("GUILDBANKFRAME_CLOSED")
		self:RegisterEvent("GUILDBANKFRAME_OPENED")
		self:RegisterEvent("MAIL_CLOSED")
		self:RegisterEvent("MAIL_SHOW")
		self:RegisterEvent("MERCHANT_CLOSED")
		self:RegisterEvent("MERCHANT_SHOW")
		self:RegisterEvent("TRADE_CLOSED")
		self:RegisterEvent("TRADE_SHOW")
		self:RegisterEvent("VOID_STORAGE_CLOSE")
		self:RegisterEvent("VOID_STORAGE_OPEN")
	elseif ( event == "PLAYER_LEAVING_WORLD" ) then
		self:UnregisterEvent("AUCTION_HOUSE_CLOSED")
		self:UnregisterEvent("AUCTION_HOUSE_SHOW")
		self:UnregisterEvent("BANKFRAME_CLOSED")
		self:UnregisterEvent("BANKFRAME_OPENED")
		self:UnregisterEvent("FORGE_MASTER_CLOSED")
		self:UnregisterEvent("FORGE_MASTER_OPENED")
		self:UnregisterEvent("GUILDBANKFRAME_CLOSED")
		self:UnregisterEvent("GUILDBANKFRAME_OPENED")
		self:UnregisterEvent("MAIL_CLOSED")
		self:UnregisterEvent("MAIL_SHOW")
		self:UnregisterEvent("MERCHANT_CLOSED")
		self:UnregisterEvent("MERCHANT_SHOW")
		self:UnregisterEvent("TRADE_CLOSED")
		self:UnregisterEvent("TRADE_SHOW")
		self:UnregisterEvent("VOID_STORAGE_CLOSE")
		self:UnregisterEvent("VOID_STORAGE_OPEN")
	elseif (
		event == "AUCTION_HOUSE_SHOW" or
		event == "BANKFRAME_OPENED" or
		event == "FORGE_MASTER_OPENED" or
		event == "GUILDBANKFRAME_OPENED" or
		event == "MAIL_SHOW" or
		event == "MERCHANT_SHOW" or
		event == "TRADE_SHOW" or
		event == "VOID_STORAGE_OPEN"
	) then
		CloseAllBags()
		OpenAllBags()
--[[
		if (event == "BANKFRAME_OPENED")
		then
			local numSlots, full
			local i

			numSlots, full = GetNumBankSlots();
			for i = 0, numSlots do
				OpenBag(NUM_BAG_SLOTS + 1 + i)
			end
		end]]--
	elseif (
		event == "AUCTION_HOUSE_CLOSED" or
		event == "BANKFRAME_CLOSED" or
		event == "FORGE_MASTER_CLOSED" or
		event == "GUILDBANKFRAME_CLOSED" or
		event == "MAIL_CLOSED" or
		event == "MERCHANT_CLOSED" or
		event == "TRADE_CLOSE" or
		event == "VOID_STORAGE_CLOSE"
	) then
		local i
		for i = 0, NUM_BAG_SLOTS do
			CloseBag(i)
		end
        end
end

-- main
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_LEAVING_WORLD")
frame:SetScript("OnEvent", EventHandler)


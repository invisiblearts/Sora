-- Engine
local S, _, _, DB = unpack(select(2, ...))

-- Begin
local function CretaeChatbar()
	local Channel = {"/s ","/y ","/p ","/g ","/raid ","/1 ","/2 "}
	local Color = {
		{255/255, 255/255, 255/255}, 
		{255/255,  64/255,  64/255}, 
		{170/255, 170/255, 255/255}, 
		{ 64/255, 255/255,  64/255}, 
		{255/255, 127/255,   0/255}, 
		{210/255, 180/255, 140/255}, 
		{160/255, 120/255,  90/255}, 
		{255/255, 255/255,   0/255}, 
	}
	
	local PreButton = nil

	local parentFrame = CreateFrame("Frame", nil, UIParent)
	parentFrame:SetPoint("TOPLEFT", ChatFrame1, "TOPRIGHT", 0, 0)
	parentFrame:SetPoint("BOTTOMRIGHT", ChatFrame1EditBox, "BOTTOMRIGHT", 0, 0)

	parentFrame:SetSize(parentFrame:GetHeight()/8, parentFrame:GetHeight())
	parentFrame:ClearAllPoints()
	parentFrame:SetPoint("TOPRIGHT", ChatFrame1, "TOPLEFT", -4, 0)

	for i = 1, 8 do
		local Button = nil

		if i <= 7 then
			Button = CreateFrame("Button", nil, parentFrame)
			Button:SetScript("OnClick", function()
				ChatFrame_OpenChat(Channel[i], chatFrame)
			end)
		else
			Button = CreateFrame("Button", nil, parentFrame, "SecureActionButtonTemplate")
			Button:SetAttribute("*type*", "macro")
			Button:SetAttribute("macrotext", "/roll")
		end
		
		Button:SetAlpha(0.5)
		Button:SetSize(parentFrame:GetWidth(), parentFrame:GetWidth())

		Button:SetBackdrop({ 
			bgFile = DB.Statusbar, edgeFile = DB.GlowTex,
			insets = {left = 3, right = 3, top = 3, bottom = 3}, edgeSize = 3, 
		})
		Button:SetBackdropColor(unpack(Color[i]))
		Button:SetBackdropBorderColor(0, 0, 0, 1)

		if i == 1 then
			Button:SetPoint("TOP", parentFrame, "TOP", 0, 0)
		else
			Button:SetPoint("TOP", PreButton, "BOTTOM", 0, 0)
		end
		
		PreButton = Button;
	end
end

local function OnPlayerLogin(self, event, ...)
	CretaeChatbar()
end

local Handler = CreateFrame("Frame", nil, UIParent)
Handler:RegisterEvent("PLAYER_LOGIN")
Handler:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		OnPlayerLogin(self, event, ...)
	end
end)
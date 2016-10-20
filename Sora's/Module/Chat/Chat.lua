-- Engines
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local function kill(frame)
	if frame.UnregisterAllEvents then
		frame:UnregisterAllEvents()
	end

	frame.Show = function() end
	frame:Hide()
end

local function SetOption()
	-- 可选聊天字体大小
	CHAT_FONT_HEIGHTS = {10, 11, 12, 13, 14, 15, 16, 17, 18}

	-- 打开输入框回到上次对话
	ChatTypeInfo["SAY"].sticky        = 1 -- 说
	ChatTypeInfo["PARTY"].sticky 	  = 1 -- 小队
	ChatTypeInfo["GUILD"].sticky 	  = 1 -- 公会
	ChatTypeInfo["WHISPER"].sticky 	  = 0 -- 密语
	ChatTypeInfo["BN_WHISPER"].sticky = 0 -- 实名密语
	ChatTypeInfo["RAID"].sticky 	  = 1 -- 团队
	ChatTypeInfo["OFFICER"].sticky    = 1 -- 官员
	ChatTypeInfo["CHANNEL"].sticky 	  = 0 -- 频道
end

local function SetChatFrame()
	-- print(S.Dump(_G["ChatFrame1"]))

	for i = 1, NUM_CHAT_WINDOWS do
		local ChatFrame = _G["ChatFrame"..i]
		
		-- 间距
		ChatFrame:SetSpacing(2)

		-- 渐隐
		ChatFrame:SetFading(false)

		-- 干掉聊天框体材质
		for j = 1, #CHAT_FRAME_TEXTURES do
			_G["ChatFrame"..i..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
		end

		-- 干掉聊天框体缩放限制
		ChatFrame:SetMinResize(0, 0)
		ChatFrame:SetMaxResize(0, 0)
	
		-- 干掉聊天框体移动限制
		ChatFrame:SetClampedToScreen(false)
		ChatFrame:SetClampRectInsets(0, 0, 0, 0)
		
		-- 设置聊天框体标签
		_G["ChatFrame"..i.."TabText"].SetTextColor = function() end
		_G["ChatFrame"..i.."TabText"]:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
		
		-- 干掉频道标签材质
		local Tab = _G["ChatFrame"..i.."Tab"]
		Tab.leftSelectedTexture:Hide()
		Tab.middleSelectedTexture:Hide()
		Tab.rightSelectedTexture:Hide()
		Tab.leftSelectedTexture.Show = Tab.leftSelectedTexture.Hide
		Tab.middleSelectedTexture.Show = Tab.middleSelectedTexture.Hide
		Tab.rightSelectedTexture.Show = Tab.rightSelectedTexture.Hide
		kill(_G["ChatFrame"..i.."TabLeft"])
		kill(_G["ChatFrame"..i.."TabMiddle"])
		kill(_G["ChatFrame"..i.."TabRight"])
		kill(_G["ChatFrame"..i.."TabSelectedLeft"])
		kill(_G["ChatFrame"..i.."TabSelectedMiddle"])
		kill(_G["ChatFrame"..i.."TabSelectedRight"])
		kill(_G["ChatFrame"..i.."TabHighlightLeft"])
		kill(_G["ChatFrame"..i.."TabHighlightMiddle"])
		kill(_G["ChatFrame"..i.."TabHighlightRight"])
		kill(_G["ChatFrame"..i.."TabSelectedLeft"])
		kill(_G["ChatFrame"..i.."TabSelectedMiddle"])
		kill(_G["ChatFrame"..i.."TabSelectedRight"])
		kill(_G["ChatFrame"..i.."TabGlow"])
		
		-- 干掉输入框材质
		_G["ChatFrame"..i.."EditBoxMid"]:SetTexture(nil)
		_G["ChatFrame"..i.."EditBoxFocusMid"]:SetTexture(nil)
		_G["ChatFrame"..i.."EditBoxLeft"]:SetTexture(nil)
		_G["ChatFrame"..i.."EditBoxFocusLeft"]:SetTexture(nil)
		_G["ChatFrame"..i.."EditBoxRight"]:SetTexture(nil)
		_G["ChatFrame"..i.."EditBoxFocusRight"]:SetTexture(nil)
		_G["ChatFrame"..i.."EditBoxLanguage"]:ClearAllPoints()

		-- 设置输入框位置
		local EditBox = _G["ChatFrame"..i.."EditBox"]
		EditBox:ClearAllPoints()
		EditBox:EnableMouse(false)
		EditBox:SetAltArrowKeyMode(false)
		EditBox:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
		EditBox:SetPoint("TOPLEFT", ChatFrame, "BOTTOMLEFT", -8, -6)
		EditBox:SetPoint("BOTTOMRIGHT", ChatFrame, "BOTTOMRIGHT", 8, -22)

		-- 聊天框缩放按钮
		_G["ChatFrame"..i.."ResizeButton"]:SetPoint("BOTTOMRIGHT", ChatFrame, "BOTTOMRIGHT", 5, -9) 
	
		-- 移除滚动按钮
		_G["ChatFrame"..i.."ButtonFrame"]:Hide()
		_G["ChatFrame"..i.."ButtonFrame"]:SetScript("OnShow",  kill)
		_G["ChatFrame"..i.."ButtonFrameBottomButton"]:Hide()
	end

	-- 隐藏菜单按钮
	ChatFrameMenuButton:Hide()
	ChatFrameMenuButton:SetScript("OnShow", kill)

	-- 隐藏社交按钮
	FriendsMicroButton:Hide()
	FriendsMicroButton:SetScript("OnShow", kill)

	-- 设置战网消息框体
	BNToastFrame:SetClampedToScreen(true)
	BNToastFrame:SetClampRectInsets(-15, 15, 15, -15)
end

local function SetQuickScroll()
	FloatingChatFrame_OnMouseScroll = function(self, dir, ...)
		if dir > 0 then
			if IsControlKeyDown()then
				self:ScrollToTop()
			elseif IsShiftKeyDown() then
			self:ScrollUp()
			self:ScrollUp()
			self:ScrollUp()
			else
			self:ScrollUp()
			end
		else
			if IsControlKeyDown() then
				self:ScrollToBottom()
			elseif IsShiftKeyDown() then
				self:ScrollDown()
				self:ScrollDown()
				self:ScrollDown()
			else
				self:ScrollDown()
			end
		end
	end
end

local function FormatChatMessage()
	for i = 1, NUM_CHAT_WINDOWS do
		if i ~= 2 then
			local ChatFrame = _G["ChatFrame"..i]
			local OrginalAddMessage = ChatFrame.AddMessage
			ChatFrame.AddMessage = function(frame, msg, ...)
				msg = string.gsub(msg, "本地防务", "防务")
				msg = string.gsub(msg, "世界防务", "防务")
				msg = string.gsub(msg, "寻求组队", "组队")
				msg = string.gsub(msg, "大脚世界频道", "世界")
				msg = string.gsub(msg, "%[(%d%d):(%d%d):(%d%d)%]", "|HSoraCopy|h%[%1:%2%]|h")

				return OrginalAddMessage(frame, msg, ...)
			end
		end
	end
end

local function OnPlayerLogin(self, event, unit, ...)
	SetOption()
	SetChatFrame()
	SetQuickScroll()
	FormatChatMessage()
end

local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, unit, ...)
	if event == "PLAYER_LOGIN" then
		OnPlayerLogin(self, event, unit, ...)
	end
end)

SlashCmdList["ReloadUI"] = function() ReloadUI() end
SLASH_ReloadUI1 = "/rl"
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
    kill(ChatFrameMenuButton)
    kill(QuickJoinToastButton)
    
    BNToastFrame:SetClampedToScreen(true)
    BNToastFrame:SetClampRectInsets(-15, 15, 15, -15)
    
    CHAT_FONT_HEIGHTS = {10, 11, 12, 13, 14, 15, 16, 17, 18}
    
    -- ChatTypeInfo["SAY"].sticky = 1 -- 说
    -- ChatTypeInfo["PARTY"].sticky = 1 -- 小队
    -- ChatTypeInfo["GUILD"].sticky = 1 -- 公会
    -- ChatTypeInfo["WHISPER"].sticky = 0 -- 密语
    -- ChatTypeInfo["BN_WHISPER"].sticky = 0 -- 实名密语
    -- ChatTypeInfo["RAID"].sticky = 1 -- 团队
    -- ChatTypeInfo["OFFICER"].sticky = 1 -- 官员
    -- ChatTypeInfo["CHANNEL"].sticky = 0 -- 频道
end

local function SetChatFrame()
    for i = 1, NUM_CHAT_WINDOWS do
        local ChatFrame = _G["ChatFrame" .. i]
        
        ChatFrame:SetSpacing(2)
        ChatFrame:SetFading(false)
        ChatFrame:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
        
        ChatFrame:SetMinResize(0, 0)
        ChatFrame:SetMaxResize(0, 0)
        ChatFrame:SetClampedToScreen(false)
        ChatFrame:SetClampRectInsets(0, 0, 0, 0)
        
        if i ~= 2 then
            local OrginalAddMessage = ChatFrame.AddMessage
            ChatFrame.AddMessage = function(frame, msg, ...)
                msg = string.gsub(msg, "本地防务", "防务")
                msg = string.gsub(msg, "世界防务", "防务")
                msg = string.gsub(msg, "寻求组队", "组队")
                msg = string.gsub(msg, "大脚世界频道", "大脚")
                
                return OrginalAddMessage(frame, msg, ...)
            end
        end
        
        for j = 1, #CHAT_FRAME_TEXTURES do
            kill(_G["ChatFrame" .. i .. CHAT_FRAME_TEXTURES[j]])
        end
        
        kill(_G["ChatFrame" .. i .. "ButtonFrame"])
        kill(_G["ChatFrame" .. i .. "ButtonFrameBottomButton"])
        
        kill(_G["ChatFrame" .. i .. "TabLeft"])
        kill(_G["ChatFrame" .. i .. "TabRight"])
        kill(_G["ChatFrame" .. i .. "TabMiddle"])
        kill(_G["ChatFrame" .. i .. "TabSelectedLeft"])
        kill(_G["ChatFrame" .. i .. "TabSelectedRight"])
        kill(_G["ChatFrame" .. i .. "TabSelectedMiddle"])
        kill(_G["ChatFrame" .. i .. "TabHighlightLeft"])
        kill(_G["ChatFrame" .. i .. "TabHighlightRight"])
        kill(_G["ChatFrame" .. i .. "TabHighlightMiddle"])

        _G["ChatFrame" .. i .. "TabText"].SetTextColor = function() end
        _G["ChatFrame" .. i .. "TabText"]:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
        
        local EditBox = _G["ChatFrame" .. i .. "EditBox"]
        EditBox:ClearAllPoints()
        EditBox:EnableMouse(false)
        EditBox:SetAltArrowKeyMode(false)
        EditBox:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
        EditBox:SetPoint("TOPLEFT", ChatFrame, "BOTTOMLEFT", -8, -6)
        EditBox:SetPoint("BOTTOMRIGHT", ChatFrame, "BOTTOMRIGHT", 8, -22)
        
        kill(_G["ChatFrame" .. i .. "EditBoxMid"])
        kill(_G["ChatFrame" .. i .. "EditBoxLeft"])
        kill(_G["ChatFrame" .. i .. "EditBoxRight"])
        kill(_G["ChatFrame" .. i .. "EditBoxFocusMid"])
        kill(_G["ChatFrame" .. i .. "EditBoxFocusLeft"])
        kill(_G["ChatFrame" .. i .. "EditBoxFocusRight"])
        kill(_G["ChatFrame" .. i .. "EditBoxLanguage"])
    end
end

local function OnMOuseScroll(self, dir)
    if dir > 0 then
        if IsShiftKeyDown() then
            self:ScrollToTop()
        else
            self:ScrollUp()
        end
    else
        if IsShiftKeyDown() then
            self:ScrollToBottom()
        else
            self:ScrollDown()
        end
    end
end

local function SetQuickScroll()
    FloatingChatFrame_OnMouseScroll = function(self, dir, ...)
        if dir > 0 then
            if IsControlKeyDown() then
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

local function OnPlayerLogin(self, event, unit, ...)
    SetOption()
    SetChatFrame()
    SetQuickScroll()
end

-- Event
local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, unit, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, unit, ...)
    end
end)

SlashCmdList["ReloadUI"] = function()ReloadUI() end
SLASH_ReloadUI1 = "/rl"

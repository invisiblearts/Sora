﻿-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local function SetMinimap()
    Minimap:ClearAllPoints()
    Minimap:SetFrameStrata("MEDIUM")
    Minimap:SetPoint(unpack(C.MiniMap.Postion))
    Minimap:SetSize(C.MiniMap.Width, C.MiniMap.Height)
    Minimap:SetMaskTexture("Interface\\ChatFrame\\ChatFrameBackground")
    
    if not Minimap.Shadow then
        Minimap.Shadow = S.MakeShadow(Minimap, 2)
    end
end

local function SetBlzFrame()
    -- Cluster
    MinimapCluster:EnableMouse(false)
    
    -- Tracking
    MiniMapTrackingBackground:SetAlpha(0)
    MiniMapTrackingButton:SetAlpha(0)
    MiniMapTracking:ClearAllPoints()
    MiniMapTracking:SetPoint("BOTTOMLEFT", Minimap, -5, -5)
    MiniMapTracking:SetScale(1)
    
    -- Random Group icon
    QueueStatusMinimapButton:ClearAllPoints()
    QueueStatusMinimapButtonBorder:SetAlpha(0)
    QueueStatusMinimapButton:SetFrameStrata("MEDIUM")
    QueueStatusMinimapButton:SetPoint("TOP", Minimap, "TOP", 0, 6)
    
    -- Instance Difficulty flag
    MiniMapInstanceDifficulty:ClearAllPoints()
    MiniMapInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 2, 2)
    MiniMapInstanceDifficulty:SetScale(0.1)
    MiniMapInstanceDifficulty:SetAlpha(0)
    MiniMapInstanceDifficulty:SetFrameStrata("LOW")
    
    -- Guild Instance Difficulty flag
    GuildInstanceDifficulty:ClearAllPoints()
    GuildInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 2, 2)
    GuildInstanceDifficulty:SetScale(0.1)
    GuildInstanceDifficulty:SetAlpha(0)
    GuildInstanceDifficulty:SetFrameStrata("LOW")
    
    -- Mail icon
    MiniMapMailFrame:ClearAllPoints()
    MiniMapMailFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -2, 4)
    
    -- Invites Icon
    GameTimeCalendarInvitesTexture:ClearAllPoints()
    GameTimeCalendarInvitesTexture:SetParent("Minimap")
    GameTimeCalendarInvitesTexture:SetPoint("TOPRIGHT")
    
    -- Garrison
    GarrisonLandingPageMinimapButton:ClearAllPoints()
    GarrisonLandingPageMinimapButton:SetScale(0.55)
    GarrisonLandingPageMinimapButton:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 2, -4)
    
    if FeedbackUIButton then
        FeedbackUIButton:ClearAllPoints()
        FeedbackUIButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 6, -6)
        FeedbackUIButton:SetScale(0.8)
    end
    
    if StreamingIcon then
        StreamingIcon:ClearAllPoints()
        StreamingIcon:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 8, 8)
        StreamingIcon:SetScale(0.8)
    end
end

local function HideBlzFrame()
    local BlzFrame = {
        "GameTimeFrame",
        "MinimapBorderTop",
        "MinimapNorthTag",
        "MinimapBorder",
        "MinimapZoneTextButton",
        "MinimapZoomOut",
        "MinimapZoomIn",
        "MiniMapVoiceChatFrame",
        "MiniMapWorldMapButton",
        "MiniMapMailBorder",
    }
    
    for i in pairs(BlzFrame) do
        if _G[BlzFrame[i]] then
            _G[BlzFrame[i]]:Hide()
            _G[BlzFrame[i]].Show = function() end
        end
    end
end

local function SetMouseClick()
    local MenuFrame = CreateFrame("Frame", "SoraMinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
    local MenuList = {
        {text = CHARACTER_BUTTON, func = function()ToggleCharacter("PaperDollFrame") end},
        {text = SPELLBOOK_ABILITIES_BUTTON, func = function()ToggleSpellBook("spell") end},
        {text = TALENTS_BUTTON, func = function()ToggleTalentFrame() end},
        {text = ACHIEVEMENT_BUTTON, func = function()ToggleAchievementFrame() end},
        {text = QUESTLOG_BUTTON, func = function()ToggleFrame(QuestLogFrame) end},
        {text = SOCIAL_BUTTON, func = function()ToggleFriendsFrame(1) end},
        {text = GUILD, func = function()ToggleGuildFrame(1) end},
        {text = PLAYER_V_PLAYER, func = function()TogglePVPUI() end},
        {text = LFG_TITLE, func = function()ToggleFrame(PVEFrame) end},
        {text = HELP_BUTTON, func = function()ToggleHelpFrame() end},
        {text = "日历", func = function() if (not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end Calendar_Toggle() end},
        {text = PET_JOURNAL, func = function()TogglePetJournal() end},
        {text = ENCOUNTER_JOURNAL, func = function()ToggleEncounterJournal() end},
        {text = MAINMENU_BUTTON, func = function()ToggleFrame(GameMenuFrame) end},
        {text = INVTYPE_BAG, func = function()ToggleAllBags() end},
    }
    
    Minimap:SetScript("OnMouseUp", function(self, btn)
        if btn == "RightButton" then
            EasyMenu(MenuList, MenuFrame, "cursor", 0, 0, "MENU", 2)
        else
            Minimap_OnClick(self)
        end
    end)
end

local function SetMouseScroll()
    Minimap:EnableMouseWheel(true)
    Minimap:SetScript("OnMouseWheel", function(self, z)
        local c = Minimap:GetZoom()
        if z > 0 and c < 5 then
            Minimap:SetZoom(c + 1)
        elseif z < 0 and c > 0 then
            Minimap:SetZoom(c - 1)
        end
    end)
end

local function OnPlayerLogin(self, event, unit, ...)
    SetMinimap()
    SetBlzFrame()
    HideBlzFrame()
    SetMouseClick()
    SetMouseScroll()
end

local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, unit, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, unit, ...)
    end
end)

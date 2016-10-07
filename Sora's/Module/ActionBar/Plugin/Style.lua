-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local actionButtonStyle, extraActionButtonStyle = nil, nil

local function SetActionButtonStyle()
    actionButtonStyle = {}    
    
    actionButtonStyle.backdrop = {
        bgFile = "",
        title = false,
        edgeSize = 2,
        edgeFile = DB.GlowTex,
        borderColor = {0.00, 0.00, 0.00, 1.00},
        points = {
            {"TOPLEFT", -2, 2},
            {"BOTTOMRIGHT", 2, -2},
        },
    }
    
    actionButtonStyle.icon = {
        texCoord = {0.08, 0.92, 0.08, 0.92},
    }
    
    actionButtonStyle.flash = {
        file = ""
    }
    
    actionButtonStyle.flyoutBorder = {
        file = ""
    }
    
    actionButtonStyle.flyoutBorderShadow = {
        file = ""
    }
    
    actionButtonStyle.border = {
        file = ""
    }
    
    actionButtonStyle.normalTexture = {
        file = ""
    }
    
    actionButtonStyle.pushedTexture = {
        file = ""
    }
    
    actionButtonStyle.checkedTexture = {
        points = {
            {"TOPLEFT", -2, 2},
            {"BOTTOMRIGHT", 2, -2},
        },
    }
    
    actionButtonStyle.highlightTexture = {
        points = {
            {"TOPLEFT", -2, 2},
            {"BOTTOMRIGHT", 2, -2},
        },
    }
    
    actionButtonStyle.name = {
        font = {STANDARD_TEXT_FONT, 9, "THINOUTLINE"},
        points = {
            {"BOTTOM", 0, 1}
        }
    }
    
    actionButtonStyle.count = {
        font = {STANDARD_TEXT_FONT, 12, "THINOUTLINE"},
        points = {
            {"BOTTOMRIGHT", 1, 1}
        }
    }
    
    actionButtonStyle.hotkey = {
        font = {STANDARD_TEXT_FONT, 12, "THINOUTLINE"},
        points = {
            {"TOPRIGHT", 1, -1}
        }
    }
end

local function SetExtraActionButtonStyle()
    extraActionButtonStyle = {}
    
    extraActionButtonStyle.backdrop = {
        bgFile = "",
        title = false,
        edgeSize = 2,
        edgeFile = DB.GlowTex,
        borderColor = {0.00, 0.00, 0.00, 1.00},
        points = {
            {"TOPLEFT", -2, 2},
            {"BOTTOMRIGHT", 2, -2},
        },
    }
    
    extraActionButtonStyle.icon = {
        texCoord = {0.08, 0.92, 0.08, 0.92},
    }
    
    extraActionButtonStyle.buttonstyle = {
        file = ""
    }
    
    extraActionButtonStyle.normalTexture = {
        file = ""
    }
    
    extraActionButtonStyle.pushedTexture = {
        file = ""
    }
    
    extraActionButtonStyle.checkedTexture = {
        points = {
            {"TOPLEFT", -2, 2},
            {"BOTTOMRIGHT", 2, -2},
        },
    }
    
    extraActionButtonStyle.highlightTexture = {
        points = {
            {"TOPLEFT", -2, 2},
            {"BOTTOMRIGHT", 2, -2},
        },
    }
    
    extraActionButtonStyle.count = {
        font = {STANDARD_TEXT_FONT, 11, "THINOUTLINE"},
        points = {
            {"BOTTOMRIGHT", 0, 2}
        }
    }
    
    extraActionButtonStyle.hotkey = {
        font = {STANDARD_TEXT_FONT, 11, "THINOUTLINE"},
        points = {
            {"TOPRIGHT", 1, -1}
        }
    }
end

local function OnPlayerLogin(self, event, ...)
    SetActionButtonStyle()
    SetExtraActionButtonStyle()
    
    rButtonTemplate:StyleAllActionButtons(actionButtonStyle)
    rButtonTemplate:StyleExtraActionButton(actionButtonStyle)
end

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, ...)
    end
end)

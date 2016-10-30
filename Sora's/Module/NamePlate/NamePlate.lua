-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Variables
-- Begin
local function OnPlayerLogin(self, event, ...)
    self.timer = 0
    self:SetScript("OnUpdate", function(self, elapsed, ...)
        self.timer = self.timer + elapsed
        
        if self.timer > 1.00 then
            for i = 1, 40 do
                local nameplate = _G["NamePlate" .. i .. "UnitFrame"]
                
                if nameplate then
                    local _, _, nameOutline = nameplate.name:GetFont()
                    local _, _, castBatOutline = nameplate.castBar.Text:GetFont()
                    
                    if nameOutline ~= "OUTLINE" then
                        nameplate.name:SetFont(STANDARD_TEXT_FONT, 8, "OUTLINE")
                    end

                    if castBatOutline ~= "OUTLINE" then
                        nameplate.castBar.Text:SetFont(STANDARD_TEXT_FONT, 7, "OUTLINE")
                    end
                end
            end
            
            self.timer = 0
        end
    end)
end

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, ...)
    end
end)

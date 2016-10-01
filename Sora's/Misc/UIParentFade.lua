local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:SetScript("OnEvent", function(self, elasped)
	local Timer = 0
	UIParent:SetAlpha(0)
	self:SetScript("OnUpdate", function(self, elasped)
		Timer = Timer + elasped
		if Timer > 2 then
			UIFrameFadeIn(UIParent, 1, 0, 1)
			self:SetScript("OnUpdate", nil)
		end
	end)
end)
UIParent:HookScript("OnShow", function(self, elasped)
	UIFrameFadeIn(UIParent, 1, 0, 1)
end)

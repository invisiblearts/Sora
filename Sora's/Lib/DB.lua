-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Begin
local Media = "InterFace\\AddOns\\Sora's\\Media\\"
DB.Arrow = Media .. "Arrow"
DB.Solid = Media .. "Solid"
DB.ArrowT = Media .. "ArrowT"
DB.GlowTex = Media .. "GlowTex"
DB.Statusbar = Media .. "Statusbar"
DB.ThreatBar = Media .. "ThreatBar"
DB.Warning = Media .. "Warning.mp3"
DB.MyClass = select(2, UnitClass("player"))
DB.AuraFont = "Interface\\Addons\\Sora's\\Media\\ROADWAY.ttf"
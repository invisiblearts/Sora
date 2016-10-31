-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Variables
if not C.UnitFrame then
    C.UnitFrame = {}
end

C.UnitFrame.Player = {}
C.UnitFrame.Player.Width = 220
C.UnitFrame.Player.Height = 40
C.UnitFrame.Player.Postion = {"CENTER", UIParent, "CENTER", -384, -128}

C.UnitFrame.PlayerPet = {}
C.UnitFrame.PlayerPet.Width = 64
C.UnitFrame.PlayerPet.Height = 24

C.UnitFrame.Target = {}
C.UnitFrame.Target.Width = 220
C.UnitFrame.Target.Height = 40
C.UnitFrame.Target.Postion = {"CENTER", UIParent, "CENTER", 384, -128}

C.UnitFrame.TargetTarget = {}
C.UnitFrame.TargetTarget.Width = 64
C.UnitFrame.TargetTarget.Height = 24

C.UnitFrame.Focus = {}
C.UnitFrame.Focus.Width = 220
C.UnitFrame.Focus.Height = 40
C.UnitFrame.Focus.Postion = {"CENTER", UIParent, "CENTER", 0, 192}

C.UnitFrame.FocusTarget = {}
C.UnitFrame.FocusTarget.Width = 64
C.UnitFrame.FocusTarget.Height = 24

C.UnitFrame.Boss = {}
C.UnitFrame.Boss.Width = 220
C.UnitFrame.Boss.Height = 40
C.UnitFrame.Boss.Postion = {"CENTER", UIParent, "CENTER", 0, 384}

C.UnitFrame.BossTarget = {}
C.UnitFrame.BossTarget.Width = 64
C.UnitFrame.BossTarget.Height = 24

C.UnitFrame.Raid = {}
C.UnitFrame.Raid.Width = 96
C.UnitFrame.Raid.Height = 32
C.UnitFrame.Raid.Postion = {"BOTTOMRIGHT", UIParent, -8, 8}

-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Variables
if not C.UnitFrame then
    C.UnitFrame = {}
end

C.UnitFrame.Player = {}
C.UnitFrame.Player.Width = 256
C.UnitFrame.Player.Height = 48
C.UnitFrame.Player.Postion = {"CENTER", UIParent, "CENTER", -384, -128}

C.UnitFrame.PlayerPet = {}
C.UnitFrame.PlayerPet.Width = 72
C.UnitFrame.PlayerPet.Height = 28

C.UnitFrame.Target = {}
C.UnitFrame.Target.Width = 256
C.UnitFrame.Target.Height = 48
C.UnitFrame.Target.Postion = {"CENTER", UIParent, "CENTER", 384, -128}

C.UnitFrame.TargetTarget = {}
C.UnitFrame.TargetTarget.Width = 72
C.UnitFrame.TargetTarget.Height = 28

C.UnitFrame.Focus = {}
C.UnitFrame.Focus.Width = 256
C.UnitFrame.Focus.Height = 48
C.UnitFrame.Focus.Postion = {"CENTER", UIParent, "CENTER", 0, 256}

C.UnitFrame.FocusTarget = {}
C.UnitFrame.FocusTarget.Width = 72
C.UnitFrame.FocusTarget.Height = 28

C.UnitFrame.Boss = {}
C.UnitFrame.Boss.Width = 256
C.UnitFrame.Boss.Height = 48
C.UnitFrame.Boss.Postion = {"CENTER", UIParent, "CENTER", 0, 512}

C.UnitFrame.BossTarget = {}
C.UnitFrame.BossTarget.Width = 72
C.UnitFrame.BossTarget.Height = 28

C.UnitFrame.Raid = {}
C.UnitFrame.Raid.Width = 108
C.UnitFrame.Raid.Height = 36
C.UnitFrame.Raid.Postion = {"BOTTOMRIGHT", UIParent, -8, 8}

-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- 动作条模块相关设置
C.ActionBar = {}
C.ActionBar.Size = 42
C.ActionBar.Space = 8
C.ActionBar.MainBarPostion = {"BOTTOM", UIParent, 0, 8}

-- 状态模块相关设置
C.Aura = {}
C.Aura.Size = 42
C.Aura.Space = 8
C.Aura.Postion = {"TOPRIGHT", UIParent, -C.Aura.Space, -C.Aura.Space}

-- 地图模块相关设置
C.MiniMap = {}

C.MiniMap.Size = {150, 150}
C.MiniMap.Postion = {"TOPLEFT", UIParent, 8, -8}
C.MiniMap.ERBarHeight = 6

-- 信息面板相关设置
C.InfoPanel = {}
C.InfoPanel.Postion = {"TOP", UIParent, "TOP", 0, -10}

-- 单位框体相关设置
C.UnitFrame = {}

C.UnitFrame.PlayerSize = {256, 42}
C.UnitFrame.PlayerPostion = {"CENTER", UIParent, -300, -100}
C.UnitFrame.PlayerPetSize = {72, 24}

C.UnitFrame.TargetSize = {256, 42}
C.UnitFrame.TargetPostion = {"CENTER", UIParent, 300, -100}
C.UnitFrame.TargetTargetSize = {72, 24}

C.UnitFrame.FocusSize = {256, 42}
C.UnitFrame.FocusPostion = {"TOP", UIParent, 0, -128}
C.UnitFrame.FocusTargetSize = {72, 24}

-- 团队框体相关设置
C.Raid = {}
C.Raid.Size = {96, 32}
C.Raid.Postion = {"BOTTOMRIGHT", UIParent, -8, 8}

-- 仇恨监视相关设置
C.Threat = {}
C.Threat.Postion = {"CENTER", UIParent, -300, -200}
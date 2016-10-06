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
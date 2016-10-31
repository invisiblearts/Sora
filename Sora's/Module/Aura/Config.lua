-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Variables
if not C.Aura then
    C.Aura = {}
end

C.Aura = {}
C.Aura.Size = 36
C.Aura.Space = 8
C.Aura.Postion = {"TOPRIGHT", UIParent, -C.Aura.Space, -C.Aura.Space}
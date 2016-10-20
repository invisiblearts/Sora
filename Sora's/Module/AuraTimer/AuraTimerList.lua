-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Variables Initialization
local VariablesToEnsure = {C.PlayerAuraWhiteList,
                           C.PlayerAuraBlackList,
                           C.TargetAuraWhiteList,
                           C.TargetAuraBlackList}

for i = 1, #VariablesToEnsure
do
    VariablesToEnsure[i] = {}
end

-- List Definitions. Patches welcome.
-- WhiteList will override BlackList if a spellID appears in both lists.
C.PlayerAuraWhiteList = {
    -- Bloodlust, Heroism, or such stuff
    2825, -- Bloodlust
    32182, -- Heroism
    80353, -- Time Warp
    90355, -- Ancient Hysteria
    160452, -- Netherwinds
    178207, -- Drums of Fury

    -- Shadow Priests
    228264, -- Voidform
    197937, -- Lingering Insanity

    -- Emerald Nightmare Trinkets
    222046 -- Madding Whispers, buff gained from Wriggling Sinew    
}

C.TargetAuraBlackList = {
    -- Emerald Nightmare Trinkets
    221811 -- Swarming Plaguehive. This has no effect on strategy but occupies space.
}
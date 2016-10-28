-- Engine
local S, C, L, DB = unpack(select(2, ...))

-- Variables Initialization
C.PlayerAuraWhiteList = {}
C.PlayerAuraBlackList = {}
C.TargetAuraWhiteList = {}
C.TargetAuraBlackList = {}


-- List Definitions, patches welcome.
-- WhiteList will override BlackList if a spellID appears in both lists.
C.PlayerAuraWhiteList = {
    -- Bloodlust, Heroism, or such stuff 各种嗜血
    [2825] = true, -- Bloodlust 嗜血
    [32182] = true, -- Heroism 英勇
    [80353] = true, -- Time Warp 时间扭曲
    [90355] = true, -- Ancient Hysteria 远古狂乱
    [160452] = true, -- Netherwinds 虚空之风
    [178207] = true, -- Drums of Fury 狂怒战鼓

    -- Shadow Priests 暗影牧师
    [194249] = true, -- Voidform 虚空形态
    [197937] = true, -- Lingering Insanity 延宕狂乱

    -- Emerald Nightmare Trinkets 翡翠梦魇饰品
    [222046] = true -- Madding Whispers, buff gained from Wriggling Sinew 癫狂呓语，来自饰品 扭曲肌腱
}

C.PlayerAuraBlackList = {
    -- Shadow Priests 暗影牧师
    [15407] = true, -- Mind Flay 精神鞭笞
}

-- Note: Unlike PlayerAuraWhiteList which is unconditional, this requires that the aura be casted by the current player.
C.TargetAuraWhiteList = {
    -- Balance Druids 平衡德鲁伊
    [164812] = true, -- Moonfire 月火术
    [164815] = true, -- Sunfire 阳炎术
}

C.TargetAuraBlackList = {
    -- Shadow Priests 暗影牧师
    [15407] = true, -- Mind Flay 精神鞭笞
    [193473] = true, -- Mind Flay by Call to the Void 神器大特质 召唤虚空 产生虚空触须所引导的精神鞭笞
    [205065] = true, -- Void Torrent 虚空爆发

    -- Legion World Trinkets 军团再临 世界任务饰品
    [224078] = true, -- Devisaur Shock Leash 魔暴龙电击棍
    
    -- Emerald Nightmare Trinkets 翡翠梦魇饰品
    [221812] = true, -- Swarming Plaguehive. This has no effect on strategy but occupies space. 瘟疫虫群 监控这个 DoT 除了占用空间以外并没有什么意义
}
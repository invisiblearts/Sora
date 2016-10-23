-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))

-- Variables
local indicatorFilters = {
    ["DRUID"] = {
        774, 8936, 48438, 102342, -- 回春术，愈合，野性成长，铁木树皮
    }
}

local raidDebuffFilters = {
        -- [774] = 1, -- Test
        -- [15007] = 1, -- Test
        [92956] = 1, -- Wrack
        
        [39171] = 9, -- Mortal Strike
        [76622] = 9, -- Sunder Armor
        
        --Immerseus
        [143297] = 5, --Sha Splash
        [143459] = 4, --Sha Residue
        [143524] = 4, --Purified Residue
        [143286] = 4, --Seeping Sha
        [143413] = 3, --Swirl
        [143411] = 3, --Swirl
        [143436] = 2, --Corrosive Blast (tanks)
        [143579] = 3, --Sha Corruption (Heroic Only)
        
        --Fallen Protectors
        [143239] = 4, --Noxious Poison
        [144176] = 2, --Lingering Anguish
        [143023] = 3, --Corrupted Brew
        [143301] = 2, --Gouge
        [143564] = 3, --Meditative Field
        [143010] = 3, --Corruptive Kick
        [143434] = 6, --Shadow Word:Bane (Dispell)
        [143840] = 6, --Mark of Anguish
        [143959] = 4, --Defiled Ground
        [143423] = 6, --Sha Sear
        [143292] = 5, --Fixate
        [144176] = 5, --Shadow Weakness
        [147383] = 4, --Debilitation (Heroic Only)
        
        --Norushen
        [146124] = 2, --Self Doubt (tanks)
        [146324] = 4, --Jealousy
        [144639] = 6, --Corruption
        [144850] = 5, --Test of Reliance
        [145861] = 6, --Self-Absorbed (Dispell)
        [144851] = 2, --Test of Confiidence (tanks)
        [146703] = 3, --Bottomless Pit
        [144514] = 6, --Lingering Corruption
        [144849] = 4, --Test of Serenity
        
        --Sha of Pride
        [144358] = 2, --Wounded Pride (tanks)
        [144843] = 3, --Overcome
        [146594] = 4, --Gift of the Titans
        [144351] = 6, --Mark of Arrogance
        [144364] = 4, --Power of the Titans
        [146822] = 6, --Projection
        [146817] = 5, --Aura of Pride
        [144774] = 2, --Reaching Attacks (tanks)
        [144636] = 5, --Corrupted Prison
        [144574] = 6, --Corrupted Prison
        [145215] = 4, --Banishment (Heroic)
        [147207] = 4, --Weakened Resolve (Heroic)
        [144574] = 6, --Corrupted Prison
        [144574] = 6, --Corrupted Prison
        
        --Galakras
        [146765] = 5, --Flame Arrows
        [147705] = 5, --Poison Cloud
        [146902] = 2, --Poison Tipped blades
        
        --Iron Juggernaut
        [144467] = 2, --Ignite Armor
        [144459] = 5, --Laser Burn
        [144498] = 5, --Napalm Oil
        [144918] = 5, --Cutter Laser
        [146325] = 6, --Cutter Laser Target
        
        --Kor'kron Dark Shaman
        [144089] = 6, --Toxic Mist
        [144215] = 2, --Froststorm Strike (Tank only)
        [143990] = 2, --Foul Geyser (Tank only)
        [144304] = 2, --Rend
        [144330] = 6, --Iron Prison (Heroic)
        
        --General Nazgrim
        [143638] = 6, --Bonecracker
        [143480] = 5, --Assassin's Mark
        [143431] = 6, --Magistrike (Dispell)
        [143494] = 2, --Sundering Blow (Tanks)
        [143882] = 5, --Hunter's Mark
        
        --Malkorok
        [142990] = 2, --Fatal Strike (Tank debuff)
        [142913] = 6, --Displaced Energy (Dispell)
        [143919] = 5, --Languish (Heroic)
        
        --Spoils of Pandaria
        [145685] = 2, --Unstable Defensive System
        [144853] = 3, --Carnivorous Bite
        [145987] = 5, --Set to Blow
        [145218] = 4, --Harden Flesh
        [145230] = 1, --Forbidden Magic
        [146217] = 4, --Keg Toss
        [146235] = 4, --Breath of Fire
        [145523] = 4, --Animated Strike
        [142983] = 6, --Torment (the new Wrack)
        [145715] = 3, --Blazing Charge
        [145747] = 5, --Bubbling Amber
        [146289] = 4, --Mass Paralysis
        
        --Thok the Bloodthirsty
        [143766] = 2, --Panic (tanks)
        [143773] = 2, --Freezing Breath (tanks)
        [143452] = 1, --Bloodied
        [146589] = 5, --Skeleton Key (tanks)
        [143445] = 6, --Fixate
        [143791] = 5, --Corrosive Blood
        [143777] = 3, --Frozen Solid (tanks)
        [143780] = 4, --Acid Breath
        [143800] = 5, --Icy Blood
        [143428] = 4, --Tail Lash
        
        --Siegecrafter Blackfuse
        [144236] = 4, --Pattern Recognition
        [144466] = 5, --Magnetic Crush
        [143385] = 2, --Electrostatic Charge (tank)
        [143856] = 6, --Superheated
        
        --Paragons of the Klaxxi
        [143617] = 5, --Blue Bomb
        [143701] = 5, --Whirling (stun)
        [143702] = 5, --Whirling
        [142808] = 6, --Fiery Edge
        [143609] = 5, --Yellow Sword
        [143610] = 5, --Red Drum
        [142931] = 2, --Exposed Veins
        [143619] = 5, --Yellow Bomb
        [143735] = 6, --Caustic Amber
        [146452] = 5, --Resonating Amber
        [142929] = 2, --Tenderizing Strikes
        [142797] = 5, --Noxious Vapors
        [143939] = 5, --Gouge
        [143275] = 2, --Hewn
        [143768] = 2, --Sonic Projection
        [142532] = 6, --Toxin: Blue
        [142534] = 6, --Toxin: Yellow
        [143279] = 2, --Genetic Alteration
        [143339] = 6, --Injection
        [142649] = 4, --Devour
        [146556] = 6, --Pierce
        [142671] = 6, --Mesmerize
        [143979] = 2, --Vicious Assault
        [143607] = 5, --Blue Sword
        [143614] = 5, --Yellow Drum
        [143612] = 5, --Blue Drum
        [142533] = 6, --Toxin: Red
        [143615] = 5, --Red Bomb
        [143974] = 2, --Shield Bash (tanks)
        
        --Garrosh Hellscream
        [144582] = 4, --Hamstring
        [144954] = 4, --Realm of Y'Shaarj
        [145183] = 2, --Gripping Despair (tanks)
        [144762] = 4, --Desecrated
        [145071] = 5, --Touch of Y'Sharrj
        [148718] = 4, --Fire Pit
        
        
        
        --Jin'rokh the Breaker
        [138006] = 4, --Electrified Waters
        [137399] = 6, --Focused Lightning fixate
        [138732] = 5, --Ionization
        [138349] = 2, --Static Wound (tank only)
        [137371] = 2, --Thundering Throw (tank only)
        
        --Horridon
        [136769] = 6, --Charge
        [136767] = 2, --Triple Puncture (tanks only)
        [136708] = 6, --Stone Gaze
        [136723] = 5, --Sand Trap
        [136587] = 5, --Venom Bolt Volley (dispellable)
        [136710] = 5, --Deadly Plague (disease)
        [136670] = 4, --Mortal Strike
        [136573] = 5, --Frozen Bolt (Debuff used by frozen orb)
        [136512] = 6, --Hex of Confusion
        [136719] = 6, --Blazing Sunlight
        [136654] = 6, --Rending Charge
        [140946] = 4, --Dire Fixation (Heroic Only)
        
        --Council of Elders
        [136922] = 6, --Frostbite
        [137084] = 3, --Body Heat
        [137641] = 6, --Soul Fragment (Heroic only)
        [136878] = 5, --Ensnared
        [136857] = 6, --Entrapped (Dispell)
        [137650] = 5, --Shadowed Soul
        [137359] = 6, --Shadowed Loa Spirit fixate target
        [137972] = 6, --Twisted Fate (Heroic only)
        [136860] = 5, --Quicksand
        
        --Tortos
        [134030] = 6, --Kick Shell
        [134920] = 6, --Quake Stomp
        [136751] = 6, --Sonic Screech
        [136753] = 2, --Slashing Talons (tank only)
        [137633] = 5, --Crystal Shell (heroic only)
        
        --Megaera
        [139822] = 6, --Cinder (Dispell)
        [134396] = 6, --Consuming Flames (Dispell)
        [137731] = 5, --Ignite Flesh
        [136892] = 6, --Frozen Solid
        [139909] = 5, --Icy Ground
        [137746] = 6, --Consuming Magic
        [139843] = 4, --Artic Freeze
        [139840] = 4, --Rot Armor
        [140179] = 6, --Suppression (stun)
        
        --Ji-Kun
        [138309] = 4, --Slimed
        [138319] = 5, --Feed Pool
        [140571] = 3, --Feed Pool
        [134372] = 3, --Screech
        
        --Durumu the Forgotten
        [133768] = 2, --Arterial Cut (tank only)
        [133767] = 2, --Serious Wound (Tank only)
        [136932] = 6, --Force of Will
        [134122] = 5, --Blue Beam
        [134123] = 5, --Red Beam
        [134124] = 5, --Yellow Beam
        [133795] = 6, --Life Drain
        [133597] = 6, --Dark Parasite
        [133732] = 3, --Infrared Light (the stacking red debuff)
        [133677] = 3, --Blue Rays (the stacking blue debuff)
        [133738] = 3, --Bright Light (the stacking yellow debuff)
        [133737] = 4, --Bright Light (The one that says you are actually in a beam)
        [133675] = 4, --Blue Rays (The one that says you are actually in a beam)
        [134626] = 5, --Lingering Gaze
        
        --Primordius
        [140546] = 6, --Fully Mutated
        [136180] = 3, --Keen Eyesight (Helpful)
        [136181] = 4, --Impared Eyesight (Harmful)
        [136182] = 3, --Improved Synapses (Helpful)
        [136183] = 4, --Dulled Synapses (Harmful)
        [136184] = 3, --Thick Bones (Helpful)
        [136185] = 4, --Fragile Bones (Harmful)
        [136186] = 3, --Clear Mind (Helpful)
        [136187] = 4, --Clouded Mind (Harmful)
        [136050] = 2, --Malformed Blood(Tank Only)
        
        --Dark Animus
        [138569] = 2, --Explosive Slam (tank only)
        [138659] = 6, --Touch of the Animus
        [138609] = 6, --Matter Swap
        [138691] = 4, --Anima Font
        [136962] = 5, --Anima Ring
        [138480] = 6, --Crimson Wake Fixate
        
        --Iron Qon
        [134647] = 6, --Scorched
        [136193] = 5, --Arcing Lightning
        [135147] = 2, --Dead Zone
        [134691] = 2, --Impale (tank only)
        [135145] = 6, --Freeze
        [136520] = 5, --Frozen Blood
        [137669] = 3, --Storm Cloud
        [137668] = 5, --Burning Cinders
        [137654] = 5, --Rushing Winds
        [136577] = 4, --Wind Storm
        [136192] = 4, --Lightning Storm
        [136615] = 6, --Electrified
        
        --Twin Consorts
        [137440] = 6, --Icy Shadows (tank only)
        [137417] = 6, --Flames of Passion
        [138306] = 5, --Serpent's Vitality
        [137408] = 2, --Fan of Flames (tank only)
        [137360] = 6, --Corrupted Healing (tanks and healers only?)
        [137375] = 3, --Beast of Nightmares
        [136722] = 6, --Slumber Spores
        
        --Lei Shen
        [135695] = 6, --Static Shock
        [136295] = 6, --Overcharged
        [135000] = 2, --Decapitate (Tank only)
        [394514] = 5, --Fusion Slash
        [136543] = 5, --Ball Lightning
        [134821] = 4, --Discharged Energy
        [136326] = 6, --Overcharge
        [137176] = 4, --Overloaded Circuits
        [136853] = 4, --Lightning Bolt
        [135153] = 6, --Crashing Thunder
        [136914] = 2, --Electrical Shock
        [135001] = 2, --Maim
        
        --Ra-Den (Heroic only)
        [138308] = 6, --Unstable Vita
        [138372] = 5, --Vita Sensitivity
        
        
        --Protector Kaolan
        [117519] = 7, --Touch of Sha
        [111850] = 7, --Lightning Prison: Targeted
        [117436] = 7, --Lightning Prison: Stunned
        [118191] = 7, --Corrupted Essence
        [117986] = 8, --Defiled Ground: Stacks
        
        --Tsulong
        [122768] = 7, --Dread Shadows
        [122777] = 7, --Nightmares (dispellable)
        [122752] = 7, --Shadow Breath
        [122789] = 7, --Sunbeam
        [123012] = 7, --Terrorize: 5% (dispellable)
        [123011] = 7, --Terrorize: 10% (dispellable)
        [123036] = 7, --Fright (dispellable)
        [122858] = 6, --Bathed in Light
        
        --Lei Shi
        [123121] = 7, --Spray
        [123705] = 7, --Scary Fog
        
        --Sha of Fear
        [119414] = 7, --Breath of Fear
        [129147] = 7, --Onimous Cackle
        [119983] = 7, --Dread Spray
        [120669] = 7, --Naked and Afraid
        [75683] = 7, --Waterspout
        
        [120629] = 7, --Huddle in Terror
        [120394] = 7, --Eternal Darkness
        [129189] = 7, --Sha Globe
        [119086] = 7, --Penetrating Bolt
        [119775] = 7, --Reaching Attack
        
        
        
        --Imperial Vizier Zor'lok
        [123812] = 7, --Pheromones of Zeal
        [122740] = 7, --Convert (MC)
        [122706] = 7, --Noise Cancelling (AMZ)
        
        --Blade Lord Ta'yak
        [123474] = 7, --Overwhelming Assault
        [122949] = 7, --Unseen Strike
        [124783] = 7, --Storm Unleashed
        [123180] = 8, --Wind Step
        
        --Garalon
        [122835] = 7, --Pheromones
        [123081] = 8, --Pungency
        [122774] = 7, --Crush
        [123423] = 8, --Weak Points
        
        --Wind Lord Mel'jarak
        [121881] = 8, --Amber Prison
        [122055] = 7, --Residue
        [122064] = 7, --Corrosive Resin
        
        --Amber-Shaper Un'sok
        [121949] = 7, --Parasitic Growth
        [122784] = 7, --Reshape Life
        
        --Grand Empress Shek'zeer
        [123707] = 7, --Eyes of the Empress
        [125390] = 7, --Fixate
        [123788] = 8, --Cry of Terror
        [124097] = 7, --Sticky Resin
        [123184] = 8, --Dissonance Field
        [124777] = 7, --Poison Bomb
        [124821] = 7, --Poison-Drenched Armor
        [124827] = 7, --Poison Fumes
        [124849] = 7, --Consuming Terror
        [124863] = 7, --Visions of Demise
        [124862] = 7, --Visions of Demise: Target
        [123845] = 7, --Heart of Fear: Chosen
        [123846] = 7, --Heart of Fear: Lure
        [125283] = 7, --Sha Corruption
        
        
        
        --The Stone Guard
        [130395] = 7, --Jasper Chains
        [130774] = 7, --Amethyst Pool
        [116281] = 7, --Cobalt Mine Blast
        [125206] = 7, --Rend Flesh
        
        --Feng The Accursed
        [131788] = 7, --Lightning Lash
        [116942] = 7, --Flaming Spear
        [131790] = 7, --Arcane Shock
        [131792] = 7, --Shadowburn
        [116784] = 9, --Wildfire Spark
        [116374] = 7, --Lightning Charge
        [116364] = 7, --Arcane Velocity
        [116040] = 7, --Epicenter
        
        --Gara'jal the Spiritbinder
        [122151] = 9, --Voodoo doll
        [117723] = 8, --Frail Soul
        [116260] = 7, --Crossed Over
        [116278] = 7, --Soul Sever
        
        --The Spirit Kings
        --Meng the Demented
        [117708] = 7, --Maddening Shout
        --Subetai the Swift
        [118048] = 7, --Pillaged
        [118047] = 7, --Pillage: Target
        [118135] = 7, --Pinned Down
        [118163] = 7, --Robbed Blind
        --Zian of the Endless Shadow
        [118303] = 7, --Undying Shadow: Fixate
        
        --Elegon
        [117878] = 7, --Overcharged
        [117949] = 8, --Closed circuit
        [117945] = 7, --Arcing Energy
        -- Celestial Protector (Heroic)
        [132222] = 8, --Destabilizing Energies
        
        --Will of the Emperor
        --Jan-xi and Qin-xi
        [116835] = 7, --Devastating Arc
        [132425] = 7, --Stomp
        -- Rage
        [116525] = 7, --Focused Assault (Rage fixate)
        -- Courage
        [116778] = 7, --Focused Defense (fixate)
        [117485] = 7, --Impeding Thrust (slow debuff)
        -- Strength
        [116550] = 7, --Energizing Smash (knock down)
        -- Titan Spark (Heroic)
        [116829] = 7, --Focused Energy (fixate)
        
        
        --Deep Corruption IDs
        [109389] = 8,
        [103628] = 8,
        
        --Ultraxion
        [109075] = 7, -- Fading Light
        
        --Baleroc
        [100232] = 9, -- Torment
        
        [88954] = 6, -- Consuming Darkness
        
        
        --Magmaw
        [78941] = 6, -- Parasitic Infection
        [89773] = 7, -- Mangle
        
        --Omnitron Defense System
        [79888] = 6, -- Lightning Conductor
        [79505] = 8, -- Flamethrower
        [80161] = 7, -- Chemical Cloud
        [79501] = 8, -- Acquiring Target
        [80011] = 7, -- Soaked in Poison
        [80094] = 7, -- Fixate
        [92023] = 9, -- Encasing Shadows
        [92048] = 9, -- Shadow Infusion
        [92053] = 9, -- Shadow Conductor
        --[91858] = 6, -- Overcharged Power Generator
        --Maloriak
        [92973] = 8, -- Consuming Flames
        [92978] = 8, -- Flash Freeze
        [92976] = 7, -- Biting Chill
        [91829] = 7, -- Fixate
        [92787] = 9, -- Engulfing Darkness
        
        --Atramedes
        [78092] = 7, -- Tracking
        [78897] = 8, -- Noisy
        [78023] = 7, -- Roaring Flame
        
        --Chimaeron
        [89084] = 8, -- Low Health
        [82881] = 7, -- Break
        [82890] = 9, -- Mortality
        
        --Nefarian
        [94128] = 7, -- Tail Lash
        --[94075] = 8, -- Magma
        [79339] = 9, -- Explosive Cinders
        [79318] = 9, -- Dominion
        
        --Halfus
        [39171] = 7, -- Malevolent Strikes
        [86169] = 8, -- Furious Roar
        
        --Valiona & Theralion
        [86788] = 6, -- Blackout
        [86622] = 7, -- Engulfing Magic
        [86202] = 7, -- Twilight Shift
        
        --Council
        [82665] = 7, -- Heart of Ice
        [82660] = 7, -- Burning Blood
        [82762] = 7, -- Waterlogged
        [83099] = 7, -- Lightning Rod
        [82285] = 7, -- Elemental Stasis
        [92488] = 8, -- Gravity Crush
        
        --Cho'gall
        [86028] = 6, -- Cho's Blast
        [86029] = 6, -- Gall's Blast
        [93189] = 7, -- Corrupted Blood
        [93133] = 7, -- Debilitating Beam
        [81836] = 8, -- Corruption: Accelerated
        [81831] = 8, -- Corruption: Sickness
        [82125] = 8, -- Corruption: Malformation
        [82170] = 8, -- Corruption: Absolute
        
        --Sinestra
        [92956] = 9, -- Wrack
        
        --Conclave
        [85576] = 9, -- Withering Winds
        [85573] = 9, -- Deafening Winds
        [93057] = 7, -- Slicing Gale
        [86481] = 8, -- Hurricane
        [93123] = 7, -- Wind Chill
        [93121] = 8, -- Toxic Spores
        
        --Al'Akir
        --[93281] = 7, -- Acid Rain
        [87873] = 7, -- Static Shock
        [88427] = 7, -- Electrocute
        [93294] = 8, -- Lightning Rod
        [93284] = 9, -- Squall Line
        
---------------------------
-- LEG BrokenIsles BEGIN --
---------------------------

-- Calamir
[218888] = 21, -- Impish Flames (non-dispellable)
[217925] = 24, -- Icy Comet (non-dispellable) AoE Slow
[217966] = 24, -- Howling Gale (non-dispellable)
[218012] = 25, -- Arcanopulse (non-dispellable) DMG + Stun

-- Drugon the Frostblood
[219602] = 31, -- Snow Plow (non-dispellable) Fixate

-- Flotsam
[223373] = 41, -- Yaksam (non-dispellable) Cone AoE
[223355] = 42, -- Oozing Bile (non-dispellable)

-- Humongris
[216430] = 50, -- Earthshake Stomp (non-dispellable) DMG + Stun
[216467] = 51, -- Make the Snow (non-dispellable) AoE Frost DMG + Slow
[216822] = 52, -- You Go Bang! (non-dispellable) Fire Bomb + DMG Increase Debuff

-- Levantus
[170196] = 61, -- Rending Whirl (non-dispellable) Rend
[217362] = 63, -- Turbulent Vortex (dispellable)
[217229] = 64, -- Rampaging Torrent (non-dispellable) DMG + DMG Increase Debuff Stacks

-- Na'zak the Fiend
[219349] = 71, -- Corroding Spray (non-dispellable) Cone AoE Stacks

-- Nithogg
[212867] = 81, -- Electrical Storm (non-dispellable) Ground AoE
[212852] = 82, -- Storm Breath (non-dispellable) DMG + DMG Increase Debuff

-- Shar'thos
[215876] = 92, -- Burning Earth (non-dispellable) Ground AoE
[216044] = 93, -- Cry of the Tormented (non-dispellable) AoE Fear

-- The Soultakers
[213665] = 101, -- Marauding Mists (non-dispellable) DMG + Disorient

-------------------------
-- LEG BrokenIsles END --
-------------------------

        --------------------------------
        -- LEG EmeraldNightmare BEGIN --
        --------------------------------

        -- Nythendra
        [204504] = 11, -- Infested
        [203045] = 12, -- Infested Ground (standing in pool)
        [203096] = 13, -- Rot (AoE people around you)
        [204463] = 14, -- Volatile Rot (exploding tank)
        [203646] = 15, -- Burst of Corruption
        
        -- Il'gynoth, Heart of Corruption
        [212886] = 21, -- Nightmare Corruption (standing in pool)
        [215845] = 22, -- Dispersed Spores (dot)
        [210099] = 23, -- The Eye of Il'gynoth Nightmare Ichor (fixate)
        [209469] = 24, -- Touch of Corruption (dot, stacks, magic)
        [209471] = 25, -- Nightmare Explosion (dot, stacks)
        [210984] = 26, -- Eye of Fate (tank debuff, stacks)
        [208697] = 27, -- Mind Flay (dot)
        [208929] = 28, -- Spew Corruption (dot, drops pools)
        [215128] = 29, -- Cursed Blood (dot, weak bomb)
        
        -- Elerethe Renferal
        [215307] = 31, -- Web of Pain (link)
        [215460] = 32, -- Necrotic Venom (dot, drops pools)
        [213124] = 33, -- Venomous Pool (standing in pool)
        [210850] = 34, -- Twisting Shadows (dot)
        [215582] = 35, -- Raking Talons (tank debuff, stacks)
        [218519] = 36, -- Wind Burn (debuff, stacks)
        [210228] = 37, -- Dripping Fangs (dot, stacks)
        
        -- Ursoc
        [197943] = 41, -- Overwhelm (tank debuff, stacks)
        [204859] = 42, -- Rend Flesh (dot)
        [198006] = 43, -- Focused Gaze (fixate)
        [198108] = 44, -- Momentum (debuff)
        [197980] = 45, -- Nightmarish Cacophony (fear)
        [205611] = 46, -- Miasma (standing in)
        
        -- Dragons of Nightmare
        [203110] = 51, -- Slumbering Nightmare (stun)
        [203102] = 52, -- Mark of Ysondre (dot, stacks)
        [207681] = 53, -- Nightmare Bloom (standing in)
        [204731] = 54, -- Wasting Dread (debuff)
        [203770] = 55, -- Defiled Vines (root, magic)
        [203125] = 56, -- Mark of Emeriss (dot, stacks)
        [203787] = 57, -- Volatile Infection (AoE dot)
        [203086] = 58, -- Mark of Lethon (dot, stacks)
        [204044] = 59, -- Mark of Taerar (dot, stacks)
        [203121] = 60, -- Shadow Burst (dot, stacks)
        [205341] = 61, -- Seeping Fog (dot, sleep, magic)
        [204078] = 61, -- Bellowing Roar (fear)
        [214543] = 63, -- Collapsing Nightmare (debuff)
        
        -- Cenarius
        [212681] = 71, -- Cleansed Ground (buff)
        [210279] = 72, -- Creeping Nightmares (debuff, stacks)
        [210315] = 73, -- Nightmare Brambles (dot, root, magic)
        [213162] = 74, -- Nightmare Blast (tank debuff, stacks)
        [226821] = 75, -- Desiccating Stomp (melee debuff, stacks)
        [211507] = 76, -- Nightmare Javelin (dot, magic)
        [211471] = 77, -- Scorned Touch (dot, spreads)
        [216516] = 78, -- Ancient Dream (buff)
        [211989] = 79, -- Unbound Touch (buff, spreads)
        [211990] = 80, -- Unbound Essence (buff)
        [214529] = 81, -- Spear of Nightmares (tank debuff, stacks)
        
        -- Xavius
        [206005] = 91, -- Dream Simulacrum (buff)
        [206109] = 92, -- Awakening to the Nightmare (buff)
        [208431] = 93, -- Descent into Madness (buff)
        [207409] = 94, -- Madness (mind control)
        [206651] = 95, -- Darkening Soul (dot, magic)
        [211802] = 96, -- Nightmare Blades (fixate)
        [205771] = 97, -- Tormenting Fixation (fixate)
        [209158] = 98, -- Blackening Soul (dot, magic)
        [205612] = 99, -- Blackened? (debuff)
        [205612] = 100, -- Bonds of Terror (link)
        [205612] = 101, -- Tainted Discharge (standing in)
        [205612] = 102, -- The Infinite Dark (standing in?)

        ------------------------------
        -- LEG EmeraldNightmare END --
        ------------------------------
}

-- Begin
local function OnUnitAura(self, event, unit, ...)
    local indicatorBuffs = {}
    local debuffs = {}
    local shouldShow = false
    
    for i = 1, 255 do
        local _, _, texture, count, _, duration, timeLeft, caster, _, _, spellID = UnitBuff("player", i)
        
        if not spellID then
            break
        end
        
        if indicatorFilters[DB.MyClass] and caster == "player" then
            for i = 1, 4 do
                if spellID == indicatorFilters[DB.MyClass][i] then
                    indicatorBuffs[i] = {
                        show = true,
                        duration = duration, timeLeft = timeLeft,
                    }
                elseif not indicatorBuffs[i] then
                    indicatorBuffs[i] = {
                        show = false,
                        duration = 0, timeLeft = 0,
                    }
                end
            end
        end
        
        if raidDebuffFilters[spellID] then
            table.insert(debuffs, {
                count = count,
                texture = texture,
                spellID = spellID,
                duration = duration,
                timeLeft = timeLeft,
                priority = raidDebuffFilters[spellID],
            })
        end
    end
    
    for i = 1, 255 do
        local _, _, texture, count, _, duration, timeLeft, _, _, _, spellID = UnitDebuff("player", i)
        
        if not spellID then
            break
        end
        
        if raidDebuffFilters[spellID] then
            table.insert(debuffs, {
                count = count,
                texture = texture,
                spellID = spellID,
                duration = duration,
                timeLeft = timeLeft,
                priority = raidDebuffFilters[spellID],
            })
        end
    end
    
    for i = 1, 4 do
        local indicatorBuff = indicatorBuffs[i]
        local indicator = self.Indicators[i]
        
        if indicatorBuff and indicatorBuff.show then
            indicator:Show()
            
            indicator.timer = 0
            indicator.duration = indicatorBuff.duration
            indicator.timeLeft = indicatorBuff.timeLeft
            indicator:SetScript("OnUpdate", function(self, elapsed, ...)
                self.timer = self.timer + elapsed
                
                if self.timer < 0.1 then
                    return
                else
                    self.timer = 0
                end
                
                if self.timeLeft - GetTime() < self.duration * 0.3 then
                    self:SetBackdropColor(1.00, 0.00, 0.00, 1.00)
                else
                    self:SetBackdropColor(0.00, 1.00, 0.00, 1.00)
                end
            end)
        else
            indicator:Hide()
            indicator:SetScript("OnUpdate", nil)
        end
    end
    
    table.sort(debuffs, function(l, r)
        return l.priority < r.priority
    end)
    
    if #debuffs == 0 then
        self.RaidDebuff:Hide()
        
        self.NameTag:SetAlpha(1.00)
        self.StatusTag:SetAlpha(1.00)
    else
        local debuff = debuffs[1]
        local count, texture, duration, timeLeft = debuff.count, debuff.texture, debuff.duration, debuff.timeLeft
        
        self.RaidDebuff.icon:SetTexture(texture)
        self.RaidDebuff.cd:SetCooldown(timeLeft - duration, duration)
        
        if count and count > 0 then
            self.RaidDebuff.count:SetText(count)
        end
        self.RaidDebuff:Show()
        
        self.NameTag:SetAlpha(0.25)
        self.StatusTag:SetAlpha(0.25)
    end
end

local function OnUnitThreatUpdate(self, event, unit, ...)
    if self.unit ~= unit then
        return
    end
    
    local r, g, b, a = 0.00, 0.00, 0.00, 1.00
    local _, status = UnitDetailedThreatSituation(unit, "target")
    
    if status and status > 1 then
        a = 0.75
        r, g, b = GetThreatStatusColor(status)
    end
    
    self.Power.shadow:SetBackdropBorderColor(r, g, b, a)
    self.Health.shadow:SetBackdropBorderColor(r, g, b, a)
end

local function CreatePower(self, ...)
    local power = CreateFrame("StatusBar", nil, self)
    power:SetPoint("BOTTOM", self)
    power:SetSize(self:GetWidth(), 2)
    power:SetStatusBarTexture(DB.Statusbar)
    
    power.bg = power:CreateTexture(nil, "BACKGROUND")
    power.bg:SetTexture(DB.Statusbar)
    power.bg:SetAllPoints()
    power.bg:SetVertexColor(0.12, 0.12, 0.12)
    power.bg.multiplier = 0.12
    
    power.Smooth = true
    power.colorPower = true
    power.frequentUpdates = true
    power.shadow = S.MakeShadow(power, 2)
    
    self.Power = power
end

local function CreateHealth(self, ...)
    local health = CreateFrame("StatusBar", nil, self)
    health:SetPoint("TOP", self)
    health:SetStatusBarTexture(DB.Statusbar)
    health:SetSize(self:GetWidth(), self:GetHeight() - 4)
    
    health.bg = health:CreateTexture(nil, "BACKGROUND")
    health.bg:SetAllPoints()
    health.bg:SetTexture(DB.Statusbar)
    health.bg:SetVertexColor(0.12, 0.12, 0.12)
    health.bg.multiplier = 0.12
    
    health.Smooth = true
    health.colorTapping = true
    health.colorDisconnected = true
    health.colorClass = true
    health.colorReaction = true
    health.colorHealth = true
    health.frequentUpdates = true
    health.shadow = S.MakeShadow(health, 2)
    
    self.Health = health
end

local function CreateTag(self, ...)
    local nameTag = S.MakeText(self.Health, 10)
    nameTag:SetPoint("CENTER", 0, 0)
    
    self.NameTag = nameTag
    self:Tag(self.NameTag, "[Sora:Color][Sora:Name]|r")
    
    local statusTag = S.MakeText(self.Health, 7)
    statusTag:SetPoint("CENTER", 0, -10)
    
    self.StatusTag = statusTag
    self:Tag(self.StatusTag, "[Sora:Color][Sora:Status]|r")
end

local function CreateAura(self, ...)
    local raidDebuff = CreateFrame("Frame", nil, self.Health)
    raidDebuff:Hide()
    raidDebuff:SetSize(20, 20)
    raidDebuff:SetFrameStrata("HIGH")
    raidDebuff:SetPoint("CENTER", 0, 0)
    
    raidDebuff.cd = CreateFrame("Cooldown", "$parentCooldown", raidDebuff, "CooldownFrameTemplate")
    raidDebuff.cd:SetAllPoints()
    
    raidDebuff.icon = raidDebuff:CreateTexture(nil, "OVERLAY")
    raidDebuff.icon:SetAllPoints()
    
    raidDebuff.count = S.MakeText(raidDebuff, 8)
    raidDebuff.count:SetPoint("BOTTOMRIGHT", raidDebuff, "BOTTOMRIGHT", 1, 1)
    
    raidDebuff.shadow = S.MakeShadow(raidDebuff, 1)
    
    self.RaidDebuff = raidDebuff
end

local function CreateRange(self, ...)
    self.Range = {
        insideAlpha = 1.00,
        outsideAlpha = 0.40,
    }
end

local function CreateRaidIcon(self, ...)
    local RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
    RaidIcon:SetSize(16, 16)
    RaidIcon:SetPoint("CENTER", self.Health, "TOP", 0, 2)
    
    self.RaidIcon = RaidIcon
end

local function CreateIndicator(self, ...)
    local postions = {
        {"TOPLEFT", self.Health, "TOPLEFT", 2.5, -2.0},
        {"TOPRIGHT", self.Health, "TOPRIGHT", -2.5, -2.0},
        {"BOTTOMLEFT", self.Health, "BOTTOMLEFT", 2.5, 2.0},
        {"BOTTOMRIGHT", self.Health, "BOTTOMRIGHT", -2.5, 2.0},
    }
    
    local indicators = {}
    for i = 1, 4 do
        local indicator = CreateFrame("Frame", nil, self)
        indicator:Hide()
        indicator:SetSize(5, 5)
        indicator:SetFrameStrata("HIGH")
        indicator:SetPoint(unpack(postions[i]))
        indicator:SetBackdrop({bgFile = DB.Solid})
        indicator.shadow = S.MakeShadow(indicator, 1)
        
        indicators[i] = indicator
    end
    
    self.Indicators = indicators
end

local function CreateCombatIcon(self, ...)
    local leader = self.Health:CreateTexture(nil, "OVERLAY")
    leader:SetSize(16, 16)
    leader:SetPoint("TOPLEFT", -7, 9)
    self.Leader = leader
    
    local assistant = self.Health:CreateTexture(nil, "OVERLAY")
    assistant:SetAllPoints(self.Leader)
    self.Assistant = assistant
    
    local masterLooter = self.Health:CreateTexture(nil, "OVERLAY")
    masterLooter:SetSize(16, 16)
    masterLooter:SetPoint("LEFT", self.Leader, "RIGHT")
    self.MasterLooter = masterLooter
    
    local LFDRole = self.Health:CreateTexture(nil, "OVERLAY")
    LFDRole:SetSize(16, 16)
    LFDRole:SetPoint("TOPRIGHT", 7, 9)
    self.LFDRole = LFDRole
    
    local readyCheck = self.Health:CreateTexture(nil, "OVERLAY")
    readyCheck:SetSize(16, 16)
    readyCheck:SetPoint("CENTER", 0, 0)
    self.ReadyCheck = readyCheck
end

local function RegisterForEvent(self, ...)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:RegisterEvent("UNIT_AURA", OnUnitAura)
    self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", OnUnitThreatUpdate)
    self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", OnUnitThreatUpdate)
end

local function RegisterStyle(self, ...)
    self:RegisterForClicks("AnyUp")
    self:SetSize(C.UnitFrame.Raid.Width, C.UnitFrame.Raid.Height)
    
    CreatePower(self, ...)
    CreateHealth(self, ...)
    
    CreateTag(self, ...)
    CreateAura(self, ...)
    CreateRange(self, ...)
    CreateRaidIcon(self, ...)
    CreateIndicator(self, ...)
    CreateCombatIcon(self, ...)
    
    RegisterForEvent(self, ...)
end

local function OnPlayerLogin(self, event, ...)
    CompactRaidFrameManager:UnregisterAllEvents()
    CompactRaidFrameManager.Show = function() end
    CompactRaidFrameManager:Hide()
    
    CompactRaidFrameContainer:UnregisterAllEvents()
    CompactRaidFrameContainer.Show = function() end
    CompactRaidFrameContainer:Hide()
    
    oUF:RegisterStyle("oUF_Sora_Raid", RegisterStyle)
    oUF:SetActiveStyle("oUF_Sora_Raid")
    
    local width = C.UnitFrame.Raid.Width
    local height = C.UnitFrame.Raid.Height
    local anchor = CreateFrame("Frame", nil, UIParent)
    anchor:SetPoint(unpack(C.UnitFrame.Raid.Postion))
    anchor:SetSize(width * 5 + 8 * 4, height * 5 + 8 * 4)
    
    local oUFFrame = oUF:SpawnHeader("oUF_Sora_Raid", nil, "raid,party,solo",
        "showSolo", true,
        "showRaid", true,
        "showParty", true,
        "showPlayer", true,
        "xoffset", 8,
        "yoffset", -8,
        "groupBy", "GROUP",
        "groupFilter", "1,2,3,4,5",
        "groupingOrder", "1,2,3,4,5",
        "maxColumns", 5,
        "columnSpacing", 8,
        "unitsPerColumn", 5,
        "sortMethod", "INDEX",
        "point", "LEFT",
        "columnAnchorPoint", "TOP"
    )
    oUFFrame:SetPoint("TOPLEFT", anchor, "TOPLEFT", 0, 0)
end

local Event = CreateFrame("Frame", nil, UIParent)
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin(self, event, ...)
    end
end)

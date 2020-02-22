function GetAddOnInfo()
    return
end

function UnitFactionGroup()
    return 'Horde'
end

dofile('../../db/init.lua')
dofile('../../db/items.lua')
dofile('../../db/units.lua')
dofile('../../db/objects.lua')
dofile('../../db/refloot.lua')
dofile('../../db/quests.lua')
dofile('../../db/meta.lua')

dofile('../../db-patches/quests-questie.lua')
dofile('../../db-patches/units-questie.lua')
dofile('../../db-patches/units-wowhead.lua')
dofile('../../db-patches/manual-patch.lua')

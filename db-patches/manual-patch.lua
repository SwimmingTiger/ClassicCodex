-- Manually maintained database patches
if select(4, GetAddOnInfo('MergeQuestieToCodexDB')) then return end
local D = CodexDB.units.data
-- Chief Murgut <https://classic.wowhead.com/npc=12918/chief-murgut>
D[12918].coords={
{56.4,63.6,331,0},
}

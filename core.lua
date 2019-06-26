Codex = {}
Codex.Build = GetBuildInfo()
if (tonumber(string.sub(Codex.Build, 1, 1)) > 2) then
    print("Codex - Error - This is not Classic WoW")
    return
end

Codex.Name = UnitName("player")
Codex.Realm = string.gsub(GetRealmName(), " ", "")
Codex.Faction = UnitFactionGroup("player")
Codex.Level = UnitLevel("player")
Codex.Experience = UnitXP("player")
Codex.Version = tonumber(GetAddOnMetadata("Classic Codex", "Version"))
Codex.Class = {}
Codex.RaceLocale, Codex.Race = UnitRace("player")
Codex.Class[1], Codex.Class[2], Codex.Class[3] = UnitClass("player")
Codex.QuestHelperEnable = "off"
Codex.HBDP = LibStub("HereBeDragons-Pins-2.0")
Codex.HBD = LibStub("HereBeDragons-2.0")
Codex.Locale = GetLocale()

function Codex.GetContinent()
    local mapID = C_Map.GetBestMapForUnit("player")
    if (mapID) then
        local info = C_Map.GetMapInfo(mapID)
        if (info) then
            while (info['mapType'] and info['mapType'] > 2) do
                info = C_Map.GetMapInfo(info['parentMapID'])
            end
            if (info['mapType'] == 2) then
                return info['mapID']
            end
        end
    end
end

Codex.EventFrame = CreateFrame("Frame")
Codex.EventFrame:RegisterEvent("ADDON_LOADED")

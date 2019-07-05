-- local items = pfDB["items"]
-- local units = pfDB["units"]
-- local objects = pfDB["objects"]
-- local quests = pfDB["quests"]

local function unitsFunction(someVar) 
    if table.getn(someVar) == 1 then
        if tooltip and pfDB["unitNames"][someVar[1]] then
            dbIndex = 1
        end
    else
        for key, value in pairs(someVar) do
            if tooltip and pfDB["unitNames"][value] and string.find(tooltip, pfDB["unitNames"][value]) then
                dbIndex = key
            end
        end
    end

    local unitID = someVar[dbIndex]
    local unit = Codex.units[unitID]
    if unit and unit["coords"] and unit["lvl"] then
        local coords = unit["coords"]
        local level = unit["lvl"]
        if pfDB["unitNames"][unitID] then
            local name = pfDB["unitNames"][unitID]
            local coordList = {}
            for k, v in pairs(coords) do
                local x = v[1] / 100
                local y = v[2] / 100
                local zoneID = v[3]

                tinsert(coordList, {x, y, zoneID})
            end
            tinsert(Codex.QuestLog[questID]["objectives"][objectiveIndex]["targets"], {["name"]=name, ["level"]=level, ["coords"]=coordList})
        end
    end
end

local function objectsFunction(someVar)
    for key, value in pairs(someVar) do
        if tooltip and pfDB["objectNames"][value] and string.find(tooltip, pfDB["objectNames"][value]) then
            dbIndex = key
        end
    end

    local objectID = someVar[dbIndex]
    local object = Codex.objects[objectID]
    if object and object["coords"] then
        local coords = object["coords"]
        if pfDB["objectNames"][objectID] then
            local name = pfDB["objectNames"][objectID]
            local coordList = {}
            for k, v in pairs(coords) do
                local x = v[1] / 100
                local y = v[2] / 100
                local zoneID = v[3]

                tinsert(coordList, {x, y, zoneID})
            end
            tinsert(Codex.QuestLog[questID]["objectives"][objectiveIndex]["targets"], {["name"]=name, ["coords"]=coordList})
        end
    end
end
function Codex.GetObjectives(questID, objectiveIndex, tooltip, fillers)
    local dbIndex = 0
    local quest = Codex.quests[questID]
    if quest then
        if quest["obj"] then
            if quest["obj"]["I"] then
                if quest["obj"]["I"][objectiveIndex] then
                    for key, value in pairs(quest["obj"]["I"]) do
                        if tooltip and pfDB["itemNames"][value] and string.find(tooltip, pfDB["itemNames"][value]) then
                            dbIndex = key
                        end
                    end
                end

                local itemID = quest["obj"]["I"][dbIndex]
                local item = Codex.items[itemID]
                if item then
                    if item["O"] then
                        for key, value in pairs(item["O"]) do
                            if Codex.objects[key] and Codex.objects[key]["coords"] then
                                local coords = Codex.objects[key]["coords"]
                                if pfDB["objectNames"][key] then
                                    local name = pfDB["objectNames"][key]
                                    local coordList = {}
                                    for k, v in pairs(coords) do
                                        local x = v[1] / 100
                                        local y = v[2] / 100
                                        local zoneID = v[3]

                                        tinsert(coordList, {x, y, zoneID})
                                    end
                                    tinsert(Codex.QuestLog[questID]["objectives"][objectiveIndex]["targets"], {["name"]=name, ["coords"]=coordList})
                                end
                            end
                        end
                    end
                    if item["U"] then
                        for key, value in pairs(item["U"]) do
                            if Codex.units[key] and Codex.units[key]["coords"] and Codex.units[key]["lvl"] then
                                local coords = Codex.units[key]["coords"]
                                local level = Codex.units[key]["lvl"]
                                if pfDB["unitNames"][key] then
                                    local name = pfDB["unitNames"][key]
                                    local coordList = {}
                                    for k, v in pairs(coords) do
                                        local x = v[1] / 100
                                        local y = v[2] / 100
                                        local zoneID = v[3]

                                        tinsert(coordList, {x, y, zoneID})
                                    end
                                    tinsert(Codex.QuestLog[questID]["objectives"][objectiveIndex]["targets"], {["name"]=name, ["level"]=level, ["coords"]=coordList})
                                end
                            end
                        end
                    end
                end
            end
            if quest["obj"]["U"] then
                unitsFunction(quest["obj"]["U"])
            end
            if quest["obj"]["O"] then
                objectsFunction(quest["obj"]["O"])
            end
        end
    end
end


function Codex.GetTurnIn(questID)
    local quest = Codex.quests[questID]
    if quest then
        if quest["end"] then
            if quest["end"]["U"] then
                local unitID = quest["end"]["U"][1]
                local unit = Codex.units[unitID]
                if unit and unit["coords"] then
                    local coords = unit["coords"]
                    local x = coords[1][1] / 100
                    local y = coords[1][2] / 100
                    local zoneID = coords[1][3]

                    if pfDB["unitNames"][unitID] then
                        local name = pfDB["unitNames"][unitID]

                        Codex.QuestLog[questID]["turnin"] = {["name"]=name, ["coords"]={x, y, zoneID}}
                    end
                end
            end
        end
    end
end

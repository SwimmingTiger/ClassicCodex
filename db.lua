function Codex.GetObjectives(questID, objectiveIndex, tooltip, fillers)
    local dbIndex = 0
    if pfDB["quests"][questID] then
        if pfDB["quests"][questID]["obj"] then
            if pfDB["quests"][questID]["obj"]["I"] then
                if pfDB["quests"][questID]["obj"]["I"][objectiveIndex] then
                    for key, value in pairs(pfDB["quests"][questID]["obj"]["I"]) do
                        if tooltip and pfDB["itemNames"][value] and string.find(tooltip, pfDB["itemNames"][value]) then
                            dbIndex = key
                        end
                    end
                end

                local itemID = pfDB["quests"][questID]["obj"]["I"][dbIndex]
                if pfDB["items"][itemID] then
                    if pfDB["items"][itemID]["O"] then
                        for key, value in pairs(pfDB["items"][itemID]["O"]) do
                            if pfDB["objects"][key] and pfDB["objects"][key]["coords"] then
                                local coords = pfDB["objects"][key]["coords"]
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
                    if pfDB["items"][itemID]["U"] then
                        for key, value in pairs(pfDB["items"][itemID]["U"]) do
                            if pfDB["units"][key] and pfDB["units"][key]["coords"] and pfDB["units"][key]["lvl"] then
                                local coords = pfDB["units"][key]["coords"]
                                local level = pfDB["units"][key]["lvl"]
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
            if pfDB["quests"][questID]["obj"]["U"] then
                for key, value in pairs(pfDB["quests"][questID]["obj"]["U"]) do
                    if tooltip and pfDB["unitNames"][value] and string.find(tooltip, pfDB["unitNames"][value]) then
                        dbIndex = key
                    end
                end

                local unitID = pfDB["quests"][questID]["obj"]["U"][dbIndex]
                if pfDB["units"][unitID] and pfDB["units"][unitID]["coords"] and pfDB["units"][unitID]["lvl"] then
                    local coords = pfDB["units"][unitID]["coords"]
                    local level = pfDB["units"][unitID]["lvl"]
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
            if pfDB["quests"][questID]["obj"]["O"] then
                for key, value in pairs(pfDB["quests"][questID]["obj"]["O"]) do
                    if tooltip and pfDB["objectNames"][value] and string.find(tooltip, pfDB["objectNames"][value]) then
                        dbIndex = key
                    end
                end

                local objectID = pfDB["quests"][questID]["obj"]["O"][dbIndex]
                if pfDB["objects"][objectID] and pfDB["objects"][objectID]["coords"] then
                    local coords = pfDB["objects"][objectID]["coords"]
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
        end
    end
end

function Codex.GetTurnIn(questID)
    if pfDB["quests"][questID] then
        if pfDB["quests"][questID]["end"] then
            if pfDB["quests"][questID]["end"]["U"] then
                local unitID = pfDB["quests"][questID]["end"]["U"][1]
                if pfDB["units"][unitID] and pfDB["units"][unitID]["coords"] then
                    local coords = pfDB["units"][unitID]["coords"]
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

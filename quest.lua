Codex.Quest = {}
Codex.QuestLog = {}
-- Codex.QuestLogz = {
--     ["1234"] = {
--         ["isComplete"] = false,
--         ["objectives"] = {
--             {
--                 ["isComplete"] = false,
--                 ["text"]
--                 ["targets"] = {
--                     ["name"],
--                     ["coords"],

--                 }
--             },
--             {}
--         },
--         ["TurnInCoords"] = {
--             someObject
--         }
--     }
-- }

function Codex.Quest.UpdateQuestList()
    local index = 1
    Codex.QuestLog = {}
    while GetQuestLogTitle(index) do
        local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID = GetQuestLogTitle(index)
        if not isHeader and questID > 0 then
            if isComplete == 1 then
                isComplete = true
            else
                isComplete = false
            end

            Codex.QuestLog[questID] = {}
            Codex.QuestLog[questID]["name"] = title
            Codex.QuestLog[questID]["turnin"] = {}
            Codex.QuestLog[questID]["objectives"] = {}

            -- Get Turn in of the quest
            Codex.GetTurnIn(questID)

            local objectiveCount = GetNumQuestLeaderBoards(SelectQuestLogEntry(index))
            if objectiveCount == 0 then
                isComplete = true
            end

            Codex.QuestLog[questID]["isComplete"] = isComplete
            -- Codex.QuestList[questID]["isComplete"] = isComplete
            -- Codex.QuestList[questID]["objectiveCount"] = objectiveCount

            if objectiveCount and objectiveCount > 0 then
                for objectiveIndex = 1, objectiveCount do
                    local text, objectiveType, complete = GetQuestLogLeaderBoard(objectiveIndex, SelectQuestLogEntry(index))

                    Codex.QuestLog[questID]["objectives"][objectiveIndex] = {}

                    -- if not complete then
                    Codex.QuestLog[questID]["objectives"][objectiveIndex]["targets"] = {}
                    Codex.GetObjectives(questID, tonumber(objectiveIndex), text)
                    -- end

                    Codex.QuestLog[questID]["objectives"][objectiveIndex]["text"] = text
                    Codex.QuestLog[questID]["objectives"][objectiveIndex]["isComplete"] = finished
                    -- if Codex.ShowedDB[questID] and Codex.ShowedDB[questID][objectiveIndex] then
                end
            end
        end
        index = index + 1
    end
    Codex.UpdateMap()
end

function Codex.CheckNamePlate()
    local something = WorldFrame:GetNumChildren()
    local index = 1
    local plateList = {}
    for index = 1, something do
        local frame = select(index, WorldFrame:GetChildren())
        if frame:GetName() and frame:GetName():find("NamePlate%d") and not frame.skinned then
            frame.skinned = 1
            frame.icon = CreateFrame("Frame", nil, frame)
            frame.icon:SetFrameStrata("HIGH")
            frame.icon:SetWidth(25)
            frame.icon:SetHeight(25)

            local texture = frame.icon:CreateTexture(nil, "HIGH")
            texture:SetTexture("Interface\\Addons\\placeholder\\img\\pickup.tga")
            texture:SetAllPoints(frame.icon)
            frame.icon.texture = texture
            frame.icon:SetPoint("BOTTOM", frame, "TOP", 0, 0)
        end
        if frame["UnitFrame"] and frame["UnitFrame"]["displayedUnit"] then
            if Codex.targetList[frame["UnitFrame"]["name"]:GetText()] then
                frame.icon:Show()
            else
                frame.icon:Hide()
            end
        end
    end
end



Codex.Quest.EventFrame = CreateFrame("Frame")
Codex.Quest.EventFrame:RegisterEvent("ADDON_LOADED")
Codex.Quest.EventFrame:RegisterEvent("ZONE_CHANGED")
Codex.Quest.EventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
Codex.Quest.EventFrame:RegisterEvent("QUEST_REMOVED")
Codex.Quest.EventFrame:RegisterEvent("QUEST_ACCEPTED")
Codex.Quest.EventFrame:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
Codex.Quest.EventFrame:RegisterEvent("GOSSIP_SHOW")
Codex.Quest.EventFrame:RegisterEvent("QUEST_DETAIL")
Codex.Quest.EventFrame:RegisterEvent("QUEST_PROGRESS")
Codex.Quest.EventFrame:RegisterEvent("QUEST_COMPLETE")
Codex.Quest.EventFrame:RegisterEvent("QUEST_GREETING")
Codex.Quest.EventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
Codex.Quest.EventFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")

Codex.Quest.EventFrame:SetScript("OnEvent", function(self, event, ...)
    if (event == "ADDON_LOADED") then
        local arg1, arg2, arg3, arg4, arg5 = ...;

        if (arg1 == "ClassicCodex") then
            Codex.Quest.UpdateQuestList()
        end

    elseif (event == "ZONE_CHANGED") then
        Codex.Quest.UpdateQuestList()

    elseif (event == "ZONE_CHANGED_NEW_AREA") then
        Codex.Quest.UpdateQuestList()

    elseif (event == "QUEST_REMOVED") then
        Codex.Quest.UpdateQuestList()

    elseif (event == "QUEST_ACCEPTED") then
        Codex.Quest.UpdateQuestList()

    elseif (event == "UNIT_QUEST_LOG_CHANGED") then
        local arg1, arg2, arg3, arg4 = ...;
        if arg1 == "player" then
            Codex.Quest.UpdateQuestList()
        end

    elseif (event == "GOSSIP_SHOW") then
        if (IsControlKeyDown()) then
            return 
        end

        local activeQuests = {GetGossipActiveQuests()}
        local activeQuestCount = GetNumGossipActiveQuests()
        local availableQuests = {GetGossipAvailableQuests()}
        local availableQuestCount = GetNumGossipAvailableQuests()

        local index

        -- Turn in everything
        if (activeQuests and not IsControlKeyDown()) then
            for index = 1, activeQuestCount do
                if (activeQuests[(((index - 1) * 6) + 4)] == true) then -- Check if quest complete
                    SelectGossipActiveQuest(index)
                end
            end
        end

        if (availableQuestCount > 0 and not IsControlKeyDown()) then
            SelectGossipAvailableQuest(1)
        end

        -- Auto Gossip Feature
        -- SelectGossipOption(1)

    elseif (event == "QUEST_DETAIL") then
        if (IsControlKeyDown()) then
            return
        end

        AcceptQuest()

    elseif (event == "QUEST_PROGRESS") then
        if (IsControlKeyDown()) then
            return
        end

        CompleteQuest()
        
    elseif (event == "QUEST_COMPLETE") then
        if (IsControlKeyDown()) then
            return
        end

        if (GetNumQuestChoices() <= 1) then
            GetQuestReward(1)
        end

    elseif (event == "QUEST_GREETING") then
        if (IsControlKeyDown()) then
            return
        end

        local availableQuestCount = GetNumAvailableQuests()
        local lastAvailableQuest = 0
        local activeQuestCount = GetNumActiveQuests()
        local lastActiveQuest = 0
        
        if availableQuestCount > 0 then
            for index = 1, availableQuestCount do
                if not IsControlKeyDown() then
                    SelectAvailableQuest(index)
                end
            end
        end

        if activeQuestCount > 0 then
            for index = 1, activeQuestCount do
                for questID, quest in pairs(Codex.QuestLog) do
                    if GetActiveTitle(index) == quest["name"] and quest["isComplete"] == true then
                        SelectActiveQuest(index)
                    end
                end
            end

        end

    elseif (event == "NAME_PLATE_UNIT_ADDED") then
        Codex.CheckNamePlate()
    end
    end)
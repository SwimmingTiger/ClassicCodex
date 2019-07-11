SLASH_CODEX1, SLASH_CODEX2 = "/codex", "/classiccodex"
SlashCmdList["CODEX"] = function(input, editBox)
    local params = {}
    local meta = {["addon"] = "CODEX"}

    if (input == "" or input == nil) then
        print("Classic Codex (v" .. tostring(GetAddOnMetadata("ClassicCodex", "Version")) .. "):")
        print("|cff33ffcc/codex|cffffffff unit <unit> |cffcccccc - Search units")
        print("|cff33ffcc/codex|cffffffff object <gameObject> |cffcccccc - Search objects")
        print("|cff33ffcc/codex|cffffffff item <item> |cffcccccc - Search items")
        print("|cff33ffcc/codex|cffffffff vendor <item> |cffcccccc - Search vendors for item")
        print("|cff33ffcc/codex|cffffffff quest <questName> |cffcccccc - Show specific quest giver")
        print("|cff33ffcc/codex|cffffffff quests |cffcccccc - Show all quests on the map")
        print("|cff33ffcc/codex|cffffffff clean |cffcccccc - Clean map")
        print("|cff33ffcc/codex|cffffffff reset |cffcccccc - Reset map")
        return
    end

    local commandList = {}
    local command

    for command in string.gmatch(input, "[^ ]+") do
        table.insert(commandList, command)
    end

    local arg1, arg2 = commandList[1], ""

    for i in pairs(commandList) do
        if i ~= 1 then
            arg2 = arg2 .. commandList[i]
            if commandList[i + 1] ~= nil then
                arg2 = arg2 .. " "
            end
        end
    end

    if arg1 == "unit" then
        local maps = CodexDatabase:SearchUnitByName(arg2, meta, "LOWER", true)
        CodexMap:ShowMapId(CodexDatabase:GetBestMap(maps))
        return
    end

    if arg1 == "object" then
        local maps = CodexDatabase:SearchObjectByName(arg2, meta, "LOWER", true)
        CodexMap:ShowMapId(CodexDatabase:GetBestMap(maps))
        return
    end

    if arg1 == "item" then
        local maps = CodexDatabase:SearchItemByName(arg2, meta, "LOWER", true)
        CodexMap:ShowMapId(CodexDatabase:GetBestMap(maps))
        return
    end

    if arg1 == "vendor" then
        local maps = CodexDatabase:SearchVendorByItemName(arg2, meta, true)
        CodexMap:ShowMapId(CodexDatabase:GetBestMap(maps))
        return
    end

    if arg1 == "quest" then
        local maps = CodexDatabase:SearchQuestByName(arg2, meta, "LOWER", true)
        CodexMap:ShowMapId(CodexDatabase:GetBestMap(maps))
        return
    end

    if arg1 == "quests" then
        local maps = CodexDatabase:SearchQuests(meta)
        CodexMap:UpdateNodes()
        return
    end

    if arg1 == "clean" then
        CodexMap:DeleteNode("CODEX")
        CodexMap:UpdateNodes()
        return
    end

    if arg1 == "reset" then
        CodexQuest:ResetAll()
    end
end
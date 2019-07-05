SLASH_CODEX1 = "/codex"
SlashCmdList["CODEX"] = function(input, editBox)
    local params = {}
    local meta = {["addon"] = "CODEX"}

    if (input == "" or input == nil) then
        DEFAULT_CHAT_FRAME:AddMessage("Tu suces")
        return
    end

    local commandList = {}
    local command

    for command in string.gmatch(input, "[^ ]+") do
        table.insert(commandList, command)
    end

    local arg1, arg2 = commandList[1], ""

    if arg1 == "config" then
        if codexConfig then codexConfig:Show() end
        return
    end
end
-- Convert Questie locale data to ClassicCodex locale data

local keyName = arg[1]
local lang = arg[2]
local file = arg[3]

function GetLocale()
    return lang
end

function escapeString(str)
    return string.gsub(string.gsub(str or "", "\n", '\\n'), '"', '\\"')
end

QuestieLoader = {
    ["data"] = {
        [keyName] = {},
    }
}
QuestieLoader.ImportModule = function(self, module)
    return self.data
end

dofile(file)

local keyMap = {
    ["itemLookup"] = "items",
    ["npcNameLookup"] = "units",
    ["objectLookup"] = "objects",
    ["questLookup"] = "quests",
}

print(string.format('CodexDB["%s"]["%s"]={', keyMap[keyName], lang))

local data = QuestieLoader.data[keyName][lang]
local index = {}

for id in pairs(data) do
    table.insert(index, id)
end

table.sort(index)

for _, id in ipairs(index) do
    local value = data[id]
    if keyName == 'npcNameLookup' then
        print(string.format('[%d]="%s",', id, escapeString(value[1])))
    elseif keyName == 'questLookup' then
        print(string.format('[%d]={', id))
        print(string.format('["D"]="%s",', escapeString(table.concat(value[2] or {}, "\n"))))
        print(string.format('["O"]="%s",', escapeString(table.concat(value[3] or {}, "\n"))))
        print(string.format('["T"]="%s",', escapeString(value[1])))
        print('},')
    else
        print(string.format('[%d]="%s",', id, escapeString(value)))
    end
end

print('}')

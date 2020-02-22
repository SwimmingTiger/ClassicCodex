local json = dofile('./utils/dkjson.lua')
dofile('./utils/utils.lua')

dofile('./load-db.lua')

local ids = {}
for i, v in pairs(CodexDB.units.data) do
   if not v.coords or #v.coords == 0 then
      table.insert(ids, i)
   end
end

table.sort(ids)

for _, id in ipairs(ids) do
    local url = string.format('https://classic.wowhead.com/npc=%d/', id)

    eprintf("NPC ID: %s, URL: %s", id, url)

    local http = io.popen(string.format("curl -L '%s'", url))
    local body = http:read("*all")

    local npcInfoJSON = string.match(body, '<script type="application/ld%+json">([^<]*)</script>')
    local coordsJSON = string.match(body, 'var g_mapperData = ({[^;]*});')

    local npcInfo = json.decode(npcInfoJSON or "") or { name = nil }
    local coords = json.decode(coordsJSON or "")

    eprintf("NPC Name: %s", npcInfo.name or "nil")
    eprintf("Coords: %s", coordsJSON or "nil")
    eprintf("")
    
    if coords then
        print()
        printf('-- %s <%s>', npcInfo.name, npcInfo.url)
        printf('D[%d].coords={', id)

        for mapID, arr in pairs(coords) do
            for _, v in ipairs(arr) do
                for _, coord in ipairs(v.coords) do
                    printf('  {%0.1f,%0.1f,%d,0}', coord[1], coord[2], mapID)
                end
            end
        end

        print('}')
    end
end

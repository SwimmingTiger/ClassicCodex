dofile('./load-db.lua')

local ids = {}
for i, v in pairs(CodexDB.units.data) do
   if not v.coords or #v.coords == 0 then
      table.insert(ids, i)
   end
end

table.sort(ids)
print(table.concat(ids, "\n"))

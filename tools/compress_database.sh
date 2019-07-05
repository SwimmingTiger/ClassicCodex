#!/bin/bash
function compress() {
  if ! [ -f $1 ]; then return; fi

  if ! [ "$2" = "nc" ]; then
    sed 's/ --.*//g' -i $1
  fi

  sed 's/  //g' -i $1

  if [ "$2" = "ws" ]; then
    # even remove single whitespaces
    sed 's/ //g' -i $1
  fi

  sed 's/ = /=/g' -i $1
  tr -d '\n' < $1 > /tmp/$(basename $1)
  mv /tmp/$(basename $1) $1
}

echo "===== compressing DB ====="
echo "-> database"
compress db/items.lua ws
compress db/objects.lua ws
compress db/units.lua ws
compress db/quests.lua ws
compress db/meta.lua ws

compress db/itemNames.lua
compress db/objectNames.lua
compress db/questNames.lua nc
compress db/unitNames.lua
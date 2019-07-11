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
compress db/refloot.lua ws

compress db/enUS/items.lua
compress db/enUS/objects.lua
compress db/enUS/quests.lua nc
compress db/enUS/units.lua
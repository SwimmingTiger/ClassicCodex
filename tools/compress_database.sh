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
  mkdir -p $3; mv /tmp/$(basename $1) $3/$(basename $1)
}

echo "===== compressing DB (Vanilla) ====="
echo "-> database"
compress decompressed_db/items.lua ws db
compress decompressed_db/refloot.lua ws db
compress decompressed_db/objects.lua ws db
compress decompressed_db/units.lua ws db
compress decompressed_db/quests.lua ws db
compress decompressed_db/meta.lua ws db
cp decompressed_db/init.lua db

echo "-> locales"
for loc in decompressed_db/*/; do
  compress $loc/items.lua "" db/$(basename $loc)
  compress $loc/objects.lua "" db/$(basename $loc)
  compress $loc/professions.lua "" db/$(basename $loc)
  compress $loc/quests.lua nc db/$(basename $loc)
  compress $loc/units.lua "" db/$(basename $loc)
  compress $loc/zones.lua "" db/$(basename $loc)
done

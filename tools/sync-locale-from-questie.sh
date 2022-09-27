#!/bin/bash
if [ "$1" = "" ]; then
    echo "Usage: $0 /path/to/Questie"
    exit 1
fi

BASE_DIR="$(dirname "$(dirname "$(realpath "$0")")")"
QUESTIE_DIR="$(realpath "$1")"


# items
ls "$QUESTIE_DIR/Localization/lookups/Classic/lookupItems/ptBR.lua" | while read f; do
    lang="${f##*/}"
    lang="${lang%.*}"
    dst="$BASE_DIR/ClassicCodex-db-$lang/items.lua"
    lua "$BASE_DIR/tools/lua/convert-questie-locale.lua" itemLookup "$lang" "$f" > "$dst"
done
ls "$QUESTIE_DIR/Localization/lookups/Wotlk/lookupItems/"*".lua" | while read f; do
    lang="${f##*/}"
    lang="${lang%.*}"
    dst="$BASE_DIR/ClassicCodex-db-$lang/items-tbc.lua"
    lua "$BASE_DIR/tools/lua/convert-questie-locale.lua" itemLookup "$lang" "$f" > "$dst"
done

# units
ls "$QUESTIE_DIR/Localization/lookups/Classic/lookupNpcs/ptBR.lua" | while read f; do
    lang="${f##*/}"
    lang="${lang%.*}"
    dst="$BASE_DIR/ClassicCodex-db-$lang/units.lua"
    lua "$BASE_DIR/tools/lua/convert-questie-locale.lua" npcNameLookup "$lang" "$f" > "$dst"
done
ls "$QUESTIE_DIR/Localization/lookups/Wotlk/lookupNpcs/"*".lua" | while read f; do
    lang="${f##*/}"
    lang="${lang%.*}"
    dst="$BASE_DIR/ClassicCodex-db-$lang/units-tbc.lua"
    lua "$BASE_DIR/tools/lua/convert-questie-locale.lua" npcNameLookup "$lang" "$f" > "$dst"
done

# objects
ls "$QUESTIE_DIR/Localization/lookups/Classic/lookupObjects/ptBR.lua" | while read f; do
    lang="${f##*/}"
    lang="${lang%.*}"
    dst="$BASE_DIR/ClassicCodex-db-$lang/objects.lua"
    lua "$BASE_DIR/tools/lua/convert-questie-locale.lua" objectLookup "$lang" "$f" > "$dst"
done
ls "$QUESTIE_DIR/Localization/lookups/Wotlk/lookupObjects/"*".lua" | while read f; do
    lang="${f##*/}"
    lang="${lang%.*}"
    dst="$BASE_DIR/ClassicCodex-db-$lang/objects-tbc.lua"
    lua "$BASE_DIR/tools/lua/convert-questie-locale.lua" objectLookup "$lang" "$f" > "$dst"
done

# quests
ls "$QUESTIE_DIR/Localization/lookups/Classic/lookupQuests/ptBR.lua" | while read f; do
    lang="${f##*/}"
    lang="${lang%.*}"
    dst="$BASE_DIR/ClassicCodex-db-$lang/quests.lua"
    lua "$BASE_DIR/tools/lua/convert-questie-locale.lua" questLookup "$lang" "$f" > "$dst"
done
ls "$QUESTIE_DIR/Localization/lookups/Wotlk/lookupQuests/"*".lua" | while read f; do
    lang="${f##*/}"
    lang="${lang%.*}"
    dst="$BASE_DIR/ClassicCodex-db-$lang/quests-tbc.lua"
    lua "$BASE_DIR/tools/lua/convert-questie-locale.lua" questLookup "$lang" "$f" > "$dst"
done

#!/bin/bash
cd "$(dirname "$0")"

if [ "x$1" = "x" ]; then
    echo "Usage:"
    echo "    $0 'xxxxxx/World of Warcraft/_classic_/WTF/Account/xxxxxxxxxxxxx#xxx\SavedVariables/MergeQuestieToCodexDB.lua'"
    exit 1
fi

mkdir -p ../db-patches/tmp

{
    cat "$1"
    echo 'print(table.concat(CodexDatabasePatch.quest, "\n"))'
} | lua > ../db-patches/quests-patch.lua

{
    cat "$1"
    echo 'print(table.concat(CodexDatabasePatch.unitHorde, "\n"))'
} | lua > ../db-patches/tmp/units-horde.lua

{
    cat "$1"
    echo 'print(table.concat(CodexDatabasePatch.unitAlliance, "\n"))'
} | lua > ../db-patches/tmp/units-alliance.lua

cp ../db-patches/tmp/units-horde.lua ../db-patches/units-patch.lua

echo diff db-patches/tmp/units-horde.lua db-patches/tmp/units-alliance.lua
diff ../db-patches/tmp/units-horde.lua ../db-patches/tmp/units-alliance.lua

#!/bin/bash
cd "$(dirname "$0")"

if [ "x$1" = "x" ]; then
    echo "Usage:"
    echo "    $0 'xxxxxx/World of Warcraft/_classic_/WTF/Account/xxxxxxxxxxxxx#xxx\SavedVariables/MergeQuestieToCodexDB.lua'"
    exit 1
fi

mkdir -p ../ClassicCodex-patch/tmp

{
    cat "$1"
    echo 'print(table.concat(CodexDatabasePatch.quest, "\n"))'
} | lua > ../ClassicCodex-patch/quests-questie-wotlk.lua

{
    cat "$1"
    echo 'print(table.concat(CodexDatabasePatch.unitHorde, "\n"))'
} | lua > ../ClassicCodex-patch/tmp/units-horde-wotlk.lua

{
    cat "$1"
    echo 'print(table.concat(CodexDatabasePatch.unitAlliance, "\n"))'
} | lua > ../ClassicCodex-patch/tmp/units-alliance-wotlk.lua

{
    cat "$1"
    echo 'print(table.concat(CodexDatabasePatch.objectHorde, "\n"))'
} | lua > ../ClassicCodex-patch/tmp/objects-horde-wotlk.lua

{
    cat "$1"
    echo 'print(table.concat(CodexDatabasePatch.objectAlliance, "\n"))'
} | lua > ../ClassicCodex-patch/tmp/objects-alliance-wotlk.lua

cp ../ClassicCodex-patch/tmp/units-horde-wotlk.lua ../ClassicCodex-patch/units-questie-wotlk.lua

echo diff ClassicCodex-patch/tmp/units-horde-wotlk.lua ClassicCodex-patch/tmp/units-alliance-wotlk.lua
diff ../ClassicCodex-patch/tmp/units-horde-wotlk.lua ../ClassicCodex-patch/tmp/units-alliance-wotlk.lua

cp ../ClassicCodex-patch/tmp/objects-horde-wotlk.lua ../ClassicCodex-patch/objects-questie-wotlk.lua

echo diff ClassicCodex-patch/tmp/objects-horde-wotlk.lua ClassicCodex-patch/tmp/objects-alliance-wotlk.lua
diff ../ClassicCodex-patch/tmp/objects-horde-wotlk.lua ../ClassicCodex-patch/tmp/objects-alliance-wotlk.lua

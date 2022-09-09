#!/bin/bash
cd "$(dirname "$0")"

if [ "x$1" = "x" ]; then
    echo "Usage:"
    echo "    $0 'xxxxxx/World of Warcraft/_classic_era_/WTF/Account/xxxxxxxxxxxxx#xxx\SavedVariables/MergeQuestieToCodexDB.lua'"
    exit 1
fi

mkdir -p ../ClassicCodex-patch/tmp

{
    cat "$1"
    echo 'print(table.concat(CodexDatabasePatch.quest, "\n"))'
} | lua > ../ClassicCodex-patch/quests-questie.lua

{
    cat "$1"
    echo 'print(table.concat(CodexDatabasePatch.unitHorde, "\n"))'
} | lua > ../ClassicCodex-patch/tmp/units-horde.lua

{
    cat "$1"
    echo 'print(table.concat(CodexDatabasePatch.unitAlliance, "\n"))'
} | lua > ../ClassicCodex-patch/tmp/units-alliance.lua

{
    cat "$1"
    echo 'print(table.concat(CodexDatabasePatch.objectHorde, "\n"))'
} | lua > ../ClassicCodex-patch/tmp/objects-horde.lua

{
    cat "$1"
    echo 'print(table.concat(CodexDatabasePatch.objectAlliance, "\n"))'
} | lua > ../ClassicCodex-patch/tmp/objects-alliance.lua

{
    cat "$1"
    echo 'print(table.concat(CodexDatabasePatch.objectLoc, "\n"))'
} | lua > ../ClassicCodex-patch/objects-loc.lua

cp ../ClassicCodex-patch/tmp/units-horde.lua ../ClassicCodex-patch/units-questie.lua

echo diff ClassicCodex-patch/tmp/units-horde.lua ClassicCodex-patch/tmp/units-alliance.lua
diff ../ClassicCodex-patch/tmp/units-horde.lua ../ClassicCodex-patch/tmp/units-alliance.lua

cp ../ClassicCodex-patch/tmp/objects-horde.lua ../ClassicCodex-patch/objects-questie.lua

echo diff ClassicCodex-patch/tmp/objects-horde.lua ClassicCodex-patch/tmp/objects-alliance.lua
diff ../ClassicCodex-patch/tmp/objects-horde.lua ../ClassicCodex-patch/tmp/objects-alliance.lua

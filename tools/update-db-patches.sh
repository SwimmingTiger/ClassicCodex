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
} | lua > ../ClassicCodex-patch/quests-questie-tbc.lua

{
    cat "$1"
    echo 'print(table.concat(CodexDatabasePatch.unitHorde, "\n"))'
} | lua > ../ClassicCodex-patch/tmp/units-horde-tbc.lua

{
    cat "$1"
    echo 'print(table.concat(CodexDatabasePatch.unitAlliance, "\n"))'
} | lua > ../ClassicCodex-patch/tmp/units-alliance-tbc.lua

cp ../ClassicCodex-patch/tmp/units-horde-tbc.lua ../ClassicCodex-patch/units-questie-tbc.lua

echo diff ClassicCodex-patch/tmp/units-horde-tbc.lua ClassicCodex-patch/tmp/units-alliance-tbc.lua
diff ../ClassicCodex-patch/tmp/units-horde-tbc.lua ../ClassicCodex-patch/tmp/units-alliance-tbc.lua

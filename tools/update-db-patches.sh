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
    echo 'print(CodexDatabasePatch.quest)'
} | lua > ../db-patches/quests-patch.lua

{
    cat "$1"
    echo 'print(CodexDatabasePatch.unitHorde)'
} | lua > ../db-patches/tmp/units-horde.lua

{
    cat "$1"
    echo 'print(CodexDatabasePatch.unitAlliance)'
} | lua > ../db-patches/tmp/units-alliance.lua

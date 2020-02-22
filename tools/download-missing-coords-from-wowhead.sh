#!/bin/bash
cd "$(dirname "$0")"
cd "./lua"

lua "./download-missing-coords-from-wowhead.lua" >> "../../db-patches/manual-patch.lua"

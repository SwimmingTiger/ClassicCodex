#!/bin/sh
cd "$(dirname "$0")/.."

echo "Packaging classic addon"
bash ./tools/BigWigsMods-release.sh -g 1.13.3

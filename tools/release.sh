#!/bin/sh
cd "$(dirname "$0")/.."

echo "Packaging TBC classic addon"
bash ./tools/BigWigsMods-release.sh -g bc

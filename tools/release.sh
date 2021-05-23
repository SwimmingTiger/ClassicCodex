#!/bin/sh
cd "$(dirname "$0")/.."

echo "Packaging addon for classic 60"
bash ./tools/BigWigsMods-release.sh -u -g classic

echo "Packaging addon for classic TBC"
bash ./tools/BigWigsMods-release.sh -u -g bc

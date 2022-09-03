#!/bin/sh
cd "$(dirname "$0")/.."

echo "Packaging addon for classic WotLK"
bash ./tools/BigWigsMods-release.sh -u -g wrath

#!/bin/bash

THIS_FILE="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$THIS_FILE")"
BASE_DIR="$(cd "$SCRIPT_DIR"/.. && pwd)"
eval "$(cat ~/.bashrc | tail -n +20)"

cd "$BASE_DIR" || exit

npm run start

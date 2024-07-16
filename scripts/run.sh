#!/bin/bash

THIS_FILE="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$THIS_FILE")"
BASE_DIR="$(cd "$SCRIPT_DIR"/.. && pwd)"

cd "$BASE_DIR" || exit

npm run start

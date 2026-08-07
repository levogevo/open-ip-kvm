#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
REPO_DIR="${SCRIPT_DIR}/.."

SERVICE_NAME='open-ip-kvm.service'
SERVICE_PATH='/etc/systemd/system'

echo "[Unit]
Description=Start open-ip-kvm
After=network.target

[Service]
Type=simple
User=${USER}
WorkingDirectory=${HOME}
ExecStart=${REPO_DIR}/scripts/run.sh

[Install]
WantedBy=multi-user.target
" | sudo tee "${SERVICE_PATH}/${SERVICE_NAME}"

sudo systemctl enable --now "${SERVICE_NAME}"

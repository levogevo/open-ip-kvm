#!/bin/bash

THIS_FILE="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$THIS_FILE")"
RUN_SCRIPT="$SCRIPT_DIR/run.sh"

SERVICE_NAME='open-ip-kvm.service'
SERVICE_PATH='/etc/systemd/system'

cat <<EOF > "/tmp/$SERVICE_NAME"
[Unit]
Description=Start open-ip-kvm

[Service]
ExecStart=$RUN_SCRIPT

[Install]
WantedBy=multi-user.target
EOF

sudo cp "/tmp/$SERVICE_NAME" "$SERVICE_PATH/$SERVICE_NAME"
sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl start "$SERVICE_NAME"

exit 0

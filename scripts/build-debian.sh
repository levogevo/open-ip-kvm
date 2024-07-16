#!/bin/bash

THIS_FILE="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$THIS_FILE")"
BASE_DIR="$(cd "$SCRIPT_DIR"/.. && pwd)"

check-app() {
    APP="$1"
    script -qec "$APP --version" > /dev/null ; return $?
}

PKGS='cmake libv4l-dev'

USING_NALA=$(check-app nala ; echo $?)
USING_APT=$(check-app apt ; echo $?)

if [[ "$USING_NALA" == "0" ]]; then
  # if nala fails, try apt
  USING_APT="1"
  echo "Installing with nala"
  sudo nala install -y $PKGS || USING_APT="0"
fi
if [[ "$USING_APT" == "0" ]]; then
  echo "Installing with apt"
  sudo apt-get install -y $PKGS || exit 1
fi

# node the "bad" way

eval "$(cat ~/.bashrc | tail -n +10)"
check-app fnm || curl -fsSL https://fnm.vercel.app/install | bash
eval "$(cat ~/.bashrc | tail -n +10)"
check-app node || fnm use --install-if-missing 20 

# if mjpg isn't downloaded already
cd "$BASE_DIR" || exit
git submodule update --init --recursive -f
cd "$BASE_DIR/mjpg-streamer/mjpg-streamer-experimental" || exit
make -j$(nproc)
sudo make install

cd "$BASE_DIR" || exit
npm install

exit 0

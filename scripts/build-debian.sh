#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
REPO_DIR="${SCRIPT_DIR}/.."

# debian naming
REQ_PKGS=(
	gcc
	g++
	cmake
	libv4l-dev
	unzip
	zip
	nodejs
	npm
)

missing_required_pkg() {
	for pkg in "${REQ_PKGS[@]}"; do
		dpkg -l "${pkg}" &>/dev/null || return 0
	done

	return 1
}

have_cmd() {
	for cmd in "$@"; do
		command -v "${cmd}" &>/dev/null || return 1
	done
}

if missing_required_pkg; then
	sudo apt-get install -y "${REQ_PKGS[@]}"
fi

if ! have_cmd mjpg_streamer; then
	git -C "${REPO_DIR}" submodule update --init --recursive -f
	cmake \
		-DCMAKE_BUILD_TYPE=Release \
		-B build \
		-S "${REPO_DIR}/mjpg-streamer/mjpg-streamer-experimental"
	cmake \
		--build build \
		--parallel "$(nproc)"
	sudo cmake \
		--install build
fi

if [[ "$(node --version)" != 'v20.'* ]]; then
	have_cmd fnm || curl -fsSL https://fnm.vercel.app/install | bash
	have_cmd fnm || source ~/.bashrc
	fnm use --install-if-missing 20
fi

cd "${REPO_DIR}" || exit
npm install

# for serial permissions
if [[ "$(groups)" != *'dialout'* ]]; then
	sudo usermod -aG dialout "${USER}"
fi

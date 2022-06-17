#!/usr/bin/env bash
set -euo pipefail

SANDBOX_DIR="/tmp/muscst-sandbox"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ ! -f "${SANDBOX_DIR}/usr/bin/mutter" ]; then
    echo "==> Extracting mutter-muscst package to ${SANDBOX_DIR}..."
    mkdir -p "${SANDBOX_DIR}"
    tar -xf "${ROOT_DIR}"/mutter-muscst-[0-9]*.pkg.tar.zst -C "${SANDBOX_DIR}"
fi

echo "==> Launching isolated nested Mutter session..."
echo "==> Press [Ctrl + C] or close the window to exit."

LD_PRELOAD="${SANDBOX_DIR}/usr/lib/mutter-18/libmutter-clutter-18.so.0:${SANDBOX_DIR}/usr/lib/libmutter-18.so.0" \
dbus-run-session "${SANDBOX_DIR}/usr/bin/mutter" --wayland "$@"

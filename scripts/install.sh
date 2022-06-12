#!/usr/bin/env bash
# ==============================================================================
# mutter-muscst development installation script
# Safely backs up current system Mutter and installs the patched package.
# WARNING: For isolated development testbeds/VMs only.
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "==> [DEVELOPMENT PROTOTYPE] mutter-muscst Installer"
echo "NOTE: This tool is in active development. Intended only for isolated test VMs."
cd "${ROOT_DIR}"

shopt -s nullglob
PACKAGE_FILES=("${ROOT_DIR}"/mutter-muscst-*.pkg.tar.zst)
shopt -u nullglob

if [ ${#PACKAGE_FILES[@]} -eq 0 ]; then
    echo "ERROR: Built package file not found. Run ./scripts/build.sh first." >&2
    exit 1
fi

PACKAGE_FILE="${PACKAGE_FILES[-1]}"
echo "Found package: ${PACKAGE_FILE}"

CONFIG_DIR="${HOME}/.config/muscst"
mkdir -p "${CONFIG_DIR}"
if [ ! -f "${CONFIG_DIR}/state.json" ]; then
    echo "Creating default configuration at ${CONFIG_DIR}/state.json..."
    cp "${ROOT_DIR}/config/state.json.example" "${CONFIG_DIR}/state.json"
fi

echo "Backing up current official package reference..."
mkdir -p "${ROOT_DIR}/backup"
pacman -Q mutter > "${ROOT_DIR}/backup/previous_mutter_version.txt" || true

echo "Installing patched mutter-muscst package..."
sudo pacman -U --noconfirm "${PACKAGE_FILE}"

echo ""
echo "==> [SUCCESS] mutter-muscst test package installed."
echo "Manage screencast buffer exclusion with: muscst (or muscst --help)"
echo "Please log out and log back in to activate the modified GNOME Shell session."
echo "To revert to official upstream Mutter at any time, run: ./scripts/rollback.sh"

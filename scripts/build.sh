#!/usr/bin/env bash
# ==============================================================================
# muscst build script
# Performs a non-invasive build using makepkg inside the project tree.
# Does NOT install or modify root system files.
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "==> [muscst] Starting isolated build in: ${ROOT_DIR}"
cd "${ROOT_DIR}"

# Check required build dependencies
MISSING_DEPS=()
for tool in makepkg git gcc; do
    if ! command -v "${tool}" &>/dev/null; then
        MISSING_DEPS+=("${tool}")
    fi
done

if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
    echo "ERROR: Missing required build utilities: ${MISSING_DEPS[*]}" >&2
    echo "Please install them via: sudo pacman -S --needed base-devel git" >&2
    exit 1
fi

echo "==> Compiling muscst with makepkg..."
makepkg -s --noconfirm --clean

echo ""
echo "==> [SUCCESS] Package build completed!"
echo "Generated package: $(ls -1 "${ROOT_DIR}"/*.pkg.tar.zst 2>/dev/null || echo 'Check root directory')"
echo "To install, execute: ./scripts/install.sh"

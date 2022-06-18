#!/usr/bin/env bash
# ==============================================================================
# muscst emergency rollback script
# Immediately restores upstream official Arch Linux Mutter package.
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "==> [EMERGENCY ROLLBACK] Restoring official Arch Linux Mutter..."

shopt -s nullglob
BACKUP_FILES=("${ROOT_DIR}"/backup/mutter-[0-9]*.pkg.tar.zst)
shopt -u nullglob

if [ ${#BACKUP_FILES[@]} -gt 0 ]; then
    echo "Found local offline backup: ${BACKUP_FILES[0]}"
    echo "==> Confirm 'y' when pacman prompts to remove conflicting package:"
    sudo pacman -U "${BACKUP_FILES[0]}"
else
    echo "Local backup not found, restoring from Arch repositories..."
    echo "==> Confirm 'y' when pacman prompts to remove conflicting package:"
    sudo pacman -S mutter
fi

echo ""
echo "==> [SUCCESS] Official Mutter restored."
echo "Restarting display manager or session..."
if systemctl is-active --quiet gdm; then
    sudo systemctl restart gdm || true
fi

#!/usr/bin/env bash
# ==============================================================================
# muscst emergency rollback script
# Immediately restores upstream official Arch Linux Mutter package.
# ==============================================================================

set -euo pipefail

echo "==> [EMERGENCY ROLLBACK] Restoring official Arch Linux Mutter..."
sudo pacman -S --noconfirm mutter

echo ""
echo "==> [SUCCESS] Official Mutter restored."
echo "Please log out and log back in to reload standard GNOME Shell."

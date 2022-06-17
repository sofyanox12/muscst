#!/usr/bin/env bash
# ==============================================================================
# In-container automated testing runner
# ==============================================================================

set -euo pipefail

echo "==> [test] Locating built package..."
shopt -s nullglob
PACKAGE_FILES=(/workspace/mutter-muscst-[0-9]*.pkg.tar.zst)
shopt -u nullglob

if [ ${#PACKAGE_FILES[@]} -eq 0 ]; then
    echo "ERROR: Built package not found in /workspace. Run ./scripts/build-isolated.sh first." >&2
    exit 1
fi

PACKAGE_FILE="${PACKAGE_FILES[-1]}"
echo "==> [test] Installing package: ${PACKAGE_FILE}"
sudo pacman -U --noconfirm "${PACKAGE_FILE}"

echo "==> [test] Initializing test state..."
mkdir -p "${HOME}/.config/muscst"
cp /workspace/config/state.json.example "${HOME}/.config/muscst/state.json"

echo "==> [test] Testing CLI controller operations..."
/workspace/bin/muscst status
/workspace/bin/muscst add "org.gnome.Terminal"
/workspace/bin/muscst off
/workspace/bin/muscst on
/workspace/bin/muscst remove "kitty"

echo "==> [test] Validating Mutter headless initialization..."
export XDG_RUNTIME_DIR="/tmp/runtime-$(id -u)"
mkdir -p -m 0700 "${XDG_RUNTIME_DIR}"
dbus-run-session mutter --headless --virtual-monitor 1280x720 --wayland &
MUTTER_PID=$!
sleep 3

if kill -0 "${MUTTER_PID}" 2>/dev/null; then
    echo "==> [SUCCESS] Mutter with muscst screencast patch initialized successfully in headless mode!"
    kill "${MUTTER_PID}" 2>/dev/null || true
else
    echo "ERROR: Mutter process died or crashed." >&2
    exit 1
fi

echo "==> [PASS] All isolated tests completed successfully!"

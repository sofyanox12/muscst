#!/usr/bin/env bash
# ==============================================================================
# muscst isolated build script via Docker container
# Builds the mutter-muscst package without installing build dependencies on host.
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "==> [muscst] Preparing isolated Arch build environment..."
ln -sf patches/0001-screencast-window-exclusion.patch "${ROOT_DIR}/0001-screencast-window-exclusion.patch"
ln -sf bin/muscst "${ROOT_DIR}/muscst"
ln -sf config/state.json.example "${ROOT_DIR}/state.json.example"
docker build -t muscst-builder -f "${ROOT_DIR}/Dockerfile.build" "${ROOT_DIR}"

echo "==> [muscst] Compiling package inside container..."
docker run --rm -v "${ROOT_DIR}:/workspace" -w /workspace muscst-builder

echo ""
echo "==> [SUCCESS] Package built cleanly without host pollution!"
ls -lh "${ROOT_DIR}"/*.pkg.tar.zst 2>/dev/null || true

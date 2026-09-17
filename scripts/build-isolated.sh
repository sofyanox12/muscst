#!/usr/bin/env bash
# ==============================================================================
# muscst isolated build script via Docker container
# Builds the mutter-muscst package without installing build dependencies on host.
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "==> [muscst] Preparing isolated Arch build environment..."
docker build -t muscst-builder -f "${ROOT_DIR}/Dockerfile.build" "${ROOT_DIR}"

echo "==> [muscst] Compiling package inside container..."
docker run --rm -v "${ROOT_DIR}:/workspace" -w /workspace muscst-builder

echo ""
echo "==> [SUCCESS] Package built cleanly without host pollution!"
ls -lh "${ROOT_DIR}"/*.pkg.tar.zst 2>/dev/null || true

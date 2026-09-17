#!/usr/bin/env bash
# ==============================================================================
# muscst isolated test runner via Docker container
# Tests mutter installation, CLI, and headless execution safely without touching host.
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "==> [muscst] Preparing isolated test environment..."
docker build -t muscst-tester -f "${ROOT_DIR}/Dockerfile.test" "${ROOT_DIR}"

echo "==> [muscst] Running test suite inside isolated container..."
docker run --rm -v "${ROOT_DIR}:/workspace" -w /workspace muscst-tester

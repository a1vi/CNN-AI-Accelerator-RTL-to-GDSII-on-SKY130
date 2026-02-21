#!/usr/bin/env bash
# ============================================================
#  Lint RTL with Verilator (lint-only, no simulation)
#  Usage: bash scripts/lint.sh
# ============================================================
set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Linting with Verilator..."
verilator --lint-only -Wall \
    --top-module ai_accel \
    "$REPO_ROOT/src/mac.v" \
    "$REPO_ROOT/src/mac_array.v" \
    "$REPO_ROOT/src/ai_accel.v"

echo "==> Lint PASSED"

#!/usr/bin/env bash
# ============================================================
#  Simulate ai_accel with Icarus Verilog
#  Usage: bash scripts/sim.sh
# ============================================================
set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SIM_DIR="$REPO_ROOT/sim"
mkdir -p "$SIM_DIR"

echo "==> Compiling..."
iverilog -g2012 \
    -o "$SIM_DIR/sim" \
    "$REPO_ROOT/tb/tb_ai_accel.v" \
    "$REPO_ROOT/src/mac.v" \
    "$REPO_ROOT/src/mac_array.v" \
    "$REPO_ROOT/src/ai_accel.v"

echo "==> Running simulation..."
cd "$SIM_DIR" && ./sim

echo "==> Waveform written to sim/waves.vcd"
echo "    View with: gtkwave sim/waves.vcd"

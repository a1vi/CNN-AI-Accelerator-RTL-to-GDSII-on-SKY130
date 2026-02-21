#!/usr/bin/env bash
# ============================================================
#  Run full OpenLane RTL-to-GDSII flow for ai_accel
#  Prerequisites: OpenLane installed at ~/OpenLane
#  Usage: bash scripts/run_openlane.sh
# ============================================================
set -e

OPENLANE_ROOT="${OPENLANE_ROOT:-$HOME/OpenLane}"
DESIGN="ai_accel"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [ ! -d "$OPENLANE_ROOT" ]; then
    echo "ERROR: OpenLane not found at $OPENLANE_ROOT"
    echo "  Install: git clone https://github.com/The-OpenROAD-Project/OpenLane.git ~/OpenLane"
    echo "  Then:    cd ~/OpenLane && make && make pdk"
    exit 1
fi

echo "==> Syncing design files into OpenLane..."
DEST="$OPENLANE_ROOT/designs/$DESIGN"
mkdir -p "$DEST/src"

cp "$REPO_ROOT/src/"*.v             "$DEST/src/"
cp "$REPO_ROOT/openlane/$DESIGN/config.tcl" "$DEST/"

echo "==> Launching OpenLane flow..."
cd "$OPENLANE_ROOT"
./flow.tcl -design "$DESIGN"

echo ""
echo "==> Flow complete. Artifacts:"
echo "    GDS  : $OPENLANE_ROOT/designs/$DESIGN/runs/*/results/final/gds/$DESIGN.gds"
echo "    DEF  : $OPENLANE_ROOT/designs/$DESIGN/runs/*/results/final/def/$DESIGN.def"
echo "    Timing: $OPENLANE_ROOT/designs/$DESIGN/runs/*/reports/final/summary.rpt"

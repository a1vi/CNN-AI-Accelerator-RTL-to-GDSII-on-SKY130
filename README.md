# CNN AI Accelerator — RTL-to-GDSII on SKY130


![PDK](https://img.shields.io/badge/PDK-SKY130A-blue)
![Flow](https://img.shields.io/badge/Flow-OpenLane-green)
![License](https://img.shields.io/badge/License-Apache_2.0-lightgrey)

> A **4-lane MAC array** AI accelerator core taken from Verilog RTL all the way to a **GDSII** layout using the fully open-source OpenLane / OpenROAD flow on the SkyWater SKY130A process node.

---

## 📐 Architecture

```
         ┌─────────────────────────────────────┐
  clk ──►│                                     │
rst_n ──►│           ai_accel (top)            │
start ──►│                                     │
         │  ┌───────────────────────────────┐  │
a[0:3] ─►│  │        mac_array              │  │──► done
b[0:3] ─►│  │  MAC0  MAC1  MAC2  MAC3       │  │──► o[0:3] (32-bit)
         │  │  acc0  acc1  acc2  acc3       │  │
         │  └───────────────────────────────┘  │
         └─────────────────────────────────────┘
```

Each cycle that `start` is high, every MAC unit computes:

```
accN <= accN + aN * bN   (signed 8-bit × 8-bit → added to 32-bit accumulator)
```

`rst_n` (active-low, synchronous) clears all accumulators.

---



## ⚙️ Toolchain

| Stage | Tool |
|---|---|
| RTL | Verilog (IEEE 1364-2005 / SystemVerilog subset) |
| Lint | Verilator |
| Simulation | Icarus Verilog + GTKWave |
| Synthesis | Yosys (via OpenLane) |
| Floorplan / PnR | OpenROAD (via OpenLane) |
| DRC / LVS | Magic + Netgen |
| GDS Viewer | KLayout |
| Flow Orchestrator | OpenLane |
| PDK | SkyWater SKY130A |

---

## 📸 Screenshots

![Screenshot 1](PICS/Screenshot%20from%202026-02-21%2019-23-26.png)
![Screenshot 2](PICS/Screenshot%20from%202026-02-21%2019-24-51.png)
![Screenshot 3](PICS/Screenshot%20from%202026-02-21%2019-35-40.png)

---

## 🚀 Quick Start

### 1 — Clone

```bash
git clone https://github.com/<YOUR_USERNAME>/ai-accel-sky130.git
cd ai-accel-sky130
```

### 2 — Lint (Verilator)

```bash
sudo apt install verilator -y
bash scripts/lint.sh
```

### 3 — Simulate (Icarus Verilog)

```bash
sudo apt install iverilog gtkwave -y
bash scripts/sim.sh
gtkwave sim/waves.vcd          # optional waveform viewer
```

Expected output:
```
==> Compiling...
==> Running simulation...
ALL TESTS PASSED
==> Waveform written to sim/waves.vcd
```

---

## 🏭 RTL-to-GDSII Flow

### Prerequisites

```bash
# Docker (required by OpenLane)
sudo apt install docker.io -y
sudo usermod -aG docker $USER   # log out & back in

# OpenLane
git clone https://github.com/The-OpenROAD-Project/OpenLane.git ~/OpenLane
cd ~/OpenLane
make          # pulls Docker image
make pdk      # installs SKY130A PDK (~2 GB)
```

### Run

```bash
bash scripts/run_openlane.sh
```

The script copies source files into OpenLane's design directory and launches:

```
RTL  →  Synthesis (Yosys)  →  Floorplan  →  Placement  →  CTS  →  Routing  →  DRC/LVS  →  GDSII
```

### Output Artifacts

| File | Description |
|---|---|
| `runs/.../results/final/gds/ai_accel.gds` | Final GDSII layout |
| `runs/.../results/final/def/ai_accel.def` | Detailed placement & routing |
| `runs/.../reports/final/summary.rpt` | Timing / area / power summary |

### View Layout

```bash
# KLayout
klayout runs/<tag>/results/final/gds/ai_accel.gds

# Magic
cd ~/OpenLane
magic -T pdk/sky130A/libs.tech/magic/sky130A.tech \
    designs/ai_accel/runs/<tag>/results/final/gds/ai_accel.gds
```

---

## 📊 Target Specs

| Parameter | Target |
|---|---|
| Process | SKY130A (130 nm) |
| Clock | 100 MHz (10 ns period) |
| Core utilization | 40 % |
| Placement density | 0.50 |
| MAC lanes | 4 |
| Operand width | 8-bit signed |
| Accumulator width | 32-bit signed |

---

## 🧪 Test Coverage

| Test | Stimulus | Checks |
|---|---|---|
| Basic multiply | (2,3), (4,5), (-1,7), (8,-2) | Lane outputs = 6, 20, -7, -16 |
| Accumulation | Second MAC on non-zero accumulators | Values correctly add |
| Reset | Assert `rst_n=0` | All outputs → 0 |

---

## 🔭 Roadmap

- [x] 4-lane MAC array RTL
- [x] Self-checking testbench
- [x] OpenLane config & CI
- [ ] 8×8 systolic MAC array
- [ ] Input/output SRAM ping-pong buffers
- [ ] AXI-Lite control register interface
- [ ] Caravel harness integration (efabless submission)

---

## 📄 License

Apache 2.0 — see [LICENSE](LICENSE)

---

## 🙏 References

- [OpenLane Documentation](https://openlane.readthedocs.io)
- [OpenROAD Project](https://theopenroadproject.org)
- [SkyWater PDK](https://github.com/google/skywater-pdk)
- [efabless Caravel](https://github.com/efabless/caravel)

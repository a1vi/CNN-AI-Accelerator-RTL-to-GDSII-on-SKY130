# ============================================================
#  OpenLane Configuration — ai_accel
#  PDK: SKY130A   |  STD-CELL: sky130_fd_sc_hd
# ============================================================

# ---- Design identity ----------------------------------------
set ::env(DESIGN_NAME)   "ai_accel"
set ::env(DESIGN_DIR)    "$::env(OPENLANE_ROOT)/designs/ai_accel"

# ---- Source files -------------------------------------------
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]

# ---- Clocking -----------------------------------------------
set ::env(CLOCK_PORT)    "clk"
set ::env(CLOCK_PERIOD)  "10"   ;# 10 ns → 100 MHz

# ---- Floorplan ----------------------------------------------
set ::env(FP_CORE_UTIL)        40
set ::env(FP_ASPECT_RATIO)     1
set ::env(FP_PDN_VPITCH)       153.6
set ::env(FP_PDN_HPITCH)       153.6

# ---- Placement ----------------------------------------------
set ::env(PL_TARGET_DENSITY)   0.5
set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS)  1
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS)  1

# ---- Routing ------------------------------------------------
set ::env(ROUTING_CORES)       4
set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) 1

# ---- CTS ----------------------------------------------------
set ::env(CTS_CLK_BUFFER_LIST) "sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8"

# ---- Synthesis ----------------------------------------------
set ::env(SYNTH_STRATEGY)      "AREA 0"
set ::env(SYNTH_MAX_FANOUT)    10

# ---- Checks -------------------------------------------------
set ::env(QUIT_ON_TIMING_VIOLATIONS) 0
set ::env(QUIT_ON_MAGIC_DRC)         1
set ::env(QUIT_ON_LVS_ERROR)         1

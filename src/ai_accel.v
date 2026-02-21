// ============================================================
//  AI Accelerator — Top-Level Wrapper
//  CNN MAC Array Core  |  SKY130A  |  OpenLane RTL-to-GDSII
// ============================================================
module ai_accel (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,

    input  wire signed [7:0]  a0, a1, a2, a3,
    input  wire signed [7:0]  b0, b1, b2, b3,

    output wire        done,
    output wire signed [31:0] o0, o1, o2, o3
);

    mac_array u_mac_array (
        .clk   (clk),
        .rst_n (rst_n),
        .start (start),
        .a0(a0), .a1(a1), .a2(a2), .a3(a3),
        .b0(b0), .b1(b1), .b2(b2), .b3(b3),
        .done  (done),
        .o0(o0), .o1(o1), .o2(o2), .o3(o3)
    );

endmodule

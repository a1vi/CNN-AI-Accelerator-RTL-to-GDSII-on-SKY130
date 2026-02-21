// ============================================================
//  Multiply-Accumulate (MAC) Unit
//  Signed 8-bit inputs, 32-bit accumulator
// ============================================================
module mac (
    input  wire signed [7:0]  a,
    input  wire signed [7:0]  b,
    input  wire signed [31:0] acc_in,
    output wire signed [31:0] acc_out
);
    assign acc_out = acc_in + (a * b);

endmodule

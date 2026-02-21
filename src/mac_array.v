// ============================================================
//  4-Lane MAC Array
//  Computes 4 independent dot-product accumulations per cycle
//  Inputs : 4× signed 8-bit A & B operands
//  Outputs: 4× signed 32-bit accumulators, done flag
// ============================================================
module mac_array (
    input  wire        clk,
    input  wire        rst_n,   // active-low synchronous reset
    input  wire        start,

    input  wire signed [7:0]  a0, a1, a2, a3,
    input  wire signed [7:0]  b0, b1, b2, b3,

    output reg         done,
    output wire signed [31:0] o0, o1, o2, o3
);

    reg signed [31:0] acc0, acc1, acc2, acc3;

    always @(posedge clk) begin
        if (!rst_n) begin
            acc0 <= 32'sd0;
            acc1 <= 32'sd0;
            acc2 <= 32'sd0;
            acc3 <= 32'sd0;
            done <= 1'b0;
        end else if (start) begin
            acc0 <= acc0 + a0 * b0;
            acc1 <= acc1 + a1 * b1;
            acc2 <= acc2 + a2 * b2;
            acc3 <= acc3 + a3 * b3;
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end

    assign o0 = acc0;
    assign o1 = acc1;
    assign o2 = acc2;
    assign o3 = acc3;

endmodule

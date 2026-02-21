// ============================================================
//  Testbench — ai_accel
//  Run: iverilog -o sim tb/tb_ai_accel.v src/*.v && ./sim
// ============================================================
`timescale 1ns/1ps

module tb_ai_accel;

    // ---- DUT signals ----------------------------------------
    reg        clk, rst_n, start;
    reg  signed [7:0] a0,a1,a2,a3;
    reg  signed [7:0] b0,b1,b2,b3;
    wire       done;
    wire signed [31:0] o0,o1,o2,o3;

    // ---- Instantiate DUT ------------------------------------
    ai_accel dut (
        .clk(clk), .rst_n(rst_n), .start(start),
        .a0(a0),.a1(a1),.a2(a2),.a3(a3),
        .b0(b0),.b1(b1),.b2(b2),.b3(b3),
        .done(done),
        .o0(o0),.o1(o1),.o2(o2),.o3(o3)
    );

    // ---- Clock: 10 ns period --------------------------------
    initial clk = 0;
    always #5 clk = ~clk;

    // ---- Helper task ----------------------------------------
    task apply_mac;
        input signed [7:0] ia0,ia1,ia2,ia3;
        input signed [7:0] ib0,ib1,ib2,ib3;
        begin
            a0=ia0; a1=ia1; a2=ia2; a3=ia3;
            b0=ib0; b1=ib1; b2=ib2; b3=ib3;
            start = 1;
            @(posedge clk); #1;
            start = 0;
            @(posedge clk); #1;
        end
    endtask

    // ---- Stimulus -------------------------------------------
    integer errors = 0;

    task check;
        input signed [31:0] got, exp;
        input [63:0]        lane;
        begin
            if (got !== exp) begin
                $display("FAIL lane %0d: got=%0d exp=%0d", lane, got, exp);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("sim/waves.vcd");
        $dumpvars(0, tb_ai_accel);

        rst_n=0; start=0;
        a0=0;a1=0;a2=0;a3=0;
        b0=0;b1=0;b2=0;b3=0;
        repeat(3) @(posedge clk);
        rst_n = 1;

        // Test 1: simple multiply
        // 2*3=6, 4*5=20, -1*7=-7, 8*(-2)=-16
        apply_mac(8'sd2, 8'sd4, -8'sd1, 8'sd8,
                  8'sd3, 8'sd5,  8'sd7, -8'sd2);
        check(o0, 32'sd6,   0);
        check(o1, 32'sd20,  1);
        check(o2, -32'sd7,  2);
        check(o3, -32'sd16, 3);

        // Test 2: accumulate second MAC on top
        apply_mac(8'sd1, 8'sd1, 8'sd1, 8'sd1,
                  8'sd1, 8'sd1, 8'sd1, 8'sd1);
        check(o0, 32'sd7,   0);  // 6+1
        check(o1, 32'sd21,  1);  // 20+1
        check(o2, -32'sd6,  2);  // -7+1
        check(o3, -32'sd15, 3);  // -16+1

        // Test 3: reset clears accumulators
        rst_n = 0;
        @(posedge clk); #1;
        rst_n = 1;
        @(posedge clk); #1;
        check(o0, 32'sd0, 0);
        check(o1, 32'sd0, 1);
        check(o2, 32'sd0, 2);
        check(o3, 32'sd0, 3);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", errors);

        $finish;
    end

endmodule

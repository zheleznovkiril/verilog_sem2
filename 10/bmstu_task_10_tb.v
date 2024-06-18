`timescale 1ns / 1ps

module bmstu_task_10_tb();
    localparam WIDTH = 8, NUM = 4;
    reg clk_in = 'b0;
    reg [WIDTH-1:0] data_in = 'h0;
    wire [NUM-1:0][WIDTH-1:0] out;
    wire [NUM-1:0] out_valid;

    bmstu_task_10 #(.WIDTH(WIDTH), .NUM(NUM)) test_module (
        .clk_in(clk_in),
        .data_in(data_in),
        .out(out),
        .out_valid(out_valid)
    );
    integer i;
    always #5 clk_in = ~clk_in;

    initial begin
        data_in = 'b0;
        for (i = 0; i < 3; i = i + 1)
            #10 data_in = data_in + 1;
        data_in = 'b1;
        for (i = 0; i < 40-3; i = i + 1)
            #10 data_in = ((data_in) % 4) + 1;
        $finish;
    end

    initial begin
        $dumpfile("bmstu_task_10.vcd");
        $dumpvars(0, bmstu_task_10_tb);
    end
    
endmodule
module new_priority_cd #(
    parameter IN_WIDTH = 32,
    localparam OUT_WIDTH = $clog2(IN_WIDTH)
)(
    input [IN_WIDTH-1:0] in,
    //output [IN_WIDTH-1:0] grant,
    output [OUT_WIDTH-1:0] out
);
    wire [IN_WIDTH-1:0] higher_pri_reqs;
    wire [IN_WIDTH-1:0] grant;
    logic [IN_WIDTH-1:0] reversed;
    logic [IN_WIDTH-1:0] inter;

    for (genvar i = 0; i < IN_WIDTH; i = i + 1) begin : reverse_position_gen
        assign reversed[i] = in[IN_WIDTH-1-i];
        assign grant[i] = inter[IN_WIDTH-1-i];
    end
 
    assign higher_pri_reqs[IN_WIDTH-1:1] = higher_pri_reqs[IN_WIDTH-2:0] | reversed[IN_WIDTH-2:0];
    assign higher_pri_reqs[0] = 1'b0;
    assign inter = reversed & ~higher_pri_reqs;

    tri [IN_WIDTH-1:0] temp_wire;
    assign out = temp_wire;

    generate
        for (genvar i = 0; i < IN_WIDTH; i = i + 1) 
            assign temp_wire = (grant[i]) ? i : 'bz;
    endgenerate
endmodule
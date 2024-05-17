timescale 1ns / 1ps

module bmstu_task_4(
    input  logic        reset_in_neg,
    input  logic        spi_sck_in,
    input  logic        spi_cs_in,
    input  logic        spi_copi_in,
    output logic        spi_cipo_out,
    output logic        wr_en_out,
    output logic [31:0] wr_data_out,
    output logic [23:0] wr_address_out
);

parameter [7:0] COMMAND_WRITE = 8'h55; //Not be equal eight zeros

logic [63:0] full_data_reg;
logic [5:0]  data_conter_reg;
logic [7:0]  command_wire;


assign {command_wire, wr_address_out, wr_data_out} = full_data_reg;
//assign wr_data_out    = full_data_reg [31:0];
//assign wr_address_out = full_data_reg [55:32];
//assign command_wire   = full_data_reg [63:56];

assign wr_en_out = (command_wire == COMMAND_WRITE) && (!data_conter_reg);

always_ff @ (posedge spi_sck_in)
if    (reset_in_neg) full_data_reg                  <= 'b0;
else if (!spi_cs_in) full_data_reg                  <= full_data_reg;
else                 full_data_reg[data_conter_reg] <= spi_copi_in;

always_ff @ (posedge spi_sck_in)
if    (reset_in_neg) data_conter_reg <= 'b0;
else if (!spi_cs_in) data_conter_reg <= data_conter_reg;
else                 data_conter_reg <= data_conter_reg + 1;

endmodule
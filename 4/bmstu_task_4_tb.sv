timescale 1ns / 1ps

module bmstu_task_4_tb;
    logic        reset_in_neg = 1'b1;
    logic        spi_sck_in   = 1'b0;
    logic        spi_cs_in    = 1'b0;
    logic        spi_copi_in;
    logic        spi_cipo_out;
    logic        wr_en_out;
    logic [31:0] wr_data_out;
    logic [23:0] wr_address_out;
    
    localparam CLK_HALF_PERIOD = 10;
    
    always #(CLK_HALF_PERIOD) spi_sck_in <= ~ spi_sck_in;
    
    logic [31 : 0] data;
    logic [23 : 0] address;
    logic [7  : 0] command;
   
    logic [63 : 0] full_command;
    
    
    assign full_command =   {command,  address, data};
    assign address =        {command, ~command, command};
    assign data = {~command, command, ~command, command};
    
    initial begin 
        spi_copi_in = 1'b0;
        #(4* CLK_HALF_PERIOD) reset_in_neg = 1'b0;
        for (int j = 0; j < 256; j++) begin
            command = j; 
            for (int i = 0; i < 64; i++) begin 
                #(2 * CLK_HALF_PERIOD) spi_copi_in = full_command[i];
            end
        end
        spi_cs_in = 1'b1;
        for (int j = 0; j < 256; j++) begin
            command = j;  
            for (int i = 0; i < 64; i++) begin 
                #(2 * CLK_HALF_PERIOD) spi_copi_in = full_command[i];
            end
        end
        $finish;
    end
    
    bmstu_task_4 uut(
        .reset_in_neg   ( reset_in_neg   ),
        .spi_sck_in     ( spi_sck_in     ),
        .spi_cs_in      ( spi_cs_in      ),
        .spi_copi_in    ( spi_copi_in    ),
        .spi_cipo_out   ( spi_cipo_out   ),
        .wr_en_out      ( wr_en_out      ),
        .wr_data_out    ( wr_data_out    ),
        .wr_address_out ( wr_address_out )
    );
    
endmodule
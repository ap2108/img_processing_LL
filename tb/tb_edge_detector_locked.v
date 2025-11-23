`timescale 1ns/1ps

module tb_edge_detector;
    parameter WIDTH  = 128;
    parameter HEIGHT = 128;

    reg en;
    reg [15:0] im11, im12, im13;
    reg [15:0] im21, im22, im23;
    reg [15:0] im31, im32, im33;

    wire ready;
    wire [7:0] dxy;

    reg [15:0] mem [0:(WIDTH*HEIGHT*9)-1];
    integer k;
    integer fop;

    reg [23:0] key;

    edge_detector_locked dut (
        .en   (en),
        .im11 (im11),
        .im21 (im21),
        .im31 (im31),
        .im12 (im12),
        .im22 (im22),
        .im32 (im32),
        .im13 (im13),
        .im23 (im23),
        .im33 (im33),
        .dxy  (dxy),
        .key  (key),
        .ready(ready)
    );

    initial begin
        en = 0;
        $readmemh("img/input.hex", mem);
        fop = $fopen("img/output.hex", "w");

        //key = 24'b0000_1100_0111_1110_0111_1110;
        key = 24'h0A7E70;
        
        for (k = 0; k < WIDTH*HEIGHT*9; k = k + 9) begin
            im11 = mem[k];
            im21 = mem[k + 1];
            im31 = mem[k + 2];
            im12 = mem[k + 3];
            im22 = mem[k + 4];
            im32 = mem[k + 5];
            im13 = mem[k + 6];
            im23 = mem[k + 7];
            im33 = mem[k + 8];

            #1 en = 1; 
            #1 en = 0; 
            wait (ready == 1'b1); 

            if (^dxy === 1'bx)
                $fwrite(fop, "%h\n", 8'd0);
            else
                $fwrite(fop, "%h\n", dxy);
        end

        $fclose(fop);
        $finish;
    end
endmodule

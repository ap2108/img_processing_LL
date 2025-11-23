`timescale 1ns/1ps

module tb_blur_locked;
    parameter WIDTH  = 128;
    parameter HEIGHT = 128;

    reg en;

    reg [15:0] im11, im12, im13; 
    reg [15:0] im21, im22, im23;
    reg [15:0] im31, im32, im33;

    reg [23:0] key;

    wire ready;
    wire [15:0] out;

    reg [15:0] mem [0:(WIDTH*HEIGHT*16)-1];
    integer k;
    integer fop;
  
    blur_locked dut (
        .en(en),
        .im11(im11), .im12(im12), .im13(im13),
        .im21(im21), .im22(im22), .im23(im23),
        .im31(im31), .im32(im32), .im33(im33),
        .key(key),
        .out(out),
        .ready(ready)
    );

    initial begin
        en = 0;
        $readmemh("img/input.hex", mem);
        fop = $fopen("img/output.hex", "w");
        
        //key = 24'b101001100110100110111010;
        key = 24'h0A7E70;
        for (k = 0; k < WIDTH*HEIGHT*16; k = k + 16) begin
            im11 = mem[k + 0];
            im12 = mem[k + 1];
            im13 = mem[k + 2];

            im21 = mem[k + 3];
            im22 = mem[k + 4];
            im23 = mem[k + 5];

            im31 = mem[k + 6];
            im32 = mem[k + 7];
            im33 = mem[k + 8];

            #1 en = 1;
            #1 en = 0;

            wait (ready == 1'b1);

            if (^out === 1'bx)
                $fwrite(fop, "%h\n", 16'd0);
            else
                $fwrite(fop, "%h\n", out);
        end

        $fclose(fop);
        $finish;
    end
endmodule

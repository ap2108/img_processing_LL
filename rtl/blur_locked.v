`timescale 1ns/1ps

module blur_locked(
    input en,

    input [15:0] im11, input [15:0] im12, input [15:0] im13,
    input [15:0] im21, input [15:0] im22, input [15:0] im23,
    input [15:0] im31, input [15:0] im32, input [15:0] im33,

    input [23:0] key,

    output reg [15:0] out,
    output reg ready
);

    reg [15:0] sum1, sum2, sum3, sum;

    always @(posedge en) begin
        ready <= 1'b0;

        sum1 =  
            ((im11 ^ ((key[0] ? (16'h1 << 11) : 16'h0) | (~key[1] ? (16'h1 << 7) : 16'h0))) +
            (im21 ^ (key[2] ? (16'h1 << 12) : 16'h0)) +
            (im31 ^ (~key[3] ? (16'h1 << 8) : 16'h0)))
            ^ (~key[4] ? (16'h1 << 9) : 16'h0);

        sum2 =  
            ((im12 ^ ((~key[5] ? (16'h1 << 6) : 16'h0) | (key[6] ? (16'h1 << 4) : 16'h0))) +
            (im22 ^ (~key[7] ? (16'h1 << 13) : 16'h0)) +
            (im32 ^ (~key[8] ? (16'h1 << 10) : 16'h0)))
            ^ (key[9] ? (16'h1 << 11) : 16'h0);

        sum3 =  
            ((im13 ^ ((key[10] ? (16'h1 << 12) : 16'h0) | (~key[11] ? (16'h1 << 14) : 16'h0))) +
            (im23 ^ (key[12] ? (16'h1) : 16'h0)) +
            (im33 ^ (~key[13] ? (16'h1 << 9) : 16'h0))) ^ (~key[14] ? (16'h1 << 7) : 16'h0);

        sum <=
            (
                ((sum1 + sum2) ^
                    ((key[15] ? (16'h1 << 5) : 16'h0) | (key[16] ? (16'h1 << 1) : 16'h0)))
              +
                (sum3 ^
                    ((~key[17] ? (16'h1 << 7) : 16'h0) |
                     (~key[18] ? (16'h1 << 4) : 16'h0)))
            )
            ^ (key[19] ? (16'h1 << 8) : 16'h0);

        out <=
            (
                (((sum ^
                      ((key[20] ? (16'h1 << 10) : 16'h0) |
                       (~key[21] ? (16'h1 << 3) : 16'h0)))
                  * 57)
                 ^ (key[22] ? (16'h1) : 16'h0))
                >> 9
            );

        ready <= 1'b1;
    end
endmodule

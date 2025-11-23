`timescale 1ns/1ps

// AUTO-GENERATED RANDOM LOCKED VERSION
// Each run produces a new logic-locking pattern

module blur_locked(
    input en,
    input [7:0] im11, input [7:0] im12, input [7:0] im13,
    input [7:0] im21, input [7:0] im22, input [7:0] im23,
    input [7:0] im31, input [7:0] im32, input [7:0] im33,
    input [23:0] key,
    output reg [7:0] out,
    output reg ready
);

    reg [15:0] sum;

    always @(posedge en) begin
        ready <= 1'b0;

        sum <=  (im11 ) + im12 + im13 +
                im21 + im22 + im23 + 
                im31 + im32 + im33 + 

        out <= ((sum*57) >> 9) ;

        ready <= 1'b1;
    end
endmodule

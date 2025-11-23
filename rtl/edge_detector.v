module edge_detector(en,
    im11,
    im21,
    im31,
    im12,
    im22,
    im32,
    im13,
    im23,
    im33,
    dxy,
    ready,
);
    input en;

    input [15:0] im11, im12, im13;
    input [15:0] im21, im22, im23;
    input [15:0] im31, im32, im33;

    output reg [7:0] dxy;
    output reg ready;

    reg [15:0] dx;
    reg [15:0] dy;
    reg [15:0] dx_a, dx_b;
    reg [15:0] dy_a, dy_b;

    always @(posedge en) begin
        ready <= 1'b0;

        // Horizontal gradient ----------------------------------------------------
        dx_a <= (im11 + (im21 << 1) + im31);
        dx_b <= (im13 + (im23 << 1) + im33);

        if (dx_a >= dx_b)
            dx <= dx_a - dx_b;
        else
            dx <= dx_b - dx_a;
        // -------------------------------------------------------------------------

        // Vertical gradient -------------------------------------------------------
        dy_a <= (im31 + (im32 << 1) + im33);
        dy_b <= (im11 + (im12 << 1) + im13);

        if (dy_a >= dy_b)
            dy <= dy_a - dy_b;
        else
            dy <= dy_b - dy_a;
        // --------------------------------------------------------------------------

        dxy <= ((dx + dy) >= 16'd255) ? 8'd255 : 8'd0;
        ready <= 1'b1;
    end
endmodule

module siren_generator (
    input clock, reset,
    input two_hz_enable,
    input enable_siren,
    output reg [1:0] siren
);

always @(posedge clock, posedge reset) begin
    if (reset || !enable_siren) begin
        siren <= 2'b00;
    end
    else begin
        if (two_hz_enable) begin
            siren <= ~siren;
        end
    end
end

endmodule

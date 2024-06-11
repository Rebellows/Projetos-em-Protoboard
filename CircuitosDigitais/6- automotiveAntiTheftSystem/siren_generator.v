module siren_generator (
    input clock, reset,
    input two_hz_enable,
    input enable_siren,
    output reg siren
);

always @(posedge clock, posedge reset) begin
    if (reset || !enable_siren) begin
        siren <= 1'b0;
    end
    else begin
        if (two_hz_enable) begin
            siren <= ~siren;
        end
    end
end

endmodule

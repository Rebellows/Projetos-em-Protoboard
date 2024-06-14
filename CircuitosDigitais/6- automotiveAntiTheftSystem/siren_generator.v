module siren_generator (
    input clock, reset,
    input two_hz_enable,
    input enable_siren,
    output reg [2:0] siren
);

reg count;

always @(posedge clock, posedge reset) begin
    if (reset || !enable_siren) begin
        siren <= 3'b000;
        count <= 1'b0;
    end
    else begin
        if (two_hz_enable) begin
            if (!count) begin
                siren <= 3'b001;
                count <= 1'b1;
            end
            else begin
                siren <= 3'b100;
                count <= 1'b0;
            end
        end
    end
end

endmodule

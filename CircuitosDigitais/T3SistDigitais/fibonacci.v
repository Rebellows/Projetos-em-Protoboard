module fibonacci (
    input reset, clock, f_en,
    output f_valid,
    output [15:0] f_out
);

reg [15:0] out, aux;

always @(posedge clock or posedge reset) begin
    if (reset) begin
        out <= 16'b0;
        aux <= 16'b1;
    end
    else if (f_en) begin
        out <= aux;
        aux <= aux + out;
    end
end

assign f_out = out;
assign f_valid = (f_en) ? 1 : 0;

endmodule
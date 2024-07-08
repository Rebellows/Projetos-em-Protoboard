module fibonacci (
    input reset, clock_1, f_en,
    output reg f_valid,
    output reg [15:0] f_out
);

reg [15:0] a, b;

always @(posedge clock_1 or posedge reset) begin
    if (reset) begin
        a <= 16'b0;
        b <= 16'b1;
        f_out <= 16'b0;
        f_valid <= 1'b0;
    end
    else if (f_en) begin
        f_out <= a;
        a <= b;
        b <= a + b;
        f_valid <= 1'b1;
    end
    else begin
        f_valid <= 1'b0;
    end
end

endmodule
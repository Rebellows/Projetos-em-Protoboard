module fibonacci (
    input reset, clock_1, f_en,
    output reg f_valid,
    output reg [15:0] f_out
);

reg [15:0] a, b, aux;
reg flag;

always @(posedge clock_1 or posedge reset) begin
    if (reset) begin
        a <= 16'b0;
        b <= 16'b1;
        f_out <= 16'b0;
        f_valid <= 1'b0;
        flag <= 1'b0;
        aux <= 16'b0;
    end
    else begin
        if (f_en) begin
            if (flag) begin
                f_out <= aux;
                f_valid <= 1'b1;
                flag <= 1'b0;
            end
            else begin
                f_out <= a;
                a <= b;
                b <= a + b;
                f_valid <= 1'b1;
            end
        end
        else begin
            if (a == 0) begin
                f_valid <= 1'b0;
            end
            else begin
                aux <= b - a;
                flag <= 1'b1;
                f_valid <= 1'b0;
            end
        end
    end
end

endmodule

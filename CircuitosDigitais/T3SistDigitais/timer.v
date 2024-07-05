module timer (
    input reset, clock, t_en,
    output t_valid,
    output [15:0] t_out;
); 

reg [15:0] count;

always @(posedge clock or posedge reset) begin
    if (reset) begin
        count <= 32'b0;
    end
    else if (t_en) begin
        count <= count + 1'b1;
    end
end

assign t_out = count;
assign t_valid = (t_en) ? 1 : 0;

endmodule

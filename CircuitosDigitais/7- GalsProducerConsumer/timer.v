module timer (
    input reset, clock_1, t_en,
    output reg t_valid,
    output reg [15:0] t_out
); 

reg [15:0] counter;

always @(posedge clock_1 or posedge reset) begin
    if (reset) begin
        counter <= 32'b0;
        t_valid <= 1'b0;
        t_out <= 16'b0;
    end
    else begin
        if (t_en) begin
            t_out <= counter;
            counter <= counter + 1'b1;
            t_valid <= 1'b1;
        end
        else begin
            t_valid <= 1'b0;
        end
        if (counter == 16'd65535) begin
            counter <= 16'b0;
        end    
    end    
end

endmodule
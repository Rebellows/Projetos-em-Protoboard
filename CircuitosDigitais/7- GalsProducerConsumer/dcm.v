module dcm (
    input clock, reset, update,
    input [2:0] prog_in,
    output reg clock_1, clock_2,
    output reg [2:0] prog_out
);

// parameter HUNDREDMHZ = 10;  
// parameter CLOCK_0_TB = HUNDREDMHZ / 10 / 2;
// parameter CLOCK_1_TB = HUNDREDMHZ / 5 / 2;
// parameter CLOCK_2_TB = HUNDREDMHZ / 2.5 / 2;
// parameter CLOCK_3_TB = HUNDREDMHZ / 2;
// parameter CLOCK_4_TB = HUNDREDMHZ / 0.625 / 2;
// parameter CLOCK_5_TB = HUNDREDMHZ / 0.3125 / 2;
// parameter CLOCK_6_TB = HUNDREDMHZ / 0.15625 / 2;
// parameter CLOCK_7_TB = HUNDREDMHZ / 0.078125 / 2;

parameter ONE_HZ = 100_000_000;  
parameter CLOCK_0 = ONE_HZ / 10 / 2;
parameter CLOCK_1 = ONE_HZ / 5 / 2;
parameter CLOCK_2 = ONE_HZ / 2.5 / 2;
parameter CLOCK_3 = ONE_HZ / 2;
parameter CLOCK_4 = ONE_HZ / 0.625 / 2;
parameter CLOCK_5 = ONE_HZ / 0.3125 / 2;
parameter CLOCK_6 = ONE_HZ / 0.15625 / 2;
parameter CLOCK_7 = ONE_HZ / 0.078125 / 2;

reg [31:0] counter_1, counter_2, aux;

always @(posedge clock or posedge reset) begin
    if (reset) begin
        clock_1 <= 1'b0;
        clock_2 <= 1'b0;
        counter_1 <= 32'b0;
        counter_2 <= 32'b0;
        prog_out <= 3'b0;
        aux <= CLOCK_0;
    end
    else begin
        if (counter_2 >= aux) begin
            clock_2 <= ~clock_2;
            counter_2 <= 32'b0;
        end 
        else begin
            counter_2 <= counter_2 + 1'b1;
        end
        if (counter_1 >= CLOCK_0) begin
            clock_1 <= ~clock_1;
            counter_1 <= 32'b0;
        end 
        else begin
            counter_1 <= counter_1 + 1'b1;
        end
        if (update) begin
            case (prog_in)
                // 3'b000: aux <= CLOCK_0_TB;
                // 3'b001: aux <= CLOCK_1_TB;
                // 3'b010: aux <= CLOCK_2_TB;                
                // 3'b011: aux <= CLOCK_3_TB;
                // 3'b100: aux <= CLOCK_4_TB;
                // 3'b101: aux <= CLOCK_5_TB;
                // 3'b110: aux <= CLOCK_6_TB;
                // 3'b111: aux <= CLOCK_7_TB;
                // default: aux <= CLOCK_0_TB;
                3'b000: aux <= CLOCK_0;
                3'b001: aux <= CLOCK_1;
                3'b010: aux <= CLOCK_2;                
                3'b011: aux <= CLOCK_3;
                3'b100: aux <= CLOCK_4;
                3'b101: aux <= CLOCK_5;
                3'b110: aux <= CLOCK_6;
                3'b111: aux <= CLOCK_7;
                default: aux <= CLOCK_0;                
            endcase
            counter_2 <= 32'b0;
            prog_out <= prog_in;
        end        
    end
end

endmodule
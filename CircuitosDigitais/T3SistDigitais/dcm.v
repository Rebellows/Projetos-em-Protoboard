module dcm (
    input clock, reset, update,
    input [2:0] prog_in,
    output clock_1, clock_2,
    output [2:0] prog_out
);

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
        counter <= 31'b0;
        prog_out <= 3'b0;
    end
    else begin
        if (counter_2 == aux) begin
            counter_2 <= 32'b0;
            clock_2 <= 1'b1;
        end
        else if (counter_1 == CLOCK_0) begin
            counter_1 <= 32'b0;
            clock_1 <= 1'b1;
        end
        counter_2 <= counter_2 + 1'b1;
        counter_1 <= counter_1 + 1'b1;
        clock_2 <= 1'b0;
        clock_1 <= 1'b0;
        if (update) begin
            case (prog_in)

                3'b000: begin
                    aux <= CLOCK_0;
                end

                3'b001: begin
                    aux <= CLOCK_1;
                end

                3'b010: begin
                    aux <= CLOCK_2;                
                end

                3'b011: begin
                    aux <= CLOCK_3;
                end

                3'b100: begin
                    aux <= CLOCK_4;
                end

                3'b101: begin
                    aux <= CLOCK_5;
                end

                3'b110: begin
                    aux <= CLOCK_6;
                end

                3'b111: begin
                    aux <= CLOCK_7;
                end

                default: begin
                    aux <= CLOCK_0;
                end

            endcase
            counter_2 <= 32'b0;
        end        
    end
end

endmodule

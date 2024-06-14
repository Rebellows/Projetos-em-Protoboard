module time_parameters (
    input clock, reset, 
    input [1:0] interval, time_param_sel,
    input reprogram,
    input [3:0] time_value,
    output reg [3:0] value
);

reg [3:0] T_ARM_DELAY;
reg [3:0] T_DRIVER_DELAY;
reg [3:0] T_PASSENGER_DELAY;
reg [3:0] T_ALARM_ON;

always @(posedge clock, posedge reset) begin
    if (reset) begin
        T_ARM_DELAY <= 4'b0110;
        T_DRIVER_DELAY <= 4'b1000;
        T_PASSENGER_DELAY <= 4'b1111;
        T_ALARM_ON <= 4'b1010;       
    end
    else if (reprogram) begin
        case (time_param_sel)
            2'b00: T_ARM_DELAY <= time_value;
            2'b01: T_DRIVER_DELAY <= time_value; 
            2'b10: T_PASSENGER_DELAY <= time_value; 
            2'b11: T_ALARM_ON <= time_value;
        endcase
    end    
end

always @(*) begin
    case (interval) 
        2'b00: value = T_ARM_DELAY;
        2'b01: value = T_DRIVER_DELAY;
        2'b10: value = T_PASSENGER_DELAY;
        2'b11: value = T_ALARM_ON;
        default: value = value;
    endcase
end

endmodule
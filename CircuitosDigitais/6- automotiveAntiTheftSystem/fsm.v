`define ARMED 4'b0000
`define TRIGGERED 4'b0001
`define WAIT_EXPIRED_TRIG 4'b0010
`define ACTIVATE_ALARM 4'b0011
`define WAIT_ALARM 4'b0100
`define DISARMED 4'b0101
`define WAIT_OPEN 4'b0110
`define WAIT_INTERMED 4'b0111
`define WAIT_CLOSE 4'b1000
`define TRIG_TIME_ARM 4'b1001
`define WAIT_TIME_ARM 4'b1010

module fsm (
    input clock, reset,
    input ignition, door_driver, door_pass, reprogram, expired, one_hz_enable,
    output reg status, enable_siren, start_timer,
    output reg [1:0] interval,
    output reg [3:0] EA
);

reg [3:0] PE;
reg [1:0] aux;

always @(posedge clock, posedge reset) begin
    if (reset) begin
        EA <= `ARMED;
        aux <= 2'b00;
    end
    else begin
        EA <= PE;
        if (EA == `ARMED) begin
            if (aux == 2'b10) begin
                aux <= 2'b00;
            end
            else if (one_hz_enable) begin
                aux <= aux + 1;
            end
        end
    end    
end

always @(*) begin
    case (EA)

        `ARMED: begin
            if (door_pass || door_driver) begin
                PE = `TRIGGERED;
            end
            else if (ignition) begin
                PE = `DISARMED;
            end
            else begin
                PE = `ARMED;
            end    
        end

        `TRIGGERED: begin
            if (expired) begin
                PE = `ACTIVATE_ALARM;
            end
            else if (reprogram) begin
                PE = `ARMED;
            end
            else if (ignition) begin
                PE = `DISARMED;
            end
            else begin
                PE = `TRIGGERED;
            end
        end

        `ACTIVATE_ALARM: begin
            if (expired && (door_driver || door_pass)) begin
                PE = `ARMED;
            end
            else if (reprogram) begin
                PE = `ARMED;
            end            
            else if (ignition) begin
                PE = `DISARMED;
            end
            else begin
                PE = `ACTIVATE_ALARM;
            end    
        end

        `DISARMED: begin
            if (!ignition) begin
                PE = `WAIT_OPEN;
            end
            else if (reprogram) begin
                PE = `ARMED;
            end            
            else begin
                PE = `DISARMED;
            end
        end          

        `WAIT_OPEN: begin
            if (door_driver) begin
                PE = `WAIT_CLOSE;
            end
            else if (reprogram) begin
                PE = `ARMED;
            end            
            else begin
                PE = `WAIT_OPEN;
            end
        end

        `WAIT_CLOSE: begin
            if (door_driver) begin
                PE = `TRIG_TIME_ARM;
            end
            else if (reprogram) begin
                PE = `ARMED;
            end            
            else begin
                PE = `WAIT_CLOSE;
            end
        end

        `TRIG_TIME_ARM: begin
            if (expired) begin
                PE = `ARMED;
            end
            else if (reprogram) begin
                PE = `ARMED;
            end
            else begin
                PE = `WAIT_TIME;
            end
        end        

        default: PE = `ARMED;

    endcase 
end

always @(*) begin
    case (EA)

        `ARMED: begin
            if (aux >= 2'b01) begin
                status = 1'b1;
            end
            else begin
                status = 1'b0;
            end
            enable_siren = 1'b0;
            start_timer = 1'b0;
            interval = 2'b00;
        end

        `TRIGGERED: begin
            status = 1'b1;
            enable_siren = 1'b0;
            start_timer = 1'b1;
            if (door_pass) begin
                interval = 2'b10;
            end
            else begin
                interval = 2'b01;
            end
        end
        
        `WAIT_EXPIRED_TRIG: begin
            enable_siren = 1'b0;
            start_timer = 1'b0;
            interval = 2'b00;
            status = 1'b1;            
        end

        `ACTIVATE_ALARM: begin
            status = 1'b1;
            enable_siren = 1'b1;
            start_timer = 1'b1;
            interval = 2'b11;
        end
        
        `WAIT_ALARM: begin
            status = 1'b1;
            enable_siren = 1'b1;
            start_timer = 1'b0;
            interval = 2'b11;        
        end

        `DISARMED: begin
            status = 1'b0;
            enable_siren = 1'b0;
            start_timer = 1'b0;
            interval = 2'b00;
        end          

        `WAIT_OPEN: begin
            status = 1'b0;
            enable_siren = 1'b0;
            start_timer = 1'b0;
            interval = 2'b00;
        end
        
        `WAIT_INTERMED: begin
            status = 1'b0;
            enable_siren = 1'b0;
            start_timer = 1'b0;
            interval = 2'b00;        
        end

        `WAIT_CLOSE: begin
            status = 1'b0;
            enable_siren = 1'b0;
            start_timer = 1'b0;
            interval = 2'b00;
        end

        `TRIG_TIME_ARM: begin
            status = 1'b0;
            enable_siren = 1'b0;
            start_timer = 1'b1;
            interval = 2'b00;
        end      
 
        `WAIT_TIME_ARM: begin
            status = 1'b0;
            enable_siren = 1'b0;
            start_timer = 1'b0;
            interval = 2'b00;
        end
                
        default: begin
            status = 1'b0;  
            enable_siren = 1'b0;
            start_timer = 1'b0;
            interval = 2'b00;
        end
        
    endcase 
end

endmodule

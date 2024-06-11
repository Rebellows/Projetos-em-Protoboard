`define ARMED 3'b000
`define TRIGGERED 3'b001
`define ACTIVATE_ALARM 3'b010
`define DISARMED 3'b011
`define WAIT_OPEN 3'b100
`define WAIT_CLOSE 3'b101
`define WAIT_TIME 3'b110

module fsm (
    input clock, reset,
    input ignition, door_driver, door_pass, reprogram, expired, one_hz_enable,
    output status, enable_siren, start_timer,
    output [1:0] interval
);

reg [2:0] EA, PE;
reg [1:0] aux;

always @(posedge clock, posedge reset) begin
    if (reset) begin
        EA <= `ARMED;
        aux <= 2'b00;
    end
    else begin
        EA <= PE;
        if (EA == `ARMED) begin
            if (one_hz_enable) begin
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
            if (expired || (!door_pass && !door_driver)) begin
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
            if (!door_driver) begin
                PE = `WAIT_TIME;
            end
            else if (reprogram) begin
                PE = `ARMED;
            end            
            else begin
                PE = `WAIT_CLOSE;
            end
        end

        `WAIT_TIME: begin
            if (expired) begin
                PE = `ARMED;
            end
            else if (door_driver) begin
                PE = `WAIT_CLOSE;
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
            if (aux == 2'b10) begin
                status = 1'b1;
                aux = 2'b00;
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
            if (door_driver && !door_pass) begin
                interval = 2'b01;
            end
            else begin
                interval = 2'b10;
            end
        end

        `ACTIVATE_ALARM: begin
            status = 1'b1;
            enable_siren = 1'b1;
            start_timer = 1'b1;
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

        `WAIT_CLOSE: begin
            status = 1'b0;
            enable_siren = 1'b0;
            start_timer = 1'b0;
            interval = 2'b00;
        end

        `WAIT_TIME: begin
            status = 1'b0;
            enable_siren = 1'b0;
            start_timer = 1'b1;
            interval = 2'b00;
        end        

    endcase 
end

endmodule
`define IDLE 2'b00
`define IGNITION_ON 2'b01
`define FUEL_ON 2'b10

module fuel_pump_logic (
    input clock, reset,
    input break, ignition, hidden_sw,
    output fuel_pump);      

reg [1:0] EA, PE;

always @(posedge clock, posedge reset) begin
    if (reset) begin
        EA <= `IDLE;
    end
    else begin
        EA <= PE;
    end
end

always @(*) begin
    case (EA)

        `IDLE: begin
            if (ignition) 
                PE = `IGNITION_ON;
            else 
                PE = `IDLE;
        end

        `IGNITION_ON: begin
            if (ignition && break && hidden_sw)
                PE = `FUEL_ON;
            else if (!ignition)
                PE = `IDLE;
            else
                PE = `IGNITION_ON;
        end

        `FUEL_ON: begin
            if (!ignition || !break || !hidden_sw)
                PE = `IDLE;
            else 
                PE = `FUEL_ON;
        end

        default: PE = `IDLE;

    endcase 
end

assign fuel_pump = (EA == `FUEL_ON) ? 1'b1 : 1'b0;

endmodule
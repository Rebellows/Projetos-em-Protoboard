`define WAIT 3'b000
`define INIT 3'b001
`define CRYPT 3'b010
`define RESULT 3'b011
`define FINISH 3'b100

module top (
    input reset, clock,
    input start, configuration,
    input [127:0] data_i, key,
    output reg ready, busy,
    output reg [127:0] data_o
);

wire ready_enc, ready_dec;
wire [127:0] data_o_enc, data_o_dec;

reg [2:0] EA, PE;
reg [31:0] v [0:3];
reg [31:0] k [0:3];
reg [2:0] i;

reg aux;

wire [127:0] v_wire = {v[0], v[1], v[2], v[3]};
wire [127:0] k_wire = {k[0], k[1], k[2], k[3]};

dec dec (.reset(reset), .clock(clock), .configuration(configuration), .aux(aux), .start(start), .v(v_wire), .k(k_wire), .ready(ready_dec), .data_o(data_o_dec));
enc enc (.reset(reset), .clock(clock), .configuration(configuration), .aux(aux), .start(start), .v(v_wire), .k(k_wire), .ready(ready_enc), .data_o(data_o_enc));

always @(posedge clock or posedge reset) begin
    if (reset) begin
        EA <= `WAIT;
    end
    else begin
        EA <= PE;
    end
end

always @(*) begin
    case (EA)
        `WAIT: begin
            if (start) begin
                PE = `INIT;
            end
            else begin
                PE = `WAIT;
            end
        end
        `INIT: begin
            if (i < 4) begin
                PE = `INIT;  
            end 
            else begin
                PE = `CRYPT;
            end
        end
        `CRYPT: begin
            if (ready_enc || ready_dec) begin
                PE = `RESULT;
            end
            else begin
                PE = `CRYPT;
            end
        end
        `RESULT: begin
            PE = `FINISH;
        end
        `FINISH: begin
            PE = `WAIT;
        end
        default: PE = `WAIT;
    endcase
end

always @(posedge clock or posedge reset) begin
    case (EA)
        `WAIT: begin
            ready <= 0;
            busy <= 0;
            aux <= 0;
            i <= 0;
        end
        `INIT: begin
            v[i] <= data_i[127 - 32*i -: 32]; 
            k[i] <= key[127 - 32*i -: 32];
            i <= i + 1;
            if (i == 4) begin
                i <= 0;
            end
            ready <= 0;
            busy <= 1;
            aux <= 0;
        end
        `CRYPT: begin
            ready <= 0;
            busy <= 1;
            aux <= 1;
        end
        `RESULT: begin
            if (!configuration) begin
                data_o <= data_o_dec;
            end
            else begin
                data_o <= data_o_enc;
            end            
            ready <= 1;
            busy <= 0;
            aux <= 0;
        end
        `FINISH: begin
            ready <= 0;
            busy <= 0;
            aux <= 0;
        end
    endcase
end
endmodule
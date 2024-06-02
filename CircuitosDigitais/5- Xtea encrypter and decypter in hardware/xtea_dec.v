`define WAIT 3'b000
`define DEC 3'b001
`define Z 3'b010 
`define SUM 3'b011
`define Y 3'b100
`define LOG 3'b101

module dec (
    input clock, reset,
    input configuration, aux, start,
    input [127:0] v, k,
    output reg ready,
    output reg [127:0] data_o
);

reg [5:0] i;
reg [31:0] y0, z0, y1, z1, sum, delta;

reg [31:0] k_reg [0:3];

reg [2:0] EA, PE;

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
                PE = `DEC;
            end
            else begin
                PE = `WAIT;
            end
        end 
        `DEC: begin
            if (!configuration && aux) begin
                PE = `Z;
            end else begin
                PE = `DEC;
            end      
        end
        `Z: begin
            PE = `SUM;    
        end
        `SUM: begin
            PE = `Y;
        end
        `Y: begin
            if (i < 31) begin
                PE = `Z;
            end else begin
                PE = `LOG;
            end
        end
        `LOG: begin
            PE = `WAIT;
        end
        default: PE = `DEC;
    endcase
end

always @(posedge clock or posedge reset) begin
    case (EA)
        `WAIT: begin
            ready <= 0;
        end
        `DEC: begin
            ready <= 0;
            i <= 0;
            y0 <= v[31:0];
            z0 <= v[63:32];
            y1 <= v[95:64];
            z1 <= v[127:96]; 
            k_reg[0] <= k[31:0];
            k_reg[1] <= k[63:32];
            k_reg[2] <= k[95:64];
            k_reg[3] <= k[127:96];
            sum <= 32'hC6EF3720;
            delta <= 32'h9E3779B9;    
        end
        `Z: begin
            z1 <= z1 - (((y1 << 4 ^ y1 >> 5) + y1) ^ (sum + k_reg[sum>>11 & 3]));
            z0 <= z0 - (((y0 << 4 ^ y0 >> 5) + y0) ^ (sum + k_reg[sum>>11 & 3]));
            ready <= 0;      
        end
        `SUM: begin
            sum <= sum - delta;
            ready <= 0;
        end
        `Y: begin
            y1 <= y1 - (((z1 << 4 ^ z1 >> 5) + z1) ^ (sum + k_reg[sum & 3]));
            y0 <= y0 - (((z0 << 4 ^ z0 >> 5) + z0) ^ (sum + k_reg[sum & 3]));            
            ready <= 0;
            i <= i + 1;
            if (i == 32) begin
                i <= 0;
            end
        end
        `LOG: begin
            data_o[127:96] <= z1;
            data_o[95:64] <= y1;
            data_o[63:32] <= z0;
            data_o[31:0] <= y0;
            ready <= 1;
        end
    endcase
end
endmodule

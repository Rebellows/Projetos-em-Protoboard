`define S_IDLE 3'b000
`define S_COMM_F 3'b001
`define S_WAIT_F 3'b010
`define S_COMM_T 3'b011
`define S_WAIT_T 3'b100
`define S_BUFF_EMPTY 3'b101

module top (
    input reset, clock, start_f, start_t, stop_f_t, update,
    input [2:0] prog,
    output reg [5:0] led,
    output parity,
    output [7:0] an, dec_ddp
);

reg [2:0] EA, PE;
wire clock_1, clock_2;
reg t_en, f_en;
wire start_f_ed, start_t_ed, stop_f_t_ed, update_ed;
wire f_valid, t_valid;
wire buffer_empty, buffer_full, data_2_valid, data_1_en;
wire [15:0] f_out, t_out, data_2;
wire [2:0] prog_out;
reg [1:0] module_reg;
reg [15:0] data_1;

assign data_1_en = (f_valid || t_valid) ? 1 : 0;
assign parity = ^data_2;

edge_detector ed_start_f (.clock(clock), .reset(reset), .din(start_f), .rising(start_f_ed));
edge_detector ed_start_t (.clock(clock), .reset(reset), .din(start_t), .rising(start_t_ed));
edge_detector ed_stop_f_t (.clock(clock), .reset(reset), .din(stop_f_t), .rising(stop_f_t_ed));
edge_detector ed_update (.clock(clock), .reset(reset), .din(update), .rising(update_ed));

// edge_detector_sintese ed_start_f (.clock(clock), .reset(reset), .din(start_f), .rising(start_f_ed));
// edge_detector_sintese ed_start_t (.clock(clock), .reset(reset), .din(start_t), .rising(start_t_ed));
// edge_detector_sintese ed_stop_f_t (.clock(clock), .reset(reset), .din(stop_f_t), .rising(stop_f_t_ed));
// edge_detector_sintese ed_update (.clock(clock), .reset(reset), .din(update), .rising(update_ed));

dcm dcm (
    .clock(clock),
    .reset(reset),
    .update(update_ed),
    .prog_in(prog),
    .clock_1(clock_1),
    .clock_2(clock_2),
    .prog_out(prog_out)
);

dm dm (
    .reset(reset), 
    .clock(clock), 
    .prog(prog), 
    .module_sig(module_reg), 
    .data_2(data_2), 
    .an(an), 
    .dec_ddp(dec_ddp)
);

fibonacci fib (
    .reset(reset),
    .clock_1(clock_1),
    .f_en(f_en),
    .f_valid(f_valid),
    .f_out(f_out)
);

timer t (
    .reset(reset),
    .clock_1(clock_1),
    .t_en(t_en),
    .t_valid(t_valid),
    .t_out(t_out)
);

wrapper wrp (
    .reset(reset),
    .clock_1(clock_1),
    .clock_2(clock_2),
    .data_1_en(data_1_en),
    .data_1(data_1),
    .buffer_empty(buffer_empty),
    .buffer_full(buffer_full),
    .data_2_valid(data_2_valid),
    .data_2(data_2)
);



always @(posedge clock or posedge reset) begin
    if (reset) begin
        EA <= `S_IDLE;
    end
    else begin
        EA <= PE;
    end
end

always @(*) begin
    case (EA)

        `S_IDLE: begin
            if (start_f_ed) begin
                PE = `S_COMM_F;
            end
            else if (start_t_ed) begin
                PE = `S_COMM_T;
            end
            else begin       
                PE = `S_IDLE; 
            end  
        end

        `S_COMM_F: begin
            if (stop_f_t_ed) begin
                PE = `S_BUFF_EMPTY;
            end
            else if (buffer_full) begin
                PE = `S_WAIT_F;
            end
            else begin       
                PE = `S_COMM_F; 
            end  
        end

        `S_WAIT_F: begin
            if (stop_f_t_ed) begin
                PE = `S_BUFF_EMPTY;
            end
            else if (!buffer_full) begin
                PE = `S_COMM_F;
            end          
            else begin       
                PE = `S_WAIT_F; 
            end  
        end

        `S_COMM_T: begin
            if (stop_f_t_ed) begin
                PE = `S_BUFF_EMPTY;
            end
            else if (buffer_full) begin
                PE = `S_WAIT_T;
            end
            else begin       
                PE = `S_COMM_T; 
            end
        end

        `S_WAIT_T: begin
            if (stop_f_t_ed) begin
                PE = `S_BUFF_EMPTY;
            end
            else if (!buffer_full) begin
                PE = `S_COMM_T;
            end   
            else begin       
                PE = `S_WAIT_T; 
            end
        end

        `S_BUFF_EMPTY: begin
            if (buffer_empty && !data_2_valid) begin
                PE = `S_IDLE;
            end
            else begin
                PE = `S_BUFF_EMPTY;
            end
        end        

        default: PE = `S_IDLE;

    endcase 
end

always @(*) begin
    case (EA)

        `S_IDLE: begin
            f_en = 1'b0;
            t_en = 1'b0;
            module_reg = 2'b00;
            data_1 = 16'b0;
            led = 6'b000001;
        end

        `S_COMM_F: begin
            f_en = 1'b1;
            t_en = 1'b0;
            module_reg = 2'b01;
            data_1 = f_out;
            led = 6'b000010;
        end

        `S_WAIT_F: begin
            f_en = 1'b0;
            t_en = 1'b0;
            module_reg = 2'b01;
            data_1 = f_out;
            led = 6'b000100;
        end

        `S_COMM_T: begin
            f_en = 1'b0;
            t_en = 1'b1;
            module_reg = 2'b11;
            data_1 = t_out;
            led = 6'b001000;
        end

        `S_WAIT_T: begin
            f_en = 1'b0;
            t_en = 1'b0;
            module_reg = 2'b11;
            data_1 = t_out;
            led = 6'b010000;
        end

        `S_BUFF_EMPTY: begin
            f_en = 1'b0;
            t_en = 1'b0;
            module_reg = 2'b00;
            data_1 = 16'b0;
            led = 6'b100000;
        end        

        default: begin
            f_en = 1'b0;
            t_en = 1'b0;
            module_reg = 2'b00;
            data_1 = 16'b0;
            led = 6'b000001;
        end

    endcase 
end

endmodule
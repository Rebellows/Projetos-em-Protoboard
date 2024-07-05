module dm (
    input reset, clock,
    input [2:0] prog,
    input [1:0] module_sig,
    input [15:0] data_2,
    output [7:0] an, dec_ddp
);

dspl dspl (.clock(clock), .reset(reset), 
           .d1({1'b1, data_2[3:0], 1'b0}), 
           .d2({1'b1, data_2[7:4], 1'b0}), 
           .d3({1'b1, data_2[11:8], 1'b0}), 
           .d4({1'b1, data_2[15:12], 1'b0}), 
           .d5(6'b0), 
           .d6({1'b1, (2'b0, module_sig), 1'b0}), 
           .d7(6'b0), 
           .d8({1'b1, {1'b0, prog}, 1'b0}), 
           .an(an), .dec_cat(dec_ddp))

endmodule

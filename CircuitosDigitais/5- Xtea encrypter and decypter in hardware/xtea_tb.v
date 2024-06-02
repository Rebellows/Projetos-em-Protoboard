module tb;
  reg clock, reset, start, configuration;
  reg [127:0] data_i, key;
  wire ready, busy;
  wire [127:0] data_o;

  top top (.reset(reset), .clock(clock), .start(start), .configuration(configuration), .data_i(data_i), .key(key), .ready(ready), .busy(busy), .data_o(data_o));

  initial begin
    clock = 0;
    reset = 1;
    #5 reset = 0;
    configuration = 0;
    data_i = 0;
    start = 0;
    key = 0;

    #10
    
    // Caso de teste 1: Encripta��o
    // data_i = 128'h089975E92555F334CE76E4F24D932AB3;
    data_i = 128'hA5A5A5A501234567FEDCBA985A5A5A5A;
    key = 128'hDEADBEEF0123456789ABCDEFDEADBEEF;  
    configuration = 1; 
    #5 start = 1;
    #5 start = 0;

    wait (ready);
   
    #100

    // Caso de teste 2: Decripta��o 
    data_i = 128'h89975E92555F334CE76E4F24D932AB3;
    key = 128'hDEADBEEF0123456789ABCDEFDEADBEEF;  
    configuration = 0; 
    #5 start = 1;
    #5 start = 0;

    wait (ready);

    #100

    //Caso de teste 3: Encripta��o
    data_i = 128'h617F219EB43D85942C6EE9BCC4CBBBB0;
    key = 128'hABEDDEBA5432112345DABEEBAD;
    configuration = 1;
    #5 start = 1;
    #5 start = 0;

    wait (ready);

    #100

    //Caso de teste 4: Decripta��o
    data_i = 128'h617F219EB43D85942C6EE9BCC4CBBBB0;
    key = 128'hABEDDEBA5432112345DABEEBAD;
    configuration = 0;  
    #5 start = 1;
    #5 start = 0;

    wait (ready);

    #100

    //Caso de teste 5: Encripta��o
    data_i = 128'h60BCB493C5D96C2A46291816b0B9808E;
    key = 128'hFEEDAFAAF097213312790ABCDEFEEDAFA; 
    configuration = 1;
    #5 start = 1;
    #5 start = 0;

    wait (ready);

    #100

    //Caso de teste 6: Decripta��o
    data_i = 128'h60BCB493C5D96C2A46291816b0B9808E;
    key = 128'hFEEDAFAAF097213312790ABCDEFEEDAFA; 
    configuration = 0; 
    #5 start = 1;
    #5 start = 0;

    wait (ready);

    #100

    //Caso de teste 7: Encripta��o
    data_i = 128'h4E981F909E682D99B4BD3D8376155852;
    key = 128'hDDDCBA056789987650ABCDDD; 
    configuration = 1;
    #5 start = 1;
    #5 start = 0;

    wait (ready);

    #100

    //Caso de teste 8: Decripta��o
    data_i = 128'h4E981F909E682D99B4BD3D8376155852;
    key = 128'hDDDCBA056789987650ABCDDD; 
    configuration = 0; 
    #5 start = 1;
    #5 start = 0;

    wait (ready);

    #100

    //Caso de teste 9: Encripta��o
    data_i = 128'hFA531DC8E6853E097FC834135022AD5F;
    key = 128'hDADEAFDEED0123456789FEADDEEDDA; 
    configuration = 1;
    #5 start = 1;
    #5 start = 0;

    wait (ready);

    #100

    //Caso de teste 10: Decripta��o 
    data_i = 128'hFA531DC8E6853E097FC834135022AD5F;
    key = 128'hDADEAFDEED0123456789FEADDEEDDA;  
    configuration = 0; 
    #5 start = 1;
    #5 start = 0;

    wait (ready);

  end

  always #5 clock = ~clock;

endmodule


module Testbench;
  
  reg clk, x, rs;
  
  reg data_in;
  wire data_out;
  wire [4:0] z;
  
  connect_modules connect1(clk, x, rs, data_in, data_out, z);
      
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
      clk=1;
      x=1;
      rs=0;
      data_in = 1;
      #50 rs=1;
      #10 rs=0;
      #10 x=0;
      #10 x=1;
      #10 data_in=1;
      #10 data_in=0;
      #10 data_in=0; 
      #10 data_in=1;
      #10 data_in=1;
      #10 data_in=1;
      #10 data_in=0; 
      #10 data_in=1;
      #10 x=0;
      #10 x=0;
      #10 data_in=0;
      #10 x=1;
      #10 x=0;
      #10 x=0;
      #10 x=1;
      #10 data_in=0;
      #10 data_in=0;
      #10 data_in=0; 
      #10 data_in=0;
      #10 x=0;
      #10 x=0;
      #10 x=1;
      #10 data_in=0;
      #10 data_in=0;
      #10 data_in=0;
      #10 data_in=1;
      #10 data_in=0;
      x=0;
      //#10 data_in=0;
      #10 x=0;
      #10 x=0;
      #10 x=1;
      #10 data_in=0;
      #10 data_in=1;
      #10 data_in=0; 
      #10 data_in=1;
      x=0;
      #10 x=0;
      #10 x=0;
      #10 x=1;
      #10 data_in=1;
      #10 data_in=0;
      #10 data_in=0; 
      #10 data_in=0;
      #10 data_in=0;
      #10 data_in=0; 
      #10 data_in=1;
      x=0;
      #10 x=0;
      #10 x=0;
      #10 x=1;
      #10 data_in=0;
      #10 data_in=1; 
      #10 data_in=0;
      #10 data_in=1;
      #10 x=0;
      #10 x=1;
      #10 x=0;
      #10 x=1;
      #10 data_in=0;
      #10 data_in=1; 
      #10 data_in=0;
      #10 data_in=1;
      #10 x=0;
      
      $finish;
    end
  always #5 clk <= ~clk;
  
endmodule

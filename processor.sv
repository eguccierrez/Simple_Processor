module connect_modules(clk,x,rs,data_in,data_out,z);
  input clk,x,rs,data_in;
  output data_out;
  output [4:0] z;
  wire rst,run,shift,update;
  
  StateMachine fsm1(clk,x,rs,rst,shift,update,run);
  control_unit control1(clk,data_in,rst,run,shift,update,data_out,z);
  
endmodule
  
  
  
  
  
  
module StateMachine(clk,x,rs,rst,shift,update,run);
  input clk,x,rs;
  output reg rst,shift,update,run;
  reg [3:0] state;
  
  //Define states
  parameter RS=4'b0001,  //Reset
			RI=4'b0010,  //Run/Idle
  			SH=4'b0100,  //Shift
  			UP=4'b1000;  //Update
  
  initial state=4'b1111;
  initial rst=0;
  initial shift=0;
  initial update=0;
  initial run=0;
  
  always@(posedge clk)begin
    if(rs)begin  //if rs==1, go to state RS
      state<=RS;
    end
    
    if(state==4'b1111)begin
    end
 
    case(state)
      RS:
        begin
          rst<=1;
          if(x)begin
            state<=RS;
          end
          else begin
            state<=RI;
          end
        end
      RI:
        begin
          run<=1;
          if(x)begin
            state<=SH;
          end
          else begin
            state<=RI;
          end
        end
      SH:
        begin
          shift<=1;
          if(x)begin
            state<=SH;
          end
          else begin
            state<=UP;
          end
        end
      UP:
        begin
          update<=1;
          if(x)begin
            state<=RS;
          end
          else begin
            state<=RI;
          end
        end
    endcase
  end
  always@(negedge clk)begin
    if(state==RS)begin
      rst<=1;
      shift<=0;
      update<=0;
      run<=0;
    end
    else if(state==RI)begin
      rst<=0;
      shift<=0;
      update<=0;
      run<=1;
    end
    else if(state==SH)begin
      rst<=0;
      shift<=1;
      update<=0;
      run<=0;
    end
    else if(state==UP)begin
      rst<=0;
      shift<=0;
      update<=1;
      run<=0;
    end
  end

endmodule
  
  
  
module control_unit(clk,data_in,rst,run,shift,update,data_out,z);
  input clk,data_in,rst,run,shift,update;
  output data_out;

  parameter INITLZ_MEM=2'b00,
  			ARITH=2'b01,
  			LOGIC=2'b10,
  			BUFFER=2'b11;
  output reg [4:0] z;
  reg [3:0] mem [3:0];
  reg [7:0] shift_reg,shadow_reg;
  reg data_out;
  initial data_out=0;
  
  always@(posedge clk)begin
    if(rst)begin
      shift_reg=0;
      shadow_reg=0;
      mem[3]=0;
      mem[2]=0;
      mem[1]=0;
      mem[0]=0;
    end
    
    if(shift)begin
      data_out=shift_reg[0];
      shift_reg={data_in,shift_reg[7:1]};
    end
    
    if(update)begin
      shadow_reg=shift_reg;
    end
    
    if(run)begin
      if(shadow_reg[7:6]==INITLZ_MEM)begin
        mem[shadow_reg[5:4]]=shadow_reg[3:0];
      end
      if(shadow_reg[7:6]==ARITH)begin
        if(shadow_reg[5]==0)begin
          z=mem[shadow_reg[3:2]]+mem[shadow_reg[1:0]];
        end
        if(shadow_reg[5]==1)begin
          z=mem[shadow_reg[3:2]]-mem[shadow_reg[1:0]];
        end
      end
      if(shadow_reg[7:6]==LOGIC)begin
        if(shadow_reg[5]==0)begin
          z=mem[shadow_reg[3:2]]&mem[shadow_reg[1:0]];
        end
        if(shadow_reg[5]==1)begin
          z=mem[shadow_reg[3:2]]|mem[shadow_reg[1:0]];
        end
      end
      if(shadow_reg[7:6]==BUFFER)begin
        z=shadow_reg[4:0];
      end
    end
  end
    endmodule

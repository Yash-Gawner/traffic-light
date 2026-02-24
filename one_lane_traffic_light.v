module one_lane_traffic_light(
    input clk,
    input rst,
    input pedstrian_button,
    output reg red,
    output reg green,
    output reg yellow
);

reg [1:0]state , next_state;
reg [3:0]timer;
reg sec_tick;
//reg [25:0]count;
reg [5:0]count;

parameter s0 = 2'b00,  //green
          s1 = 2'b01,  //yellow 
          s2 = 2'b10;  //red

// 1 sec logic 
always @(posedge clk or posedge rst)begin
  
  if(rst)begin
  sec_tick <= 0;
  count <=0;
  end

  // here 50MHz if FPGA clock cycle 
 // else if(count == 50000000 -1)begin
  else if(count == 50 -1)begin
  sec_tick <= 1;
  count <= 0;
  end

  else begin
  sec_tick <= 0;
  count <= count + 1;
  end

end

always @(posedge clk or posedge rst)begin
  
   if(rst)
   timer <= 0;

   else if (sec_tick)begin
     
     if(state != next_state)
     timer <= 0;

     else
     timer <= timer +1;
   end
end

always @(posedge clk or posedge rst)begin
  
  if(rst)
  state <= s0;

  else
  state <= next_state;
end

always @(*)begin
 
case(state)
 s0 : begin
   if(timer == 10)
   next_state = s1;

   else if(timer >= 5 && pedstrian_button)
   next_state = s1;

   else
   next_state = s0;
 end

 s1 : begin
   if(timer == 3)
   next_state = s2;

   else
   next_state = s1;
 end

 s2: begin
   if(timer == 10)
   next_state = s0;

   else 
   next_state = s2;
 end

 default : next_state = s0;
endcase
end

always @(*)begin
   red = 0;
   green = 0;
   yellow = 0;

  case(state)
  s0 : green = 1;
  s1 : yellow = 1;
  s2 : red = 1;
  endcase
end
endmodule 
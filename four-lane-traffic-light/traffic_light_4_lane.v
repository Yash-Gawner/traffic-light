module traffic_light_4_lane(
    input clk,
    input rst,
    input pedestrian_ns,
    input pedestrian_ew,
    output reg ns_green,
    output reg ns_yellow,
    output reg ns_red,
    output reg ew_green,
    output reg ew_red,
    output reg ew_yellow
);

parameter s0 = 2'b00,  // ns_green
          s1 = 2'b01,  // ns_yellow
          s2 = 2'b10,  // ew_green
          s3 = 2'b11;  // ew_yellow

reg [1:0]state , next_state;
reg tick_time;
reg [3:0]timer;
//reg [25:0]count; //fsm clk is 50MHz so 26 bits is sufficient
reg [5:0]count;  // for testbench
// fsm clock logic
always @(posedge clk or posedge rst)begin
  
  if(rst)begin
    tick_time <= 0;
    count <= 0;
  end

   else if(count == 50 - 1) begin // to write testbench.
  //else if(count == 50000000 -1)begin
    tick_time <= 1;
    count <= 0;
  end

  else begin
    tick_time <= 0;
    count <= count + 1;
  end
end

// timer concept 
always @(posedge clk or posedge rst)begin
  
  if(rst)
  timer <= 0;

  else if(tick_time)begin
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
  next_state = state;

  case(state)

  // ns green
  s0 : begin
    if(timer == 15)
    next_state = s1;

    else if(timer >= 7 && pedestrian_ns)
    next_state = s1;

    else
    next_state = s0;
  end
  
  // ns_yellow
  s1 : begin
    if(timer == 4)
    next_state = s2;

    else 
    next_state = s1;
  end
  
  // ew_green
  s2 : begin
    if(timer == 15)
    next_state = s3;

    else if(timer >= 7 && pedestrian_ew)
    next_state = s3;

    else 
    next_state = s2;
  end
  
  // ew_yellow
  s3 : begin
    if(timer == 4)
    next_state = s0;
    
    else 
    next_state = s3;
  end

  default : next_state = s0;
 endcase
end

always @(*)begin
    ns_green  = 0;
    ns_yellow = 0;
    ns_red    = 0;
    ew_green  = 0;
    ew_red    = 0;
    ew_yellow = 0;
  case(state)

  s0 : begin
    ns_green =1;
    ew_red =1;
  end

  s1 : begin
    ns_yellow =1;
    ew_red =1;
  end

  s2 : begin
    ns_red = 1;
    ew_green =1;
  end

  s3 : begin
    ns_red = 1;
    ew_yellow =1;
  end
  endcase
end
endmodule
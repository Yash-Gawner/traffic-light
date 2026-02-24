`timescale 1ns/1ps

module tb_one_lane_traffic_light;
reg clk, rst, pedstrian_button;
wire red ,green,yellow ;

one_lane_traffic_light uut(
    .clk(clk),
    .rst(rst),
    .pedstrian_button(pedstrian_button),
    .red(red),
    .green(green),
    .yellow(yellow)
);

always #10 clk = ~clk;

initial begin
$dumpfile("tb_one_lane_traffic_light.vcd");
$dumpvars(0, tb_one_lane_traffic_light);
  $monitor("Time=%0t | R=%b G=%b Y=%b | Ped=%b",
              $time, red, green, yellow, pedstrian_button);
  
  clk =0; 
  rst =1;
  pedstrian_button =1;

    #50 rst = 0;

    #6000 pedstrian_button = 1;
    #100  pedstrian_button = 0;

    #40000;

    $finish;
end
endmodule 
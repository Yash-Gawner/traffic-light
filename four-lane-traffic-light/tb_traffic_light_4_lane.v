`timescale 1ns/1ps

module tb_traffic_light_4_lane;
reg clk, rst, pedestrian_ew, pedestrian_ns;
wire ew_green, ew_red, ew_yellow, ns_green, ns_red, ns_yellow;

traffic_light_4_lane uut(
    .clk(clk),
    .rst(rst),
    .pedestrian_ew(pedestrian_ew),
    .pedestrian_ns(pedestrian_ns),
    .ew_green(ew_green),
    .ew_yellow(ew_yellow),
    .ew_red(ew_red),
    .ns_green(ns_green),
    .ns_yellow(ns_yellow),
    .ns_red(ns_red)
);

always #5 clk = ~clk;

initial begin
  
  $dumpfile("tb_traffic_light_4_lane.vcd");
  $dumpvars(0, tb_traffic_light_4_lane);
  // taken from gpt
  $monitor("Time=%0t | State=%0d | NS[G Y R]=%b %b %b | EW[G Y R]=%b %b %b | ped_ns=%b ped_ew=%b",
              $time, uut.state, ns_green, ns_yellow, ns_red,
              ew_green, ew_yellow, ew_red, pedestrian_ns, pedestrian_ew);

  clk =0;
  rst =1;
  pedestrian_ew =0;
  pedestrian_ns =0;

    #20;
    rst = 0;

    #2000;

    pedestrian_ew = 1;
    #20;
    pedestrian_ew = 0;

    #2000;

    pedestrian_ns = 1;
    #20;
    pedestrian_ns = 0;

    #100000;

    $finish;

end
endmodule
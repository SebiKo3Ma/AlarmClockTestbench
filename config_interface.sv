interface aclk_tconfig_if(input clk); // A 10Hz input clock (used to generate real-time seconds)
  logic       reset; // Active high reset pulse to set time, alarm to 00:00:00
  logic [1:0] H_in1; // MSB hour digit for setting clock or alarm
  logic [3:0] H_in0; // LSB hour digit for setting clock or alarm
  logic [3:0] M_in1; // MSB minute digit for setting clock or alarm
  logic [3:0] M_in0; // LSB minute digit for setting clock or alarm
  
  logic       LD_time;  // If 1, load the clock with inputs H_in1, H_in0, M_in1, M_in0
  logic       LD_alarm; // If 1, load the alarm with inputs H_in1, H_in0, M_in1, M_in0
  
  logic [1:0] H_out1;   // Most significant digit of the hour
  logic [3:0] H_out0;   // Least significant digit of the hour
  logic [3:0] M_out1;   // Most significant digit of the minute
  logic [3:0] M_out0;   // Least significant digit of the minute
  logic [3:0] S_out1;   // Most significant digit of the second
  logic [3:0] S_out0;   // Least significant digit of the second

bit tb_clk;
logic [3:0] counter;

task do_reset();
    tb_clk = 1'b0;
    counter = 4'b0;
    init();
endtask

always @(posedge clk) begin
    if(counter == 4'b0100) begin
        counter <= 4'b0000;
        tb_clk <= ~tb_clk;
    end else
        counter <= counter + 1;
end

clocking driver_clk @(posedge tb_clk);
    output reset;
    output H_in1;
    output H_in0;
    output M_in1;
    output M_in0;
    output LD_time;
    output LD_alarm;

    //daca e nevoie, pune outputul DUT-ului ca input aici (in log de event ready)
endclocking

clocking monitor_clk @(posedge tb_clk);
    input reset;
    input H_in1;
    input H_in0;
    input M_in1;
    input M_in0;
    input LD_time;
    input LD_alarm;

    input H_out1;
    input H_out0;
    input M_out1;
    input M_out0;
    input S_out1;
    input S_out0;
endclocking

property valid_hours;
    @(monitor_clk)
    H_out1 == 2'd2 -> H_out0 < 4'd4;
endproperty


    // assert property (valid_hours) begin
    //     //do nothing
    // end else 
    //     $error("FAIL: Invalid hour set");


  //set all the inputs on the default value
task init();
    reset    = 1'b1;
    H_in1    = 2'b0;
    H_in0    = 4'b0;
    M_in1    = 4'b0;
    M_in0    = 4'b0;
    LD_time  = 1'b0;
    LD_alarm = 1'b0;
    #10 reset = 1'b0;
endtask 
  
endinterface

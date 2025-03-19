interface aclk_alop_if(input clk); // A 10Hz input clock (used to generate real-time seconds)
  logic       STOP_al;  // If 1, stop the alarm (set Alarm output low)
  logic       AL_ON;     // If high, the alarm function is ON
  
  logic       Alarm;    // If time matches alarm and AL_ON is high, Alarm goes high

bit tb_clk;
logic [3:0] counter;

task do_reset();
    tb_clk = 1'b0;
    counter = 4'b0;
    init();
endtask

always @(posedge clk) begin
    if(counter == 4'b0101) begin
        counter <= 4'b0000;
        tb_clk <= ~tb_clk;
    end else
        counter <= counter + 1;
end

clocking driver_clk @(posedge tb_clk);
    output STOP_al;
    output AL_ON;
endclocking

clocking monitor_clk @(posedge tb_clk);
    input STOP_al;
    input AL_ON;
    input Alarm;
endclocking

  // set all the inputs on the default value
task init();
    STOP_al  = 1'b0;
    AL_ON    = 1'b0;
endtask 
  
endinterface

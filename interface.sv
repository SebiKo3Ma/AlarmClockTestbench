interface aclk_if(input clk); // A 10Hz input clock (used to generate real-time seconds)
  logic       reset; // Active high reset pulse to set time, alarm to 00:00:00
  logic [1:0] H_in1; // MSB hour digit for setting clock or alarm
  logic [3:0] H_in0; // LSB hour digit for setting clock or alarm
  logic [3:0] M_in1; // MSB minute digit for setting clock or alarm
  logic [3:0] M_in0; // LSB minute digit for setting clock or alarm
  
  logic       LD_time;  // If 1, load the clock with inputs H_in1, H_in0, M_in1, M_in0
  logic       LD_alarm; // If 1, load the alarm with inputs H_in1, H_in0, M_in1, M_in0
  logic       STOP_al;  // If 1, stop the alarm (set Alarm output low)
  logic       AL_ON;     // If high, the alarm function is ON
  
  logic       Alarm;    // If time matches alarm and AL_ON is high, Alarm goes high
  
  logic [1:0] H_out1;   // Most significant digit of the hour
  logic [3:0] H_out0;   // Least significant digit of the hour
  logic [3:0] M_out1;   // Most significant digit of the minute
  logic [3:0] M_out0;   // Least significant digit of the minute
  logic [3:0] S_out1;   // Most significant digit of the second
  logic [3:0] S_out0;   // Least significant digit of the second
    
  // set all the inputs on the default value
  function do_reset();
    reset    = 1'b1;
    H_in1    = 2'b0;
    H_in0    = 4'b0;
    M_in1    = 4'b0;
    M_in0    = 4'b0;
    LD_time  = 1'b0;
    LD_alarm = 1'b0;
    STOP_al  = 1'b0;
    AL_ON    = 1'b0;
  endfunction
  
  // the transaction received will be sent to the interface
  task send_sig(transaction trans);
    reset    <= trans.reset;
    H_in1    <= trans.H_in1;
    H_in0    <= trans.H_in0;
    M_in1    <= trans.M_in1;
    M_in0    <= trans.M_in0;
    LD_time  <= trans.LD_time;
    LD_alarm <= trans.LD_alarm;
    STOP_al  <= trans.STOP_al;
    AL_ON    <= trans.AL_ON;
  endtask
  
  // the transaction received will be sent to the interface
  function transaction get_sig();
    automatic transaction trans = new();
    trans.reset    = reset;
    trans.H_in1    = H_in1;
    trans.H_in0    = H_in0;
    trans.M_in1    = M_in1;
    trans.M_in0    = M_in0;
    trans.LD_time  = LD_time;
    trans.LD_alarm = LD_alarm;
    trans.STOP_al  = STOP_al;
    trans.AL_ON    = AL_ON;
    
    trans.Alarm    = Alarm;
    trans.H_out1   = H_out1;
    trans.H_out0   = H_out0;
    trans.M_out1   = M_out1;
    trans.M_out0   = M_out0;
    trans.S_out1   = S_out1;
    trans.S_out0   = S_out0;
    
    return trans;
  endfunction
  
endinterface

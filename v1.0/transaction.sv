class transaction;
  rand logic       reset;
  rand logic [1:0] H_in1;
  rand logic [3:0] H_in0;
  rand logic [3:0] M_in1;
  rand logic [3:0] M_in0;

  rand logic       LD_time;
  rand logic       LD_alarm;
  rand logic       STOP_al;
  rand logic       AL_ON;
    
       logic       Alarm;
       logic [1:0] H_out1;
       logic [3:0] H_out0;
       logic [3:0] M_out1;
       logic [3:0] M_out0;
       logic [3:0] S_out1;
       logic [3:0] S_out0;
  
  //Constructor
  function new();
  endfunction
  
  constraint mostly_inactive_reset{
    reset dist {0:/19, 1:/1};
  }

  constraint validTime{
    H_in1 <= 2;
    H_in0 <= 9;
    H_in1 == 2 -> H_in0 <= 3;
    M_in1 <= 5;
    M_in0 <= 9;
  }
  
  constraint few_concurrent_loads{
    LD_time && LD_alarm dist {1:/1, 0:/19};
  }

  constraint alarm_mostly_on{
    AL_ON dist {1:/19, 0:/1};
  }

  constraint few_irrelevant_stops{
    (!AL_ON) -> STOP_al dist {1:/1, 0:/9};
    STOP_al dist {1:/1, 0:/10};
  }

  function void display(string name = "");
    $write("%0s: %3t - reset: %1b, time_input: %1d%1d:%1d%1d, time_output: %1d%1d:%1d%1d:%1d%1d, LD_time: %1b, LD_alarm: %1b, STOP_al: %1b, AL_ON: %1b, Alarm: %1d\n", 
    name, $time, reset, H_in1, H_in0, M_in1, M_in0, H_out1, H_out0, M_out1, M_out0, S_out1, S_out0,
    LD_time, LD_alarm, STOP_al, AL_ON, Alarm);
  endfunction
  
  function void do_copy(transaction trans);
    this.reset    = trans.reset;
    this.H_in1    = trans.H_in1;
    this.H_in0    = trans.H_in0;
    this.M_in1    = trans.M_in1;
    this.M_in0    = trans.M_in0;
    this.LD_time  = trans.LD_time;
    this.LD_alarm = trans.LD_alarm;
    this.STOP_al  = trans.STOP_al;
    this.AL_ON    = trans.AL_ON;

    this.Alarm    = trans.Alarm;
    this.H_out1   = trans.H_out1;
    this.H_out0   = trans.H_out0;
    this.M_out1   = trans.M_out1;
    this.M_out0   = trans.M_out0;
    this.S_out1   = trans.S_out1;
    this.S_out0   = trans.S_out0;
  endfunction

  function bit do_compare(transaction trans);
    if(this.Alarm    !== trans.Alarm)   return 0;
    if(this.H_out1   !== trans.H_out1)  return 0;
    if(this.H_out0   !== trans.H_out0)  return 0;
    if(this.M_out1   !== trans.M_out1)  return 0;
    if(this.M_out0   !== trans.M_out0)  return 0;
    if(this.S_out1   !== trans.S_out1)  return 0;
    if(this.S_out0   !== trans.S_out0)  return 0;
    return 1;
  endfunction
endclass



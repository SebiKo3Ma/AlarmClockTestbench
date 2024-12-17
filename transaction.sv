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
    H_in2 == 2 -> H_in0 <= 4;
    M_in1 <= 6;
  }
  
  constraint few_concurrent_loads{
    LD_time  -> !LD_alarm dist {1:/19, 0:/1};
    LD_alarm -> !LD_time  dist {1:/19, 0:/1};
  }
  
  constraint data_only_when_write_enable{
    write_en  -> data_in inside {['h00:'hFF]};
    !write_en -> data_in == 'h00;
  }

  function void display(string name = "");
    $write("%0s: %3t - reset: %1b, time_input: %1b%1b:%1b%1b, LD_time: %1b, LD_Alarm: %1b, STOP_al: %1b, AL_ON: %1b", name, $time, H_in1, H_in2, M_in1, M_in2, LD_time, LD_Alarm, STOP_al, AL_ON);
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
endclass



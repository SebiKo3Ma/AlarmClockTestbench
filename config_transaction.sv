class config_transaction extends transaction #(config_transaction);
  rand logic       reset;
  rand logic [1:0] H_in1;
  rand logic [3:0] H_in0;
  rand logic [3:0] M_in1;
  rand logic [3:0] M_in0;

  rand logic       LD_time;
  rand logic       LD_alarm;

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
  
  constraint few_concurrent_loads{
    LD_time && LD_alarm dist {1:/1, 0:/19};
  }

  function void display(string name = "");
    $write("%0s: %4t - reset: %1b, time_input: %1d%1d:%1d%1d, time_output: %1d%1d:%1d%1d:%1d%1d, LD_time: %1b, LD_alarm: %1b\n", 
    name, $time, reset, H_in1, H_in0, M_in1, M_in0, H_out1, H_out0, M_out1, M_out0, S_out1, S_out0, LD_time, LD_alarm);
  endfunction
  
  function void do_copy(config_transaction trans);
    this.reset    = trans.reset;
    this.H_in1    = trans.H_in1;
    this.H_in0    = trans.H_in0;
    this.M_in1    = trans.M_in1;
    this.M_in0    = trans.M_in0;
    this.LD_time  = trans.LD_time;
    this.LD_alarm = trans.LD_alarm;

    this.H_out1   = trans.H_out1;
    this.H_out0   = trans.H_out0;
    this.M_out1   = trans.M_out1;
    this.M_out0   = trans.M_out0;
    this.S_out1   = trans.S_out1;
    this.S_out0   = trans.S_out0;
  endfunction

  function bit do_compare(config_transaction trans);
    if(this.H_in1    !== trans.H_in1)  return 0;
    if(this.H_in0    !== trans.H_in0)  return 0;
    if(this.M_in1    !== trans.M_in1)  return 0;
    if(this.M_in0    !== trans.M_in0)  return 0;

    if(this.LD_time  !== trans.LD_time)  return 0;
    if(this.LD_alarm !== trans.LD_alarm)  return 0;

    if(this.H_out1   !== trans.H_out1)  return 0;
    if(this.H_out0   !== trans.H_out0)  return 0;
    if(this.M_out1   !== trans.M_out1)  return 0;
    if(this.M_out0   !== trans.M_out0)  return 0;
    if(this.S_out1   !== trans.S_out1)  return 0;
    if(this.S_out0   !== trans.S_out0)  return 0;
    return 1;
  endfunction
endclass

class cr_config_transaction extends config_transaction;
  function new();
    super.new();
    this.tr_type = CR;
  endfunction

  constraint validTime{
    H_in1 <= 2;
    H_in0 <= 9;
    H_in1 == 2 -> H_in0 <= 3;
    M_in1 <= 5;
    M_in0 <= 9;
  }

  constraint high_time{
    H_in1 == 2   dist {1:/7, 0:/3};
    if(H_in1 == 2)
      H_in0 > 2  dist{1:/8, 0:/2};
    else
      H_in0 > 7  dist {1:/9, 0:/1};
    M_in1 > 4    dist{1:/6, 0:/4};
    M_in0 > 7    dist {1:/9, 0:/1};
  }
endclass

class op_config_transaction extends config_transaction;
  function new();
    super.new();
    this.tr_type = OP;
  endfunction

  constraint validTime{
    H_in1 <= 2;
    H_in0 <= 9;
    H_in1 == 2 -> H_in0 <= 3;
    M_in1 <= 5;
    M_in0 <= 9;
  }
endclass

class il_config_transaction extends config_transaction;
  function new();
    super.new();
    this.tr_type = IL;
  endfunction

  constraint illegal_time{
    H_in1 >= 2;
    if(H_in1 == 2)
      H_in0 >= 5;
    else 
      H_in0 >= 10;

    M_in1 >= 6;
    M_in0 >= 10;
  }
endclass



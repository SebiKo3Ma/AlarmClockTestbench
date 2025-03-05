class alarm_transaction extends transaction #(alarm_transaction);
  rand logic STOP_al;
  rand logic AL_ON;

       logic Alarm;
  
  //Constructor
  function new();
    this.tr_type = AL;
  endfunction
  
  constraint alarm_mostly_on{
    AL_ON dist {1:/19, 0:/1};
  }

  constraint few_irrelevant_stops{
    (!AL_ON) -> STOP_al dist {1:/1, 0:/9};
    STOP_al dist {1:/1, 0:/10};
  }

  function void display(string name = "");
    $write("%0s: %3t - AL_ON: %1b, STOP_al: %1b, Alarm: %1b\n", 
    name, $time, AL_ON, STOP_al, Alarm);
  endfunction
  
  function void do_copy(alarm_transaction trans);
    this.STOP_al = trans.STOP_al;
    this.AL_ON   = trans.AL_ON;
    this.Alarm   = trans.Alarm;
  endfunction

  function bit do_compare(alarm_transaction trans);
    if(this.STOP_al !== trans.STOP_al) return 0;
    if(this.AL_ON   !== trans.AL_ON)   return 0;
    if(this.Alarm   !== trans.Alarm)   return 0;
    return 1;
  endfunction
endclass



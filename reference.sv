class reference;
    local int hour,
              minute,
              second,
              al_hour,
              al_minute;

    local int al_sound;

    config_transaction cfg_trans, cfg_trans_out;
    alarm_transaction al_trans, al_trans_out;

    function new();
        hour = 0;
        minute = 0;
        second = -1;
        al_hour = 0;
        al_minute = 0;
        al_sound = 0;
        cfg_trans_out = new();
        al_trans_out = new();
    endfunction

    function void getTime();
        if(!cfg_trans.LD_time) begin
            //increase time every second
            second = second + 1;
            if(second == 60) begin
                second = 0;
                minute = minute + 1;
                if(minute == 60) begin
                    minute = 0;
                    hour = hour + 1;
                    if(hour == 24) begin
                        hour = 0;
                    end
                end
            end
        end else begin
            //get the new time
            hour   = cfg_trans.H_in0 + 10 * cfg_trans.H_in1;
            minute = cfg_trans.M_in0 + 10 * cfg_trans.M_in1;
            second = 0;
        end
    endfunction

    function void getAlarm();
        if(cfg_trans.LD_alarm) begin
            //get new alarm time
            al_hour   = cfg_trans.H_in0 + 10 * cfg_trans.H_in1;
            al_minute = cfg_trans.M_in0 + 10 * cfg_trans.M_in1;
        end
    endfunction

    function void getReset();
        if(cfg_trans.reset) begin
            hour = 0;
            minute = 0;
            second = 0;
            al_hour = 0;
            al_minute = 0;
            al_sound = 0;
        end
    endfunction

    function int isAlarm();
        if(al_trans.AL_ON && !al_trans.STOP_al) begin
            if(hour == al_hour && minute == al_minute && second == 0) begin
                al_sound = 1;
            end
        end

        if(al_trans.STOP_al) begin
            al_sound = 0;
        end

        if(al_sound)
            return 1;
        else return 0;

    endfunction

    task process_config(mailbox mon2ref, ref config_transaction mon2cmp[$], ref config_transaction ref2cmp[$]);
        mon2ref.get(cfg_trans);
        getTime();
        getAlarm();
        getReset();

        cfg_trans_out = new();

        cfg_trans_out.reset  = cfg_trans.reset;

        cfg_trans_out.H_in0 = cfg_trans.H_in0;
        cfg_trans_out.H_in1 = cfg_trans.H_in1;
        cfg_trans_out.M_in0 = cfg_trans.M_in0;
        cfg_trans_out.M_in1 = cfg_trans.M_in1;

        cfg_trans_out.LD_time  = cfg_trans.LD_time;
        cfg_trans_out.LD_alarm = cfg_trans.LD_alarm;

        cfg_trans_out.H_out1 = (hour / 10) % 10;
        cfg_trans_out.H_out0 = hour % 10;
        cfg_trans_out.M_out1 = (minute / 10) % 10;
        cfg_trans_out.M_out0 = minute % 10;   
        cfg_trans_out.S_out1 = (second / 10) % 10;
        cfg_trans_out.S_out0 = second % 10;

        cfg_trans.display("\nMON_CFG:");
        cfg_trans_out.display("REF_CFG:");
        ref2cmp.push_back(cfg_trans_out);
        mon2cmp.push_back(cfg_trans);
    endtask

    task process_alarm(mailbox mon2ref, ref alarm_transaction mon2cmp[$], ref alarm_transaction ref2cmp[$]);
        mon2ref.get(al_trans);

        al_trans_out = new();

        al_trans_out.Alarm   = isAlarm();
        al_trans_out.STOP_al = al_trans.STOP_al;
        al_trans_out.AL_ON   = al_trans.AL_ON;
        al_trans.display("\nMON_AL:");
        al_trans_out.display("REF_AL:");    
        ref2cmp.push_back(al_trans_out);
        mon2cmp.push_back(al_trans);
    endtask

    task run(mailbox mon2ref_cfg, mailbox mon2ref_al, scoreboard_queues mon2cmp, scoreboard_queues ref2cmp);
        forever begin
            fork
                process_config(mon2ref_cfg, mon2cmp.cfg, ref2cmp.cfg);
                process_alarm(mon2ref_al, mon2cmp.al, ref2cmp.al);
            join_any
        end
    endtask
endclass
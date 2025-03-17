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
        second = 0;
        al_hour = 0;
        al_minute = 0;
        al_sound = 0;
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
            hour   = cfg_trans.H_in1 + 10 * cfg_trans.H_in0;
            minute = cfg_trans.M_in1 + 10 * cfg_trans.M_in0;
            second = 0;
        end
    endfunction

    function void getAlarm();
        if(cfg_trans.LD_alarm) begin
            //get new alarm time
            al_hour   = cfg_trans.H_in1 + 10 * cfg_trans.H_in0;
            al_minute = cfg_trans.M_in1 + 10 * cfg_trans.M_in0;
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

    task process_config(mailbox mon2cmp, config_transaction mon2cmp_q[$], config_transaction ref2cmp[$]);
        mon2cmp.get(cfg_trans);
        getTime();
        getAlarm();
        getReset();

        cfg_trans_out.H_in0  = cfg_trans.H_in0;
        cfg_trans_out.H_in1  = cfg_trans.H_in1;
        cfg_trans_out.M_out0 = cfg_trans.M_in0;
        cfg_trans_out.M_out1 = cfg_trans.M_in1;

        cfg_trans_out.LD_time  = cfg_trans.LD_time;
        cfg_trans_out.LD_alarm = cfg_trans.LD_alarm;

        cfg_trans_out.H_out1 = (hour / 10) % 10;
        cfg_trans_out.H_out0 = hour % 10;
        cfg_trans_out.M_out1 = (minute / 10) % 10;
        cfg_trans_out.M_out0 = minute % 10;   
        cfg_trans_out.S_out1 = (second / 10) % 10;
        cfg_trans_out.S_out0 = second % 10;

        ref2cmp.push_back(cfg_trans_out);
        mon2cmp_q.push_back(cfg_trans);
    endtask

    task process_alarm(mailbox mon2cmp, alarm_transaction mon2cmp_q[$], alarm_transaction ref2cmp[$]);
        mon2cmp.get(al_trans);        
        al_trans_out.Alarm   = isAlarm();
        al_trans_out.STOP_al = al_trans.STOP_al;
        al_trans_out.AL_ON   = al_trans.AL_ON;           
        ref2cmp.push_back(al_trans_out);
        mon2cmp_q.push_back(al_trans);
    endtask

    task run(mailbox mon2cmp_cfg, mailbox mon2cmp_al, config_transaction mon2cmp_cfg_q[$], alarm_transaction mon2cmp_al_q[$], config_transaction ref2cmp_cfg[$], alarm_transaction ref2cmp_al[$]);
        forever begin
            fork
                process_config(mon2cmp_cfg, mon2cmp_cfg_q, ref2cmp_cfg);
                process_alarm(mon2cmp_al, mon2cmp_al_q, ref2cmp_al);
            join_any
        end
    endtask
endclass
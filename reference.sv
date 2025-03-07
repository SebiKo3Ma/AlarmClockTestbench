class reference;
    local int hour,
              minute,
              second,
              al_hour,
              al_minute,
              al_second;

    local int al_sound;

    config_transaction cfg_trans, cfg_trans_out;
    alarm_transaction al_trans, al_trans_out;

    function new();
        hour = 0;
        minute = 0;
        second = 0;
        al_hour = 0;
        al_minute = 0;
        al_second = 0;
        al_sound = 0;
    endfunction

    function void process_config(mailbox mon2cmp);
        mon2cmp.get(cfg_trans);
    endfunction

    function void process_alarm(mailbox mon2cmp);
        mon2cmp.get(al_trans);        

    endfunction

    function void run(mailbox mon2cmp_cfg, mailbox mon2cmp_al);
        forever begin
            fork
                process_config(mon2cmp_cfg);
                process_alarm(mon2cmp_al);
            join_any
        end
    endfunction
endclass
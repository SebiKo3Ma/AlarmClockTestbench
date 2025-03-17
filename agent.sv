virtual class agent #(type GT, type DT, type MT, type IT, type TT, type CT);
    GT gen;
    DT drv;
    MT mon;

    IT inter;

    mailbox gen2drv;
    event handshake;
    CT gen_params;

    function new(IT inter, CT gen_params, string name);
        this.inter = inter;
        this.gen_params = gen_params;
        gen = new(gen_params);
        drv = new(inter, {name, "_DRV"});
        gen2drv = new();
        mon = new(inter, {name, "_MON"});
    endfunction

    task run(mailbox mon2cmp);
        fork
    	    gen.run(gen2drv, handshake);
    	    drv.run(gen2drv, handshake);
            mon.run(mon2cmp);
        join_any
    endtask
endclass

class config_agent extends agent #(config_generator, config_driver, config_monitor, virtual aclk_tconfig_if, config_transaction, cfg_gen_configs);
    function new(IT inter,  cfg_gen_configs gen_params, string name);
        super.new(inter, gen_params, name);
    endfunction
endclass

class alarm_agent extends agent #(alarm_generator, alarm_driver, alarm_monitor, virtual aclk_alop_if, alarm_transaction, al_gen_configs);
    function new(IT inter, al_gen_configs gen_params, string name);
        super.new(inter, gen_params, name);
    endfunction
endclass
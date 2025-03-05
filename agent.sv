virtual class agent #(type GT, type DT, type MT, type IT, type TT);
    GT gen;
    DT drv;
    MT mon;

    IT inter;

    mailbox gen2drv;
    event handshake;
    int gen_params[5];
    TT mon2cmp[$];

    function new(IT inter, int gen_params[5], string name);
        this.inter = inter;
        this.gen_params = gen_params;
        gen = new(gen_params);
        drv = new(inter, {name, "_DRV"});
        gen2drv = new();
        mon = new(inter, {name, "_MON"});
    endfunction

    task run();
        fork
    	    gen.run(gen2drv, handshake);
    	    drv.run(gen2drv, handshake);
            mon.run(mon2cmp);
        join_any
    endtask
endclass

class config_agent extends agent #(config_generator, config_driver, config_monitor, virtual aclk_tconfig_if, config_transaction);
    function new(IT inter, int gen_params[5], string name);
        super.new(inter, gen_params, name);
    endfunction
endclass

class alarm_agent extends agent #(alarm_generator, alarm_driver, alarm_monitor, virtual aclk_alop_if, alarm_transaction);
    function new(IT inter, int gen_params[5], string name);
        super.new(inter, gen_params, name);
    endfunction
endclass
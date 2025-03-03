class config_agent;
    config_generator gen;
    config_driver    drv;

    virtual aclk_tconfig_if inter;

    mailbox gen2drv;
    event handshake;
    int gen_params[5];

    function new(virtual aclk_tconfig_if config_inter, int gen_params[5]);
        this.inter = config_inter;
        this.gen_params = gen_params;
        gen = new(gen_params);
        drv = new(inter);
        gen2drv = new();
    endfunction

    task run();
        fork
    	    gen.run(gen2drv, handshake);
    	    drv.run(gen2drv, handshake);
        join_any
    endtask
endclass
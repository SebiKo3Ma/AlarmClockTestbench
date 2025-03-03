class alarm_agent;
    alarm_generator gen;
    alarm_driver    drv;

    virtual aclk_alop_if inter;

    mailbox gen2drv;
    event handshake;
    int gen_params[2];

    function new(virtual aclk_alop_if config_inter, int gen_params[2]);
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
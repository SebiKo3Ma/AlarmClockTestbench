class environment;
  //declare all the components
  config_generator cfg_gen;
  config_driver    cfg_drv;

  alarm_generator al_gen;

  virtual aclk_tconfig_if config_inter;
  virtual aclk_alop_if alarm_inter;

  mailbox gen2drv;
  event handshake;

  function new(virtual aclk_tconfig_if config_inter, virtual aclk_alop_if alarm_inter);
    this.config_inter = config_inter;
    this.alarm_inter = alarm_inter;
    cfg_gen   = new(10, 20, 4, 4, 2);
    al_gen = new(10, 20);
    //cfg_drv   = new(config_inter);
    gen2drv   = new();
  endfunction

  task pre_main(); 
    this.config_inter.do_reset();
    this.alarm_inter.do_reset();
  endtask

  task main();
    	cfg_gen.run(gen2drv, handshake);
    	//cfg_drv.run(gen2drv, handshake);
  endtask

 task run;
    pre_main();
    main();
    $finish;
  endtask
endclass

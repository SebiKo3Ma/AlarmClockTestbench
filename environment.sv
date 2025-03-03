class environment;
  //declare all the components
  config_agent cfg_agt;

  //alarm_generator al_gen;

  virtual aclk_tconfig_if config_inter;
  virtual aclk_alop_if alarm_inter;

  int cfg_gen_params[5];

  function new(virtual aclk_tconfig_if config_inter, virtual aclk_alop_if alarm_inter, int cfg_gen_params[5]);
    this.config_inter = config_inter;
    this.alarm_inter = alarm_inter;
    this.cfg_gen_params = cfg_gen_params;
    cfg_agt  = new(config_inter, cfg_gen_params);
    //al_gen = new(10, 20);
  endfunction

  task pre_main(); 
    this.config_inter.do_reset();
    this.alarm_inter.do_reset();
  endtask

  task main();
    cfg_agt.run();
  endtask

 task run;
    pre_main();
    main();
    $finish;
  endtask
endclass

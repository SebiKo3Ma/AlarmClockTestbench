class environment;
  //declare all the components
  config_agent cfg_agt;
  alarm_agent al_agt;

  virtual aclk_tconfig_if config_inter;
  virtual aclk_alop_if alarm_inter;

  int cfg_gen_params[5], al_gen_params[2];

  function new(virtual aclk_tconfig_if config_inter, virtual aclk_alop_if alarm_inter, int cfg_gen_params[5], int al_gen_params[2]);
    this.config_inter = config_inter;
    this.alarm_inter = alarm_inter;
    this.cfg_gen_params = cfg_gen_params;
    this.al_gen_params = al_gen_params;
    cfg_agt  = new(config_inter, cfg_gen_params);
    al_agt = new(alarm_inter, al_gen_params);
  endfunction

  task pre_main(); 
    this.config_inter.do_reset();
    this.alarm_inter.do_reset();
  endtask

  task main();
    fork
      cfg_agt.run();
      al_agt.run();
    join_none
    #10000;
  endtask

 task run;
    pre_main();
    main();
    $finish;
  endtask
endclass

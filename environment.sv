class environment;
  //declare all the components
  config_agent cfg_agt;
  alarm_agent al_agt;
  config_compare cfg_compare;
  alarm_compare al_compare;
  reference refer;
  coverage cov;

  virtual aclk_tconfig_if config_inter;
  virtual aclk_alop_if alarm_inter;

  cfg_gen_configs cfg_gen_params;
  al_gen_configs  al_gen_params;

  mailbox cfg_mon2cmp, al_mon2cmp;
  config_transaction cfg_mon2cmp_q[$], cfg_ref2cmp[$];
  alarm_transaction al_mon2cmp_q[$], al_ref2cmp[$];

  function new(virtual aclk_tconfig_if config_inter, virtual aclk_alop_if alarm_inter, cfg_gen_configs cfg_gen_params, al_gen_configs al_gen_params);
    this.config_inter = config_inter;
    this.alarm_inter = alarm_inter;
    this.cfg_gen_params = cfg_gen_params;
    this.al_gen_params = al_gen_params;
    cfg_agt  = new(config_inter, cfg_gen_params, "CFG");
    al_agt   = new(alarm_inter, al_gen_params, "AL");
    cfg_mon2cmp = new();
    al_mon2cmp  = new();
    cfg_compare = new();
    al_compare  = new();
    refer = new();
    cov = new(config_inter, alarm_inter);
  endfunction

  task pre_main(); 
    this.config_inter.do_reset();
    this.alarm_inter.do_reset();
  endtask

  task main();
    fork
      fork
        cfg_agt.run(cfg_mon2cmp);
        al_agt.run(al_mon2cmp);
      join
      refer.run(cfg_mon2cmp, al_mon2cmp, cfg_mon2cmp_q, al_mon2cmp_q, cfg_ref2cmp, al_ref2cmp);
    join_any
    disable fork;
    cfg_compare.run(cfg_mon2cmp_q, cfg_ref2cmp);
    al_compare.run(al_mon2cmp_q, al_ref2cmp);
  endtask

 task run;
    pre_main();
    main();
    cov.report();
    $finish;
  endtask
endclass

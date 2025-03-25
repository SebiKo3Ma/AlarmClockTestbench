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

  mailbox cfg_mon2ref, al_mon2ref;
  scoreboard_queues mon2cmp, ref2cmp;

  function new(virtual aclk_tconfig_if config_inter, virtual aclk_alop_if alarm_inter, cfg_gen_configs cfg_gen_params, al_gen_configs al_gen_params);
    this.config_inter = config_inter;
    this.alarm_inter = alarm_inter;
    this.cfg_gen_params = cfg_gen_params;
    this.al_gen_params = al_gen_params;
    cfg_agt  = new(config_inter, cfg_gen_params, "CFG");
    al_agt   = new(alarm_inter, al_gen_params, " AL");
    cfg_mon2ref = new();
    al_mon2ref  = new();
    mon2cmp = new();
    ref2cmp = new();
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
        cfg_agt.run(cfg_mon2ref);
        al_agt.run(al_mon2ref);
      join
      refer.run(cfg_mon2ref, al_mon2ref, mon2cmp, ref2cmp);
    join_any
    disable fork;
    cfg_compare.run(mon2cmp.cfg, ref2cmp.cfg);
    al_compare.run(mon2cmp.al, ref2cmp.al);
  endtask

 task run;
    pre_main();
    main();
    cov.report();
    $finish;
  endtask
endclass

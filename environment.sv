class environment;
  //declare all the components
  generator gen;
  driver    drv;
  monitor   mon;
  reference refer;
  compare   cmp;
  coverage cov;

  virtual aclk_if inter;

  int mode = 0;
  bit select = 0;

  transaction gen2drv[$];
  transaction mon2cmp[$];

  function new(virtual aclk_if inter, int mode, bit select);
    this.inter = inter;
    this.mode = mode;
    this.select = select;
    gen   = new(mode);
    drv   = new(inter);
    mon   = new(inter);
    refer = new();
    cmp   = new(refer);
    cov   = new(inter, select);
  endfunction

  task pre_main(); 
    this.inter.do_reset();
  endtask

  task main();
    gen.run(gen2drv);
    fork
    	drv.run(gen2drv);
    	mon.run(mon2cmp);
    join_any
    cmp.run(mon2cmp);
  endtask

 task run;
    pre_main();
    main();
    cov.report();
  endtask
endclass

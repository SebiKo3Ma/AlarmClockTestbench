class environment;
  //declare all the components
  generator gen;
  driver    drv;
  monitor   mon;
  reference refer;
  compare   cmp;

  virtual aclk_if inter;

  transaction gen2drv[$];
  transaction mon2cmp[$];

  function new(virtual aclk_if inter);
    this.inter = inter;
    gen   = new();
    drv   = new(inter);
    mon   = new(inter);
    refer = new();
    cmp   = new(refer);
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
    $finish;
  endtask
endclass

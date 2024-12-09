class environment;
  //declare all the components
  generator gen;
  driver    drv;
  monitor   mon;

  virtual aclk_if inter;

  transaction gen2drv[$];
  transaction mon2cmp[$];

  // every component has a name and there is a common verbosity for the entire environment
  function new(virtual aclk_if inter);
    this.inter = inter;
    gen    = new();
    drv   = new(inter);
    mon = new(inter);
  endfunction

  // the reset phase - all inputs are set on the default value
  task pre_main(); // !!!!!!!!!!!!!!!!! driverul ar trebui sa aiba functia de reset, orice semnal prin driver -> puteam sa am un driver in if care face functia daca e cazul
    this.inter.do_reset();
  endtask

  task main();
    gen.run(gen2drv);
    fork
    	drv.run(gen2drv);
    	mon.run(mon2cmp);
    join_any
  endtask

  // the main task - follows  pre_test   ->   test   ->   post_test
  //                        (reset all)  (main action) (display report)
  task run;
    pre_main();
    main();
    $finish;
  endtask
endclass

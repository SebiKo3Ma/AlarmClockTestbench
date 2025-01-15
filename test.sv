program test(aclk_if inter);
  environment env, env2;  
  
  initial begin
    //24h clock operation test
    // env = new(inter, 1, 1);
    // env.run();

    env2 = new(inter, 0, 0);
    env2.run();

    $finish;
  end
endprogram
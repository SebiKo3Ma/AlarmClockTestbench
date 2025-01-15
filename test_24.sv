program test_24(aclk_if inter);
  environment env;  
  
  initial begin
    //24h clock operation test
    env = new(inter, 1, 1);
    env.run();

    $finish;
  end
endprogram
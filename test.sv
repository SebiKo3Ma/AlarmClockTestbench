program test(aclk_if inter);
  environment env;  
  
  initial begin
    env = new(inter, 0, 0);
    env.run();

    $finish;
  end
endprogram
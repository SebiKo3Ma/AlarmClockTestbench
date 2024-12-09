program test(aclk_if inter);
  environment env;  
  
  initial begin
    env = new(inter);
    env.run();
  end
endprogram
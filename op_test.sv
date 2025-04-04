import config_pkg::*;

program op_test(aclk_tconfig_if cif, aclk_alop_if aif);
  environment env;
  cfg_gen_configs cfg_gen_params;
  al_gen_configs  al_gen_params;
  
  initial begin
    if(test_name == "op_test") begin
      cfg_gen_params = new(300, 350, 1, 9, 0);
      al_gen_params  = new(30, 40);
      env = new(cif, aif, cfg_gen_params, al_gen_params);
      env.run();
    end
  end
endprogram
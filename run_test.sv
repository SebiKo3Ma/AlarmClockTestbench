import config_pkg::*;

program run_test(aclk_tconfig_if cif, aclk_alop_if aif);
  environment env;
  cfg_gen_configs cfg_gen_params;
  al_gen_configs  al_gen_params;
  
  initial begin
    if(test_name == "run_test") begin
      cfg_gen_params = new(100, 150, 9, 1, 0);
      al_gen_params  = new(20, 30);
      env = new(cif, aif, cfg_gen_params, al_gen_params);
      env.run();
    end
  end
endprogram
import config_pkg::*;

program il_test(aclk_tconfig_if cif, aclk_alop_if aif);
  environment env;
  cfg_gen_configs cfg_gen_params;
  al_gen_configs  al_gen_params;
  
  initial begin
    if(test_name == "il_test") begin
      cfg_gen_params = new(50, 60, 1, 1, 8);
      al_gen_params  = new(50, 60);
      env = new(cif, aif, cfg_gen_params, al_gen_params);
      env.run();
    end
  end
endprogram
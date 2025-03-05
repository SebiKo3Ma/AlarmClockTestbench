class config_driver extends driver #(config_transaction, virtual aclk_tconfig_if);
  function new(IT m_vif, string name);
    super.new(m_vif, name);
  endfunction

  task send_sig(config_transaction trans);
    @(m_vif.driver_clk);
    m_vif.driver_clk.reset    <= trans.reset;
    m_vif.driver_clk.H_in1    <= trans.H_in1;
    m_vif.driver_clk.H_in0    <= trans.H_in0;
    m_vif.driver_clk.M_in1    <= trans.M_in1;
    m_vif.driver_clk.M_in0    <= trans.M_in0;
    m_vif.driver_clk.LD_time  <= trans.LD_time;
    m_vif.driver_clk.LD_alarm <= trans.LD_alarm;
  endtask
endclass
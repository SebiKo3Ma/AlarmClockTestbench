class config_monitor;
  virtual aclk_tconfig_if m_vif;
  
  function new(virtual aclk_tconfig_if m_vif);
    this.m_vif = m_vif;
  endfunction

  task get_sig(ref config_transaction trans, virtual aclk_tconfig_if m_vif);
    @(m_vif.monitor_clk);
    trans.reset    = m_vif.monitor_clk.reset;
    trans.H_in1    = m_vif.monitor_clk.H_in1;
    trans.H_in0    = m_vif.monitor_clk.H_in0;
    trans.M_in1    = m_vif.monitor_clk.M_in1;
    trans.M_in0    = m_vif.monitor_clk.M_in0;
    trans.LD_time  = m_vif.monitor_clk.LD_time;
    trans.LD_alarm = m_vif.monitor_clk.LD_alarm;

    trans.H_out1   = m_vif.monitor_clk.H_out1;
    trans.H_out0   = m_vif.monitor_clk.H_out0;
    trans.M_out1   = m_vif.monitor_clk.M_out1;
    trans.M_out0   = m_vif.monitor_clk.M_out0;
    trans.S_out1   = m_vif.monitor_clk.S_out1;
    trans.S_out0   = m_vif.monitor_clk.S_out0;
  endtask

  task run(ref config_transaction mon2cmp[$]);
    forever begin
      // get the signals from the interface
      config_transaction trans;
      trans = new();
      get_sig(trans, m_vif);

      trans.display("CFG_MON");
      
      // push the transaction to the monitor->comparator queue
      mon2cmp.push_back(trans);
    end
  endtask
endclass

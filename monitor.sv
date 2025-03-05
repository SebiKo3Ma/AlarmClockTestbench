virtual class monitor #(type TT, type IT);
  IT m_vif;
  string name;
  
  function new(IT m_vif, string name);
    this.m_vif = m_vif;
    this.name = name;
  endfunction

  pure virtual task get_sig(ref TT trans, IT m_vif);


  task run(ref TT mon2cmp[$]);
    forever begin
      // get the signals from the interface
      TT trans;
      trans = new();
      get_sig(trans, m_vif);

      trans.display(name);
      
      // push the transaction to the monitor->comparator queue
      mon2cmp.push_back(trans);
    end
  endtask
endclass

class config_monitor extends monitor #(config_transaction, virtual aclk_tconfig_if);
  function new(IT m_vif, string name);
    super.new(m_vif, name);
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
endclass

class alarm_monitor extends monitor #(alarm_transaction, virtual aclk_alop_if);
  function new(IT m_vif, string name);
    super.new(m_vif, name);
  endfunction

  task get_sig(ref alarm_transaction trans, virtual aclk_alop_if m_vif);
    @(m_vif.monitor_clk);
    trans.AL_ON    = m_vif.monitor_clk.AL_ON;
    trans.STOP_al    = m_vif.monitor_clk.STOP_al;

    trans.Alarm   = m_vif.monitor_clk.Alarm;
  endtask
endclass
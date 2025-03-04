class alarm_monitor;
  virtual aclk_alop_if m_vif;
  
  function new(virtual aclk_alop_if m_vif);
    this.m_vif = m_vif;
  endfunction

  task get_sig(ref alarm_transaction trans, virtual aclk_alop_if m_vif);
    @(m_vif.monitor_clk);
    trans.AL_ON    = m_vif.monitor_clk.AL_ON;
    trans.STOP_al    = m_vif.monitor_clk.STOP_al;

    trans.Alarm   = m_vif.monitor_clk.Alarm;
  endtask

  task run(ref alarm_transaction mon2cmp[$]);
    forever begin
      // get the signals from the interface
      alarm_transaction trans;
      trans = new();
      get_sig(trans, m_vif);

      trans.display("AL_MON");
      
      // push the transaction to the monitor->comparator queue
      mon2cmp.push_back(trans);
    end
  endtask
endclass

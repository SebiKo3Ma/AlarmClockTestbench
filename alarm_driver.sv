class alarm_driver extends driver #(alarm_transaction, virtual aclk_alop_if);
  function new(IT m_vif, string name);
    super.new(m_vif, name);
  endfunction

  task send_sig(alarm_transaction trans);
    @(m_vif.driver_clk);
    m_vif.STOP_al <= trans.STOP_al;
    m_vif.AL_ON   <= trans.AL_ON;
  endtask
endclass
class monitor;
  virtual aclk_if m_vif;
  
  function new(virtual aclk_if m_vif);
    this.m_vif = m_vif;
  endfunction

  task run(ref transaction mon2cmp[$]);
    transaction trans_temp;
    forever begin
      // get the signals from the interface
      transaction trans;
      @(posedge m_vif.tb_clk);
      trans = m_vif.get_sig();
      
      // save the transaction to a new variable each time
      trans_temp = new();
      trans_temp.do_copy(trans);
      trans_temp.display("MON");
      
      // push the transaction to the monitor->comparator queue
      mon2cmp.push_back(trans_temp);
    end
  endtask
endclass

class driver;
  virtual aclk_if m_vif;

  function new(virtual aclk_if m_vif);
    this.m_vif = m_vif;
  endfunction

  task run(ref transaction gen2driv[$]);
    // reset the DUT
    m_vif.do_reset();
    
    if(gen2driv.size()) begin
      foreach(gen2driv[i]) begin
        // display the transaction
        gen2driv[i].display("DRV");
        
        // send the transaction to the interface
        @(posedge m_vif.clk);
        m_vif.send_sig(gen2driv[i]);
      end
    end
    
    // wait some time for the transaction to finish
    repeat(2) @(posedge m_vif.clk);
  endtask
endclass
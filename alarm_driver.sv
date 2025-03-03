class alarm_driver;
  virtual aclk_alop_if m_vif;
  alarm_transaction trans;

  function new(virtual aclk_alop_if m_vif);
    this.m_vif = m_vif;
    trans = new();
  endfunction

  // the transaction received will be sent to the interface
  task send_sig(alarm_transaction trans);
    @(m_vif.driver_clk);
    m_vif.STOP_al <= trans.STOP_al;
    m_vif.AL_ON   <= trans.AL_ON;
  endtask

  task run(mailbox gen2driv, event handshake);
    // reset the DUT
    m_vif.do_reset();
    
    forever begin
        gen2driv.get(trans);

        // display the transaction
        trans.display("AL_DRV");
        
        // send the transaction to the interface
        send_sig(trans);
        //make a delay function  in the interface, no @ in driver (use repeat(n) wait function;)

        //confirm transaction was processed
        ->handshake;
    end
    
    // wait some time for the transaction to finish
    repeat(2) @(posedge m_vif.tb_clk);
  endtask
endclass
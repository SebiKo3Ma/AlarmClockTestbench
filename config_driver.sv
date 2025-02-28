class config_driver;
  virtual aclk_tconfig_if m_vif;
  config_transaction trans;
  rand int delay;

  function new(virtual aclk_tconfig_if m_vif);
    this.m_vif = m_vif;
    trans = new();
  endfunction

  constraint delay_bounds{
    delay inside {[10:100]};
  }

  task run(mailbox gen2driv, event handshake);
    // reset the DUT
    m_vif.do_reset();
    
    forever begin
        gen2driv.get(trans);
        //randomize the delay
        if(!this.randomize()) $fatal("Delay randomization failed!");

        // display the transaction
        trans.display("DRV");
        
        // send the transaction to the interface
        #delay m_vif.send_sig(trans);
        //make a delay function  in the interface, no @ in driver (use repeat(n) wait function;)

        //confirm transaction was processed
        ->handshake;
    end
    
    // wait some time for the transaction to finish
    repeat(2) @(posedge m_vif.tb_clk);
  endtask
endclass
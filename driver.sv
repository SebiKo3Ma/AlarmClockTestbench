virtual class driver #(type TT, type IT);
  IT m_vif;
  TT trans;
  string name;

  function new(IT m_vif, string name);
    this.m_vif = m_vif;
    trans = new();
    this.name = name;
  endfunction

  pure virtual task send_sig(TT trans);

  task run(mailbox gen2driv, event handshake);
    // reset the DUT
    m_vif.do_reset();
    
    forever begin
        gen2driv.get(trans);
        //randomize the delay
        if(!this.randomize()) $fatal("Delay randomization failed!");

        // display the transaction
        trans.display(name);
        
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
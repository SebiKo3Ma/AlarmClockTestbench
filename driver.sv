import config_pkg::*;

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

  rand int delay;

  constraint delay_bounds{
    delay inside {[1:10]};
  }

  task run(mailbox gen2driv, event handshake);
    // reset the DUT
    m_vif.do_reset();
    
    forever begin
        gen2driv.get(trans);
        //randomize the delay
        if(!this.randomize()) $fatal("Delay randomization failed!");

        // display the transaction
        if(verbosity > 4) trans.display(name);
        
        // send the transaction to the interface
        repeat(delay) @(posedge m_vif.tb_clk);
        send_sig(trans);

        //confirm transaction was processed
        ->handshake;
    end    
    
  endtask
endclass

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
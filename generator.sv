class generator;
  rand int num_of_trans;
  bit first;
    
  constraint num_of_trans_range {
    num_of_trans inside {[50:60]};
  }
  
  function new();
  endfunction

  task run(ref transaction gen2driv[$]);
    // randomize the number of transactions
    if(!this.randomize()) $fatal("Failed randomization!");
    
    repeat(num_of_trans)
      begin
        // create and randomize the transaction
        transaction trans = new();

        if(!trans.randomize()) $fatal("Failed randomization!");
        
        // add the transaction to the generator-to-driver queue
        gen2driv.push_back(trans);
      end
    $display("There are ", $sformatf("%0d", gen2driv.size()), " elements in the generator queue.\n");
  endtask
endclass
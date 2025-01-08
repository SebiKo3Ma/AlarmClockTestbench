class compare;
  reference refer;
  
  int nr_failed; // number of failed transactions
  int nr_total;  // number of total transactions
  int nr_passed; // number of passed transactions

  function new(reference refer);
    this.refer     = refer;
    this.nr_failed = 0;
    this.nr_total  = 0;
    this.nr_passed = 0;
  endfunction
  
  task run(ref transaction mon2cmp[$]);
    transaction ref_trans;
    
    if(mon2cmp.size()) begin
      foreach(mon2cmp[i]) begin 
        nr_total++;
        ref_trans = new();
        ref_trans = refer.process(mon2cmp[i]);
        
        ref_trans.display("REF");
        mon2cmp[i].display("CMP");
        if(mon2cmp[i].do_compare(ref_trans)) begin
          nr_passed++;
          $display("Transaction %0d: Correct %0d", nr_total, nr_passed);
        end else begin
          nr_failed++;
          $display("Transaction %0d: Incorrect %0d", nr_total, nr_failed);
        end
      end
    end
    $display("Total: %0d\nPassed: %0d\nFailed: %0d", nr_total, nr_passed, nr_failed);
  endtask
endclass
class compare #(type TT);
  
  int nr_failed; // number of failed transactions
  int nr_total;  // number of total transactions
  int nr_passed; // number of passed transactions
  string name;

  function new(string name);
    this.name = name;
    this.nr_failed = 0;
    this.nr_total  = 0;
    this.nr_passed = 0;
  endfunction
  
  task run(ref TT mon2cmp[$],ref TT ref2cmp[$]);
    if(mon2cmp.size()) begin
      foreach(mon2cmp[i]) begin 
        nr_total++;
        
        ref2cmp[i].display({name, "_REF"});
        mon2cmp[i].display({name, "_CMP"});

        if(mon2cmp[i].do_compare(ref2cmp[i])) begin
          nr_passed++;
          $display("Transaction %0d: Correct %0d", nr_total, nr_passed);
        end else begin
          nr_failed++;
          $display("Transaction %0d: Incorrect %0d", nr_total, nr_failed);
        end
      end
    end else begin $write("Empty queue"); end
    $display("Total: %0d\nPassed: %0d\nFailed: %0d", nr_total, nr_passed, nr_failed);
  endtask
endclass

class config_compare extends compare #(config_transaction);
  function new();
    super.new("CFG");
  endfunction
endclass

class alarm_compare extends compare #(alarm_transaction);
  function new();
    super.new("AL");
  endfunction
endclass
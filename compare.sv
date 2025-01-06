class compare;
  reference refer;
  int nr_failed; // number of failed tests

  function new(reference refer);
    this.nr_failed = 1'b0;
    this.refer     = refer;
  endfunction

  task run(const ref transaction mon2cmp[$]);
    int j = 0; // id of the transaction from the wa monitor queue
    transaction ref_trans;
    transaction trans = new();

    if(mon2cmp.size())
      foreach(mon2cmp[i]) begin

        trans = mon2cmp[i]; // the original transaction that is going to be compared
        trans.display("Trans from monitor");

        ref_trans = refer.get_output(trans); // the expected output transaction
        ref_trans.display("Expected transaction");

        get_result(trans.compare(ref_trans), i);
      end
  endtask

  function void get_result(bit result, int i);
    if(result) begin // test nr.i passed
      $display(" ---> Test %0d passed", i);
    end else begin   // test nr.i failed
      $display(" ---> Test %0d failed", i);
      nr_failed++;
    end
  endfunction

endclass

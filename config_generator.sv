class generator;
  rand int num_of_trans;
  rand trans_types tr_type;

  int   min_tr, //minimum number of transactions 
        max_tr, //maximum number of transactions
        n_cr,   //number of 'Clock Running' transactions
        n_op,   //number of 'Clock operations' transactions
        n_il,   //number of illegal transactions
        w_cr,   //weight of 'Clock Running' transactions
        w_op,   //weight of 'Clock operations' transactions
        w_il;   //weight of illegal transactions
    
  function new(int min_tr, max_tr, w_cr, w_op, w_il);
    this.min_tr = min_tr;
    this.max_tr = max_tr;
    this.n_cr = 0;
    this.n_op = 0;
    this.n_il = 0;
    this.w_cr = w_cr;
    this.w_op = w_op;
    this.w_il = w_il;
  endfunction

  constraint num_of_trans_range {
    num_of_trans inside {[min_tr:max_tr]}; //random number of transactions in a configurable range
  }

  constraint type_distribution{
    tr_type dist {CR:/w_cr, OP:/w_op, IL:/w_il};
  }

  config_transaction trans;

  task run(mailbox gen2driv);
    // randomize the number of transactions
    if(!randomize(num_of_trans)) $fatal("No. of transactions randomization failed!");
          
      repeat(num_of_trans)
        begin
          cr_config_transaction cr_trans = new();
          op_config_transaction op_trans = new();
          il_config_transaction il_trans = new();

          //randomize transaction type
          if(!randomize(tr_type)) $fatal("Transaction type randomization failed!");

          case(tr_type)
            CR: begin
                n_cr++;
                if(!cr_trans.randomize()) $fatal("Clock Running transaction randomization failed!");
                trans.do_copy(cr_trans);
            end

            OP: begin
                n_op++;
                if(!op_trans.randomize()) $fatal("Clock Operations transaction randomization failed!");
                trans.do_copy(op_trans);
            end

            IL: begin
                n_il++;
                if(!il_trans.randomize()) $fatal("Illegal transaction randomization failed!");
                trans.do_copy(il_trans);
            end
          endcase

          // add the transaction to the generator-to-driver queue
          gen2driv.put(trans);
        end 
    $display("There are ", $sformatf("%0d", gen2driv.size()), " elements in the generator queue.\nClock running: %0d\n Clock operations: %0d\n Illegal transactions: %0d\n",
            n_cr, n_op, n_il);
  endtask
endclass
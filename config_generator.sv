class config_generator;
  local int num_of_trans;
  local trans_types tr_type;

  local int n_cr,   //number of 'Clock Running' transactions
            n_op,   //number of 'Clock operations' transactions
            n_il;   //number of illegal transactions

  int   min_tr, //minimum number of transactions 
        max_tr, //maximum number of transactions
        w_cr,   //weight of 'Clock Running' transactions
        w_op,   //weight of 'Clock operations' transactions
        w_il;   //weight of illegal transactions
    
  function new(int gen_params[5]);
    this.min_tr = gen_params[0];
    this.max_tr = gen_params[1];
    this.w_cr = gen_params[2];
    this.w_op = gen_params[3];
    this.w_il = gen_params[4];
    this.n_cr = 0;
    this.n_op = 0;
    this.n_il = 0;
    this.tr_type = CR; //default value
  endfunction

  constraint num_of_trans_range {
    num_of_trans inside {[min_tr:max_tr]}; //random number of transactions in a configurable range
  }

  constraint type_distribution{
    tr_type dist {CR:=w_cr, OP:=w_op, IL:=w_il};
  }

  task run(mailbox gen2driv, event handshake);

    // randomize the number of transactions
    if(!randomize(num_of_trans)) $fatal("No. of transactions randomization failed!");
          
      repeat(num_of_trans)
        begin
          config_transaction    trans    = new();
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

          // add the transaction to the generator-to-driver mailbox
          gen2driv.put(trans);

          //wait for the transaction to be processed before generating another
          @handshake;
        end 
    $display("Finished generating %0d transactions.\nClock running: %0d\nClock operations: %0d\nIllegal transactions: %0d\n",
            num_of_trans, n_cr, n_op, n_il);
  endtask
endclass
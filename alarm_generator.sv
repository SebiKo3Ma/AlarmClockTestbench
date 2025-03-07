class alarm_generator;
  rand int num_of_trans;

  int   min_tr, //minimum number of transactions 
        max_tr, //maximum number of transactions
        n_al;  //No. of alarm operations transactions generated
    
  function new(al_gen_configs gen_params);
    this.min_tr = gen_params.min_tr;
    this.max_tr = gen_params.max_tr;
    this.n_al  = 0;
  endfunction

  constraint num_of_trans_range {
    num_of_trans inside {[min_tr:max_tr]}; //random number of transactions in a configurable range
  }

  task run(mailbox gen2driv, event handshake);
    // randomize the number of transactions
    if(!randomize(num_of_trans)) $fatal("No. of transactions randomization failed!");
          
      repeat(num_of_trans)
        begin
         // create and randomize the transaction
          alarm_transaction trans = new();

          if(!trans.randomize()) $fatal("Alarm operation transaction randomization failed!");

          n_al++;

          // add the transaction to the generator-to-driver mailbox
          gen2driv.put(trans);

          //wait for the transaction to be processed before generating another
          @handshake;
        end 
    $display("Finished generating %0d alarm operations transactions\n", n_al);
  endtask
endclass
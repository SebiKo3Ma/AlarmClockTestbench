class generator;
  rand int num_of_trans;
  bit first;
  bit check = 0;
  int mode;
    
  function new(int mode);
    this.mode = mode;
  endfunction

  constraint num_of_trans_range {
    if(mode == 0)
      num_of_trans inside {[500:600]};
    else if(mode == 1)
      num_of_trans inside {[86500:86600]};
    else
      num_of_trans inside {[50:60]};
  }

  task run(ref transaction gen2driv[$]);
    // randomize the number of transactions
    if(!this.randomize()) $fatal("Failed randomization!");

    if(mode == 1) begin
      repeat(num_of_trans)
        begin
          // create and randomize the transaction
          transaction trans = new();

          if(!check) begin
            trans.LD_time = 1'b1;
          end else begin
            trans.LD_time = 1'b0;
          end
          trans.H_in1 = 2'd2;
          trans.H_in0 = 4'd3;
          trans.M_in1 = 4'd5;
          trans.M_in0 = 4'd9;

          trans.LD_alarm = 1'b0;
          trans.STOP_al = 1'b0;
          trans.AL_ON = 1'b1;
          trans.reset = 1'b0;

          check = 1'b1;
          
          // add the transaction to the generator-to-driver queue
          gen2driv.push_back(trans);
        end
    end else begin
      repeat(num_of_trans)
        begin
          // create and randomize the transaction
          transaction trans = new();

          if(!trans.randomize()) $fatal("Failed randomization!");
          
          // add the transaction to the generator-to-driver queue
          gen2driv.push_back(trans);
        end 
    end
    $display("There are ", $sformatf("%0d", gen2driv.size()), " elements in the generator queue.\n");
  endtask
endclass
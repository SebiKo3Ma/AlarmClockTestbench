class reference;
   logic [1:0] last_H1;
   logic [3:0] last_H0;
   logic [3:0] last_M1;
   logic [3:0] last_M0;
   logic [3:0] last_S1;
   logic [3:0] last_S0; 
  
  function new();
    last_H1 = 2'b00;
    last_H0 = 4'b0000;
    last_M1 = 4'b0000;
    last_M0 = 4'b0000;
    last_S1 = 4'b0000;
    last_S0 = 4'b0000;
  endfunction
  
  function transaction process(transaction trans);
    transaction ref_trans;
    
    ref_trans = new();
    
    if(trans.reset != 1'b0) begin
        last_H1 = trans.H_in1;
        last_H0 = trans.H_in0;
        last_M1 = trans.M_in1;
        last_M0 = trans.M_in0;
        last_S1 = 4'b0000;
        last_S0 = 4'b0000;

        ref_trans.H_out1 = trans.H_in1;
        ref_trans.H_out0 = trans.H_in0;
        ref_trans.M_out1 = trans.M_in1;
        ref_trans.M_out0 = trans.M_in0;
        ref_trans.S_out1 = 4'b0000;
        ref_trans.S_out0 = 4'b0000;
    end else begin
      if(trans.LD_time) begin
        last_H1 = trans.H_in1;
        last_H0 = trans.H_in0;
        last_M1 = trans.M_in1;
        last_M0 = trans.M_in0;
        last_S1 = 4'b0000;
        last_S0 = 4'b0000;

        ref_trans.H_out1 = trans.H_in1;
        ref_trans.H_out0 = trans.H_in0;
        ref_trans.M_out1 = trans.M_in1;
        ref_trans.M_out0 = trans.M_in0;
        ref_trans.S_out1 = 4'b0000;
        ref_trans.S_out0 = 4'b0000;
      end else begin
        last_S0 = last_S0 + 4'd1;
        if(last_S0 > 4'd9) begin
            last_S1 = last_S1 + 4'd1;
            last_S0 = 4'd0;
            if(last_S1 > 4'd5) begin
                last_M0 = last_M0 + 4'd1;
                last_S1 = 4'd0;
                if(last_M0 > 4'd9) begin
                    last_M1 = last_M1 + 4'd1;
                    last_M0 = 4'd0;
                    if(last_M1 > 4'd5) begin
                        last_H0 = last_H0 + 4'd1;
                        last_M1 = 4'd0;
                        if(last_H0 > 4'd9 && last_H1 < 2'd2) begin
                            last_H1 = last_H1 + 2'd1;
                            last_H0 = 4'd0;
                        end else if(last_H0 > 4'd3 && last_H1 > 2'd1) begin
                            last_H1 = 2'd0;
                            last_H0 = 4'd0;
                        end
                    end
                end
            end
        end
        ref_trans.H_out1 = last_H1;
        ref_trans.H_out0 = last_H0;
        ref_trans.M_out1 = last_M1;
        ref_trans.M_out0 = last_M0;
        ref_trans.S_out1 = last_S1;
        ref_trans.S_out0 = last_S0;
      end
      
    end
    
    ref_trans.reset = trans.reset;
    
    ref_trans.H_in1 = trans.H_in1;
    ref_trans.H_in0 = trans.H_in0;
    ref_trans.M_in1 = trans.M_in1;
    ref_trans.M_in0 = trans.M_in0;

    ref_trans.LD_time = trans.LD_time;
    ref_trans.LD_alarm = trans.LD_alarm;
    ref_trans.STOP_al = trans.STOP_al;
    ref_trans.AL_ON = trans.AL_ON;

    ref_trans.Alarm = trans.Alarm;
    
    return ref_trans;
  endfunction
endclass
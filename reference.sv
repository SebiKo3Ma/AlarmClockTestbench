class reference;
   logic [1:0] last_H1;
   logic [3:0] last_H0;
   logic [3:0] last_M1;
   logic [3:0] last_M0;
   logic [3:0] last_S1;
   logic [3:0] last_S0;

   logic [1:0] alarm_H1;
   logic [3:0] alarm_H0;
   logic [3:0] alarm_M1;
   logic [3:0] alarm_M0; 

   bit al_sound;
   bit rst;
  
  function new();
    last_H1 = 2'b00;
    last_H0 = 4'b0000;
    last_M1 = 4'b0000;
    last_M0 = 4'b0000;
    last_S1 = 4'b0000;
    last_S0 = 4'b0000;

    alarm_H1 = 2'b00;
    alarm_H0 = 4'b0000;
    alarm_M1 = 4'b0000;
    alarm_M0 = 4'b0000;

    al_sound = 1'b0;

    rst = 1'b0;
  endfunction
  
  function transaction process(transaction trans);
    transaction ref_trans;
    
    ref_trans = new();
    
    if(trans.reset) begin
      if(!rst) begin
        rst = 1'b1;
        last_H1 = trans.H_in1;
        last_H0 = trans.H_in0;
        last_M1 = trans.M_in1;
        last_M0 = trans.M_in0;
      end
        last_S1 = 4'b0000;
        last_S0 = 4'b0000;

        alarm_H1 = 2'b00;
        alarm_H0 = 4'b0000;
        alarm_M1 = 4'b0000;
        alarm_M0 = 4'b0000;

        al_sound = 1'b0;

        ref_trans.H_out1 = last_H1;
        ref_trans.H_out0 = last_H0;
        ref_trans.M_out1 = last_M1;
        ref_trans.M_out0 = last_M0;
        ref_trans.S_out1 = 4'b0000;
        ref_trans.S_out0 = 4'b0000;
        ref_trans.Alarm = 1'b0;
    end else begin
      rst = 1'b0;
      if(alarm_H1 == last_H1 && alarm_H0 == last_H0 && alarm_M1 == last_M1 && alarm_M0 == last_M0) begin
        if(trans.AL_ON) begin
          al_sound = 1'b1;
        end else begin
          al_sound = 1'b0;
        end
      end

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
      
      if(trans.LD_alarm) begin
        alarm_H1 = trans.H_in1;
        alarm_H0 = trans.H_in0;
        alarm_M1 = trans.M_in1;
        alarm_M0 = trans.M_in0;
      end

      if(trans.STOP_al) begin
        al_sound = 1'b0;
      end

      if(al_sound) begin
        ref_trans.Alarm = 1'b1;
      end else begin
        ref_trans.Alarm = 1'b0;
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
    
    $display("\nLast_time: %1d%1d:%1d%1d:%1d%1d, Alarm: %1d%1d:%1d%1d, Sound: %1d", last_H1, last_H0, last_M1, last_M0, last_S1, last_S0, alarm_H1, alarm_H0, alarm_M1, alarm_M0, al_sound);
    return ref_trans;
  endfunction
endclass
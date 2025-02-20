module testbench;
  bit clk;

  aclk_tconfig_if cif(.clk(clk));
  aclk_alop_if    aif(.clk(clk));
  aclock DUT (
    .reset     (cif.reset),
    .clk       (clk),
    .H_in1     (cif.H_in1   ),
    .H_in0     (cif.H_in0   ),
    .M_in1     (cif.M_in1   ),
    .M_in0     (cif.M_in0   ),
    .LD_time   (cif.LD_time ),
    .LD_alarm  (cif.LD_alarm),
    .STOP_al   (aif.STOP_al ),
    .AL_ON     (aif.AL_ON   ),
    .Alarm     (aif.Alarm   ),
    .H_out1    (cif.H_out1),
    .H_out0    (cif.H_out0),
    .M_out1    (cif.M_out1),
    .M_out0    (cif.M_out0),
    .S_out1    (cif.S_out1),
    .S_out0    (cif.S_out0)
  );

  // standard clock given as input
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  initial begin
    cif.do_reset();
    aif.do_reset();
  end

  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
endmodule

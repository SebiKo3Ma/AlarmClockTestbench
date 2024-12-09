module testbench;
  bit clk_tb;

  aclk_if IF(.clk(clk_tb));
  aclock DUT (.inter(IF));
  test test(.inter(IF));

  // standard clock given as input
  initial begin
    clk_tb = 1'b0;
    forever #5 clk_tb = ~clk_tb;
  end

  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
endmodule

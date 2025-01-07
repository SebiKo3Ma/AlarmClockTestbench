module testbench;
  bit clk;
  bit tb_clk;

  aclk_if IF(.clk(clk), .tb_clk(tb_clk));
  aclock DUT (.inter(IF));
  test test(.inter(IF));

  // standard clock given as input
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  initial begin
    tb_clk = 1'b0;
    forever #50 tb_clk = ~tb_clk;
  end

  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
endmodule

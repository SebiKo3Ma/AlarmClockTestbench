class coverage;
    virtual aclk_if inter;

    covergroup time_output @(posedge inter.tb_clk);
        ho1: coverpoint inter.H_out1 {
            bins valid_values[] = {0, 1, 2};
        }
        ho0: coverpoint inter.H_out0 {
            bins valid_values[] = {[0:9]};
        }
        mo1: coverpoint inter.M_out1 {
            bins valid_values[] = {[0:5]};
        }
        mo0: coverpoint inter.M_out0 {
            bins valid_values[] = {[0:9]};
        }
        so1: coverpoint inter.S_out1 {
            bins valid_values[] = {[0:5]};
        }
        so0: coverpoint inter.S_out0 {
            bins valid_values[] = {[0:9]};
        }

        // h_x: cross ho1, ho0 {
        //     ignore_bins invalid_hours = binsof(ho1) intersect {2} &&
        //                                 binsof(ho0) intersect {[4:9]};
        // }

        // all_x: cross ho1, ho0, mo1, mo0, so1, so0;
    endgroup: time_output

    function new(virtual aclk_if inter);
        this.inter = inter;
        time_output = new();
    endfunction

    function void report();
        $display("=== Time Output Coverage ===");
        $display("Coverage: %0.2f%%", $get_coverage());
    endfunction

endclass

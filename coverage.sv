class coverage;
    logic [1:0] H_out1;
    logic [3:0] H_out0;
    logic [3:0] M_out1;
    logic [3:0] M_out0;
    logic [3:0] S_out1;
    logic [3:0] S_out0;

    covergroup time_output;
        ho1: coverpoint H_out1 {
            bins valid_values[] = {0, 1, 2};
        }
        ho0: coverpoint H_out0 {
            bins valid_values[] = {[0:9]};
        }
        mo1: coverpoint M_out1 {
            bins valid_values[] = {[0:5]};
        }
        mo0: coverpoint M_out0 {
            bins valid_values[] = {[0:9]};
        }
        so1: coverpoint S_out1 {
            bins valid_values[] = {[0:5]};
        }
        so0: coverpoint S_out0 {
            bins valid_values[] = {[0:9]};
        }

        // h_x: cross ho1, ho0 {
        //     ignore_bins invalid_hours = binsof(ho1) intersect {2} &&
        //                                 binsof(ho0) intersect {[4:9]};
        // }

        // all_x: cross ho1, ho0, mo1, mo0, so1, so0;
    endgroup: time_output

    function new();
        time_output = new();
    endfunction

    task run();
        $display("Coverage sampling at time: %0t", $time);
        time_output.sample();
    endtask

    function void report();
        $display("=== Time Output Coverage ===");
        $display("Coverage: %0.2f%%", $get_coverage());
    endfunction

endclass

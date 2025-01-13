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

        all_x: cross ho1, ho0, mo1, mo0, so1, so0{
            ignore_bins invalid_hours = binsof(ho1) intersect {2} &&
                                        binsof(ho0) intersect {[4:9]};
        }
    endgroup: time_output

    covergroup set_time_alarm @(posedge inter.tb_clk);
        hi1: coverpoint inter.H_in1 {
            bins valid_values[] = {0, 1, 2};
        }
        hi0: coverpoint inter.H_in0 {
            bins valid_values[] = {[0:9]};
        }
        mi1: coverpoint inter.M_in1 {
            bins valid_values[] = {[0:5]};
        }
        mi0: coverpoint inter.M_in0 {
            bins valid_values[] = {[0:9]};
        }

        ldt: coverpoint inter.LD_time;
        lda: coverpoint inter.LD_alarm;

        ld_x: cross ldt, lda;
    endgroup: set_time_alarm

    covergroup trigger_stop_al @(posedge inter.tb_clk);
        al: coverpoint inter.Alarm;
        on: coverpoint inter.AL_ON;
        st: coverpoint inter.STOP_al;

        al_x: cross al, on, st{
            ignore_bins invalid_transactions = binsof(al) intersect {1} &&
                                               binsof(st) intersect {1};
        }
    endgroup: trigger_stop_al

    function new(virtual aclk_if inter);
        this.inter = inter;
        //time_output = new();
        set_time_alarm = new();
        trigger_stop_al = new();
    endfunction

    function void report();
        $display("=== Time Output Coverage ===");
        $display("Coverage: %0.2f%%", $get_coverage());
    endfunction

endclass

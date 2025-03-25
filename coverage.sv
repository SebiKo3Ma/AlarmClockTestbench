class coverage;
    virtual aclk_tconfig_if cfg_inter;
    virtual aclk_alop_if al_inter;

    covergroup time_output @(posedge cfg_inter.tb_clk);
        ho1: coverpoint cfg_inter.H_out1 {
            bins valid_values[] = {0, 1, 2};
        }
        ho0: coverpoint cfg_inter.H_out0 {
            bins valid_values[] = {[0:9]};
        }
        mo1: coverpoint cfg_inter.M_out1 {
            bins valid_values[] = {[0:5]};
        }
        mo0: coverpoint cfg_inter.M_out0 {
            bins valid_values[] = {[0:9]};
        }
        so1: coverpoint cfg_inter.S_out1 {
            bins valid_values[] = {[0:5]};
        }
        so0: coverpoint cfg_inter.S_out0 {
            bins valid_values[] = {[0:9]};
        }

        ho_x: cross ho1, ho0{
            ignore_bins invalid_hours = binsof(ho1) intersect {2} &&
                                        binsof(ho0) intersect {[4:9]};
        }

        mo_x: cross mo1, mo0;
        so_x: cross so1, so0;
    endgroup: time_output

    covergroup time_input @(posedge cfg_inter.tb_clk);
        hi1: coverpoint cfg_inter.H_in1 {
            bins valid_values[] = {0, 1, 2};
        }
        hi0: coverpoint cfg_inter.H_in0 {
            bins valid_values[] = {[0:9]};
        }
        mi1: coverpoint cfg_inter.M_in1 {
            bins valid_values[] = {[0:5]};
        }
        mi0: coverpoint cfg_inter.M_in0 {
            bins valid_values[] = {[0:9]};
        }

        hi_x: cross hi1, hi0{
            ignore_bins invalid_hours = binsof(hi1) intersect {2} &&
                                        binsof(hi0) intersect {[4:9]};
        }

        mi_x: cross mi1, mi0;

        ldt: coverpoint cfg_inter.LD_time;
        lda: coverpoint cfg_inter.LD_alarm;

        ld_x: cross ldt, lda;
    endgroup: time_input

    covergroup alarm_operations @(posedge al_inter.tb_clk);
        al: coverpoint al_inter.Alarm;
        on: coverpoint al_inter.AL_ON;
        st: coverpoint al_inter.STOP_al;

        al_x: cross al, on, st{
            ignore_bins invalid_transactions = binsof(al) intersect {1} &&
                                               binsof(st) intersect {1};
        }
    endgroup: alarm_operations

    covergroup illegal_inputs @(posedge cfg_inter.tb_clk);
        il_hi1: coverpoint cfg_inter.H_in1 {
            bins valid_values[] = {2, 3};
        }
        il_hi0: coverpoint cfg_inter.H_in0 {
            bins valid_values[] = {[4:15]};
        }
        il_mi1: coverpoint cfg_inter.M_in1 {
            bins valid_values[] = {[6:15]};
        }
        il_mi0: coverpoint cfg_inter.M_in0 {
            bins valid_values[] = {[10:15]};
        }

        hvalid_x: cross il_hi1, il_hi0{
            ignore_bins valid_hours = binsof(il_hi1) intersect {3} &&
                                      binsof(il_hi0) intersect {[4:9]};
        }

    endgroup: illegal_inputs

    function new(virtual aclk_tconfig_if cfg_inter, virtual aclk_alop_if al_inter);
        this.cfg_inter = cfg_inter;
        this.al_inter  = al_inter;
        time_output = new();
        time_input = new();
        alarm_operations = new();
        illegal_inputs = new();
    endfunction

    function void report();
        $display("=== COVERAGE ===");
        $display("Coverage: %0.2f%%\n", $get_coverage());
    endfunction

endclass

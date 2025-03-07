virtual class gen_configs;
    int min_tr; //minimum number of generated transactions
    int max_tr; //maximum number of generated transactions

    function new(int min_tr, int max_tr);
        this.min_tr = min_tr;
        this.max_tr = max_tr;
    endfunction
endclass

class cfg_gen_configs extends gen_configs;
    int w_cr,   //weight of 'Clock Running' transactions
        w_op,   //weight of 'Clock operations' transactions
        w_il;   //weight of illegal transactions

    function new(int min_tr, int max_tr, int w_cr, int w_op, int w_il);
        super.new(min_tr, max_tr);
        this.w_cr = w_cr;
        this.w_op = w_op;
        this.w_il = w_il;
    endfunction
endclass

class al_gen_configs extends gen_configs;
    function new(int min_tr, int max_tr);
        super.new(min_tr, max_tr);
    endfunction
endclass
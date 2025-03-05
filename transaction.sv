virtual class transaction #(type T);
    trans_types tr_type;

    pure virtual function void do_copy(T trans);
    pure virtual function bit do_compare(T trans);
endclass
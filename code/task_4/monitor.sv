class monitor;
    virtual mem_intf vif;
    mailbox mon2scr;
    transaction t;

    function new (virtual mem_intf vif, mailbox mon2scr);
        this.vif = vif;
        this.mon2scr = mon2scr;
    endfunction

    task run();
        forever
            begin
                @(posedge vif.clk);
                t = new();
                if (vif.read)
                    begin
                        t.addr = vif.addr;
                        t.data_out = vif.data_out;
                        // t.read = 1;
                        // t.write = 0;
                        $display("---Monitor---\tAddr:\t%d\t|Data_out:\t%d\t", t.addr, t.data_out);
                        mon2scr.put(t);
                    end
         end
    endtask

endclass
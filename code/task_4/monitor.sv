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
                #1ns;
                t = new();
                // if (vif.read)
                    // begin
                        t.read=vif.read;
                        t.write= vif.write;
                        t.data_in = vif.data_in;
                        t.addr = vif.addr;
                        t.data_out = vif.data_out;
                        $display("---Monitor---\tAddr:\t%d\t|Data_out:\t%d\t", t.addr, t.data_out);
             
                    // end
                mon2scr.put(t);
         end
    endtask

endclass
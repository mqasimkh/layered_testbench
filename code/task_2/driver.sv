class driver;
    transaction t;
    mailbox gen2drv;
    virtual mem_intf vif;
    
    int drv_count;

    function new(mailbox gen2drv, virtual mem_intf vif);
        this.gen2drv = gen2drv;
        this.vif = vif;

    endfunction

    task run();
    forever 
    begin
        t = new(1,1, 3);
        gen2drv.get(t);
        @(negedge vif.clk);
            if (t.write) begin
                vif.write <= 1;
                vif.read <= 0;
                vif.addr <= t.addr;
                vif.data_in <= t.data_in;
                $display("Write Transaction from Driver:\tAddr:\t%d\t|Data_in:\t%d\t", t.addr, t.data_in);
            end

            else begin
                vif.write <= 0;
                vif.read <= 1;
                vif.addr <= t.addr;
                $display("Read Transaction from Driver:\tAddr:\t%d\t|Data_in:\t%d\t", t.addr, t.data_in);
            end
        drv_count++;
    end

    endtask: run

endclass: driver
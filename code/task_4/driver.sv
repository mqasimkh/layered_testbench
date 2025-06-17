class driver;
    transaction t;
    mailbox gen2drv;
    virtual mem_intf vif;
    
    int drv_count = 0;

    function new(mailbox gen2drv, virtual mem_intf vif);
        this.gen2drv = gen2drv;
        this.vif = vif;
    endfunction

    task run();
    forever
    begin
        gen2drv.get(t);
        @(negedge vif.clk);
            if (t.write) begin
                vif.write <= 1;
                vif.read <= 0;
                vif.addr <= t.addr;
                vif.data_in <= t.data_in;
                $display("---Driver---\t*Write*\t\tAddr:\t%d\tData_in:\t%d\tDrv_Count:\t%d", t.addr, t.data_in, drv_count);
            end
            else begin
                vif.write <= 0;
                vif.read <= 1;
                vif.addr <= t.addr;
                $display("---Driver---\t*Read*\t\tAddr:\t%d", t.addr);
            end
      
        drv_count++;
    end
    
    endtask: run

endclass: driver
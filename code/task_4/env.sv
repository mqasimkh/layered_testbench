class env;
    virtual mem_intf vif;
    mailbox gen2drv, gen2scr, mon2scr;
    event gen_done;
    int count;

    generator gen;
    driver drv;
    monitor mon;
    scoreboard sb;

    function new(virtual mem_intf vif, int count);
        this.vif = vif;
        this.count = count;
        gen2drv = new();
        gen2scr = new();
        mon2scr = new();
        gen = new(count, gen2drv, gen2scr, gen_done);
        drv = new (gen2drv, vif);
        mon = new (vif, mon2scr);
        sb = new(gen2scr, mon2scr);
    endfunction

    task test();
        fork
            gen.run();
            drv.run();
            mon.run();
            sb.run();
        join_none
    endtask
    
    task post_test();
        @(gen_done);
        wait(drv.drv_count >= count);
        wait(sb.count >= count);
        $display("Scoreboard Count: %d | Scoreboard Errors: %d", sb.count, sb.errors);
    endtask

    task run();
        test();
        post_test();
        $finish;
    endtask

endclass
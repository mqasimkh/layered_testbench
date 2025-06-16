class generator;
    transaction t;
    mailbox gen2drv;
    mailbox gen2scr;
    int count;

    event complete;

    function new (int count = 0, mailbox gen2drv, mailbox gen2scr, event complete);
        this.gen2drv = gen2drv;
        this.gen2scr = gen2scr;
        // gen2drv = new();
        // gen2scr = new();
        this.count = count;
        t = new (0,0,3);
        this.complete = complete;

    endfunction

    task run();
    bit ok;
        repeat (this.count)
        begin
            t = new (0,0,3);
            ok = t.randomize();
            if (!ok)
                begin
                    $display("Randomization Failed");
                    break;
                end
            else
                begin
                    t.cg.sample();
                    gen2drv.put(t);
                    gen2scr.put(t);
                end
                
        end

    -> complete;

    endtask: run

endclass: generator
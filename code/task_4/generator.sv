class generator;
    transaction t;
    mailbox gen2drv;
    mailbox gen2scr;
    int count;

    int t_count;

    event complete;

    function new (int count = 0, mailbox gen2drv, mailbox gen2scr, event complete);
        this.gen2drv = gen2drv;
        this.gen2scr = gen2scr;
        this.count = count;
        this.complete = complete;

    endfunction

    task run();
    bit ok;
        repeat (this.count)
        begin
            t = new ();
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
            t_count++;
        end
        $display("\n");
        $display("*************************************************");
        $display("\tGenerator\t");
        $display("*************************************************");
        $display("Total Transactions Generated: %0d", t_count);
        $display("\n");
        -> complete;

    endtask: run

endclass: generator
class generator;
    transaction t;
    mailbox gen2drv;
    mailbox gen2scr;
    int count;
    event complete;
    int gen_count = 0;
    int count_w;
    int count_r;

    function new (int count = 0, mailbox gen2drv, mailbox gen2scr, event complete);
        this.gen2drv = gen2drv;
        this.gen2scr = gen2scr;
        this.count = count;
        this.complete = complete;
        gen2drv = new();
        gen2scr = new();
        //t = new();
    endfunction

    task run();
    bit ok;
        repeat (count)
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
                            if (t.write)
                                count_w++;
                            else
                                count_r++;
                    end
        gen_count++;
        end
        -> complete;

    endtask: run

endclass: generator
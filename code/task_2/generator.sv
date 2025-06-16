class generator
    transaction t;
    mailbox gen2drv;
    mailbox gen2scr;
    int count;

    event complete;

    function new (int count = 0, mailbox gen2drv, mailbox gen2scr);
        this.gen2drv = gen2drv;
        this.gen2scr = gen2scr;
        gen2drv = new();
        gen2scr = new();
        this.count = count;
        t = new (0,0,3);

    endfunction

task run(int count);
bit ok;
    repeat (count)
    begin
        t = new (0,0,3);
        t.randomize();
        if (!ok)
            begin
                $display("Randomization Failed");
                break;
            end
        else
            t.cg.sample();
            gen2drv.put(t);
            gen2scr.put(t);

            -> complete;
    
    end

endtask: run

endclass: generator
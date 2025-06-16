class generator
    transaction t;
    mailbox gen2drv;
    mailbox gen2scr;
    int count;

    event complete;
    bit ok;

    function new (int count = 0, mailbox gen2drv, mailbox gen2scr);
        t = new (1,3,3);
        this.gen2drv = gen2drv;
        this.gen2scr = gen2scr;
        gen2drv = new();
        gen2scr = new();
        this.count = count;

    endfunction

    task run(int count);
        repeat (count);
            begin
                t.randomize();
                if (!ok)
                    $display("Randomization Failed");
                else

            end
            -> complete;
    endtask: run

    initial begin
        always @(complete)
        $display ("Generator work completed");
    end;

endclass: generator
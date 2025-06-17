class scoreboard;
    transaction actual;
    transaction expected;
    mailbox gen2scr;
    mailbox mon2scr;

    int  golden_model [int];
    
    int errors;
    int count;
    int pass;

    function new(mailbox gen2scr, mailbox mon2scr);
        this.gen2scr = gen2scr;
        this.mon2scr = mon2scr;
    endfunction

    task run();
        forever begin

        actual   = new();
        expected = new();
        gen2scr.get(expected);
        mon2scr.get(actual);

        if (expected.write) 
        begin
            golden_model[expected.addr] = expected.data_in;
            $display("");
            $display("***Scoreboard***");
            $display("Data Written to Array. Data Wrote: %d | Address = %d", expected.data_in, expected.addr);
        end

        else if (actual.read && golden_model.exists(actual.addr)) 
        begin
            if (golden_model[actual.addr] == actual.data_out) begin
                $display("Test Passed");
                pass++;
            end
            else if (golden_model[actual.addr] == 8'hx) begin
                $display("Test Passed");
                pass++;
            end
            else 
                begin
                    $display("Test Failed");
                    errors++;
                end
        end

        count++;
        //$display("Scoreboard count: %d", count);
        $display("\n");
    
    end
    endtask: run

endclass
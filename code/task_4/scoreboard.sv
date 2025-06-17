class scoreboard;
    transaction actual;
    transaction expected;
    mailbox gen2scr;
    mailbox mon2scr;

    logic [7:0] golden_model [31:0] = '{default: 0};
    
    int errors;
    int count;

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

        if (expected.write) begin
            golden_model[expected.addr] = expected.data_in;
            $display("***Data Written to Array. Data Wrote: %d | Address = %d***", expected.data_in, expected.addr);
        end

        else if (actual.read) 
        begin
            if (golden_model[actual.addr] == actual.data_out)  
                $display("Test Passed");
            else
            begin
                $display("Test Failed");
                errors++;
            end
        end

        count++;
        $display("Scoreboard count: %d", count);
        $display("\n");
    
    end
    endtask: run

endclass
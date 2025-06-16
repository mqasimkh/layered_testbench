class scoreboard;
    transaction actual;
    transaction expected;
    mailbox gen2scr;
    mailbox mon2scr;

    int errors;
    int count;

    function new(mailbox gen2scr, mailbox mon2scr);
        this.gen2scr = gen2scr;
        this.mon2scr = mon2scr;
    endfunction

    task run();
        forever 
            begin
                expected = new (0,0,0);
                actual = new(0,0,0);
                gen2scr.get(expected);
                mon2scr.get(actual);
                    if (!(expected.addr == actual.addr && expected.data_out == actual.data_out))
                        begin
                            $display("Error (Scoreboard), expected addr: %d | Actual addr: %d | Expected Data_Out = %d | Actual Data_Out = %d | Expected Data_in: %d | Actual Data_in: %d", expected.addr, actual.addr, expected.data_out, actual.data_out, expected.data_in, actual.data_in);
                        errors++;
                        end
                    else
                        count++;
            end
    endtask

endclass
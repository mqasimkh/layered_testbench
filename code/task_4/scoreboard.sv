class scoreboard;
    transaction actual;
    transaction expected;
    mailbox gen2scr;
    mailbox mon2scr;

    logic [7:0] golden_model [logic [31:0]] =  
    
    int errors;
    int count;

    function new(mailbox gen2scr, mailbox mon2scr);
        this.gen2scr = gen2scr;
        this.mon2scr = mon2scr;
    endfunction



endclass
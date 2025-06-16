module mem_test ( 
    mem_intf.mem_test memi
  );


bit debug = 1;
logic [7:0] rdata;

  initial begin
      $timeformat ( -9, 0, " ns", 9 );
      #40000ns $display ( "MEMORY TEST TIMEOUT" );
      $finish;
    end

initial
  begin: memtest
    
    $display("\n");
    clear_memory_test();
    $display("\n");

    $display("\n");
    data_equal_address();
    $display("\n");

    $display("\n");
    randomization();
    $display("\n");

    $display("\n");
    print_memory();
    $display("\n");

    $display("\n");
    test_read_write();
    $display("\n");

    $finish;
    
  end

//////////////////////////////////////////////////////////////////////////////////////////////
task randomization();
  logic [7:0] randomize_value;
  logic [4:0] addr;
  logic [7:0] val;
  bit ok;

    transaction t;
    t = new (1,3,3);

    $display("*********************************************************");
    $display("Testing Randomization");
    $display("*********************************************************");

    for (int i = 0; i < 32; i++)
      begin
        ok = t.randomize();
        // t.controlled_c.constraint_mode(0);
        // t.read_write.constraint_mode(0);


        if (!ok)
        begin
          $display("Randomization failed!!!");
          break;
        end

        t.cg.sample();
        addr = t.random_addr;
        val = t.random_value;

      // $display("Addr:   %d   |   Data:   %h   |   ASCII:   %c   ", addr, val, val);
      // memi.write_mem(addr, val);
      // memi.read_mem(addr, rdata);

      // $display("Addr:\t%0d\t|\tData:\t%h\t|\tASCII:\t%c\t", t.random_addr, t.random_value, t.random_value);
      // memi.write_mem(t.random_addr, t.random_value);
      // memi.read_mem(t.random_addr, rdata);

      t.display();

      end

endtask: randomization

//////////////////////////////////////////////////////////////////////////////////////////////
task test_read_write();
  bit ok;
  display("*********************************************************");
  $display("Testing Read and Write Constriant");
  $display("*********************************************************");

  transaction t;
  t = new (1,3,3);

  repeat (7)
    begin
      ok = t.randomize();
      if (!ok)
        $display("Randomization Failed");
      else
        begin
          if (t.read && t.write)
            $display("Read/Write Constraint Failed. Read = 1 & Write = 1");
          else if (!t.read && !t.write)
            $display("Read/Write Constraint Failed. Read = 0 & Write = 0");
          else
            $display("Read and Write Constraint Passed. Read = %b | Write = %b", t.read, t.write);
        end
    end

endtask:test_read_write

//////////////////////////////////////////////////////////////////////////////////////////////
task print_memory();
    $display("*********************************************************");
    $display("Memory Read");
    $display("*********************************************************");
  for (int i = 0; i < 32; i++) begin
    memi.read_mem(i, rdata);
    $display("Addr:\t%0d\t|\tData:\t%h\t|\tASCII:\t%c\t", i, rdata, rdata);
  end
endtask

//////////////////////////////////////////////////////////////////////////////////////////////
task clear_memory_test();
    $display("*********************************************************");
    $display("Clear Memory Test");
    $display("*********************************************************");

    for (int i = 0; i< 32; i++)
    begin
        memi.write_mem(i, 8'h0);
    end

    for (int i = 0; i<32; i++)
      begin 
      memi.read_mem(i, rdata);
        if (rdata != 8'h0)
        begin
          $display("Test Failed. Data at %d is %b", i, rdata);
          $finish;
        end
        else
         $display("Passed. Data\t=\t%0h\t|\tAddress\t=\t%0h\t", memi.data_out, memi.addr);
      end
endtask

//////////////////////////////////////////////////////////////////////////////////////////////
task data_equal_address();
    $display("*********************************************************");
    $display("Data Equal Address Test");
    $display("*********************************************************");

    for (int i = 0; i< 32; i++)
    // Write data = address to every address location
    memi.write_mem(i, i);
       
    for (int i = 0; i<32; i++)
      begin
        memi.read_mem(i, rdata);
        if (rdata != i)
        begin
          $display("Test Failed. Data at %d is %d", i, rdata);
          $finish;
        end
        else
         $display("Passed. Data\t=\t%0h\t|\tAddress\t=\t%h\t", memi.data_out, memi.addr);
      end

endtask

endmodule
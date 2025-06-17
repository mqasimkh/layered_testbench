module tb;
    bit clk;
    initial clk = 0;
    always #5 clk = ~clk;
    mem_intf bus(clk);
    env env;

    mem dut(bus);
    initial 
        begin
            env = new(bus, 17);
            env.run();
        end

endmodule
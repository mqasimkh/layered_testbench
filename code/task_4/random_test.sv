module tb;
    interface mem_intf bus();
    env env;
    virtual mem_intf vif;

    mem dut(bus);
    
    initial bus.clk = 0;
    always #5 bus.clk = ~bus.clk;

    initial 
        begin
            vif = bus;
            env = new(vif, 10);
            env.run();
        end

endmodule
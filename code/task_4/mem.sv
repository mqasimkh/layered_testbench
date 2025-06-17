module mem(
    mem_intf bus
);

    logic [7:0] memory [31:0];

    always_ff @(posedge bus.clk)
        begin
            if (bus.write == 1 && bus.read == 0)
                begin
                    memory[bus.addr] <= bus.data_in;
                end
            else if (bus.read == 1 && bus.write == 0)
                begin
                    bus.data_out <= memory[bus.addr];
                end
        end

endmodule
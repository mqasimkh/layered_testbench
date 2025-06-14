module mem(
    mem_intf.mem xyz
);

    logic [7:0] memory [31:0];

    always_ff @(posedge xyz.clk)
        begin
            if (xyz.write == 1 && xyz.read == 0)
                begin
                    memory[xyz.addr] <= xyz.data_in;
                end
            else if (xyz.read == 1 && xyz.write == 0)
                begin
                    xyz.data_out <= memory[xyz.addr];
                end
        end

endmodule
module top;

bit clk = 0;

mem_intf abc(clk);

mem_test test (.memi(abc));
mem memory (.xyz(abc));

always #5 clk = ~clk;

endmodule
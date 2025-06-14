//testing connection
interface mem_intf(input clk);
    logic read; 
    logic write; 
    logic [4:0] addr; 
    logic [7:0] data_in;
    logic [7:0] data_out;

    modport mem (input clk, data_in, addr, read, write, output data_out);
    modport mem_test (output read, write, addr, data_in, input data_out, clk, import write_mem, read_mem);
    
    //task for writing to mem address
    task write_mem (input logic [4:0] address, input logic [7:0] data);
        begin
            @(negedge clk)
            addr = address;
            data_in = data;
            write = 1;
            read = 0;
            //$display("Data Wrote: %d", data);

            @(posedge clk)
            #1;
            write = 0;
        end
    endtask

    //reading from mem address
    task read_mem (input logic [4:0] address, output logic [7:0] data);
        begin
            @(negedge clk)
            addr = address;
            write = 0;
            read = 1;
            

            @(posedge clk)
            #1;
            data = data_out;
            //$display("Data Read: %d", data);

        end
endtask

endinterface
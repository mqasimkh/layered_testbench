typedef enum {ASCII, upper, lower, weighted} control;

class transaction;

    randc logic [4:0] addr;
    rand logic [7:0] data_in;
    logic [7:0] data_out;

    control ctrl;
    rand bit read; 
    rand bit write;

    constraint controlled_c {
        if (ctrl == ASCII)
            data_in inside {[8'h20:8'h7F]};
        else if (ctrl == upper)
            data_in inside {[8'h41:8'h5A]};
        else if (ctrl == lower)
            data_in inside {[8'h61:8'h7A]};
        else if (ctrl == weighted)
            data_in dist { [8'h41:8'h5A] := 8, [8'h61:8'h7A] := 2 };
    }

    constraint read_write {
         read == 1 -> write == 0;
         read == 0 -> write == 1;
         write == 1 -> read == 0; 
         write == 0 -> read == 1; 
    }

    covergroup cg;
    
      cp_1: coverpoint addr;
      cp_2: coverpoint data_in {
        bins upper = {[8'h41:8'h5a]};
        bins lower = {[8'h61:8'h7a]};
        bins restof = default;
      }
      
  endgroup: cg

    function new();
        addr = 0;
        data_in = 3;
        cg = new();
        read = 0;
        write = 1;
        data_out = 0;
    endfunction

    function void display();
        $display("Address:\t%0d\t|\tData_In:\t%h\t|\tASCII:\t%c\t|\tctrl:\t%d\t|\tread:\t%b\t|\twrite:\t%b\t", addr, data_in, data_in, ctrl, read, write);
    endfunction:display

endclass: transaction
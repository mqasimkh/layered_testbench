typedef enum {ASCII, upper, lower, weighted} control;

class transaction;

    randc bit [4:0] random_addr;
    rand bit [7:0] random_value;
    rand control ctrl;
    rand bit read; 
    rand bit write;

    constraint controlled_c {
        if (ctrl == ASCII)
            random_value inside {[8'h20:8'h7F]};
        else if (ctrl == upper)
            random_value inside {[8'h41:8'h5A]};
        else if (ctrl == lower)
            random_value inside {[8'h61:8'h7A]};
        else if (ctrl == weighted)
            random_value dist { [8'h41:8'h5A] := 8, [8'h61:8'h7A] := 2 };
    }

    constraint read_write {
         read == 1 -> write == 0;
         read == 0 -> write == 1;
         write == 1 -> read == 0; 
         write == 0 -> read == 1; 
    }

    covergroup cg;
    
      cp_1: coverpoint random_addr;
      cp_2: coverpoint random_value {
        bins upper = {[8'h41:8'h5a]};
        bins lower = {[8'h61:8'h7a]};
        bins restof = default;
      }
      
  endgroup: cg

    function new(bit [4:0] addr, bit [7:0] value, bit read = 0, bit write = 0);
        random_addr = addr;
        random_value = value;
        //ctrl = c;
        cg = new();
        this.read = read;
        this.write = write;

    endfunction

    function void display();
        $display("Addr:\t%0d\t|\tData:\t%h\t|\tASCII:\t%c\t|\tctrl:\t%d\t|\tread:\t%b\t|\twrite:\t%b\t", random_addr, random_value, random_value, ctrl, read, write);
    endfunction:display

endclass: transaction
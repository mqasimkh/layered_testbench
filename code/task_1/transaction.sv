typedef enum {ASCII, upper, lower, weighted} control;

class transaction;

    randc bit [4:0] random_addr;
    rand bit [7:0] random_value;
    control ctrl;

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

    covergroup cg;
    
      cp_1: coverpoint random_addr;
      cp_2: coverpoint random_value {
        bins upper = {[8'h41:8'h5a]};
        bins lower = {[8'h61:8'h7a]};
        bins restof = default;
      }
      
  endgroup: cg

    function new(bit [4:0] addr, bit [7:0] value, control c);
        random_addr = addr;
        random_value = value;
        ctrl = c;
        cg = new();

    endfunction

endclass: transaction
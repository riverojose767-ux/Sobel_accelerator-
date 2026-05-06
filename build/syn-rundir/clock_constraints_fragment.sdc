create_clock clk -name clk -period 15.0
set_clock_uncertainty 0.1 [get_clocks clk]
set_clock_groups -asynchronous  -group { clk }


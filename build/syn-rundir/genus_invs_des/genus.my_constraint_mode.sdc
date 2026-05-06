# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.12-s068_1 on Thu Apr 30 22:51:22 PDT 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design sobel_top

create_clock -name "clk" -period 15.0 -waveform {0.0 7.5} [get_ports clk]
set_load -pin_load 0.01 [get_ports edge_out]
set_load -pin_load 0.01 [get_ports valid_edge]
set_load -pin_load 0.01 [get_ports frame_done]
set_load -pin_load 0.005 [get_ports {debug_col[6]}]
set_load -pin_load 0.005 [get_ports {debug_col[5]}]
set_load -pin_load 0.005 [get_ports {debug_col[4]}]
set_load -pin_load 0.005 [get_ports {debug_col[3]}]
set_load -pin_load 0.005 [get_ports {debug_col[2]}]
set_load -pin_load 0.005 [get_ports {debug_col[1]}]
set_load -pin_load 0.005 [get_ports {debug_col[0]}]
set_load -pin_load 0.005 [get_ports {debug_row[6]}]
set_load -pin_load 0.005 [get_ports {debug_row[5]}]
set_load -pin_load 0.005 [get_ports {debug_row[4]}]
set_load -pin_load 0.005 [get_ports {debug_row[3]}]
set_load -pin_load 0.005 [get_ports {debug_row[2]}]
set_load -pin_load 0.005 [get_ports {debug_row[1]}]
set_load -pin_load 0.005 [get_ports {debug_row[0]}]
set_clock_groups -name "clock_groups_clk_to_others" -asynchronous -group [get_clocks clk]
set_clock_gating_check -setup 0.0 
set_clock_uncertainty -setup 0.1 [get_clocks clk]
set_clock_uncertainty -hold 0.1 [get_clocks clk]

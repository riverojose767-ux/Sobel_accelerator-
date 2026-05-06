puts "set_db design_process_node 130" 
set_db design_process_node 130
puts "set_multi_cpu_usage -local_cpu 8" 
set_multi_cpu_usage -local_cpu 8
puts "set_db timing_analysis_cppr both" 
set_db timing_analysis_cppr both
puts "set_db timing_analysis_type ocv" 
set_db timing_analysis_type ocv
puts "set_library_unit -time 1ns" 
set_library_unit -time 1ns
puts "set_db init_design_uniquify true" 
set_db init_design_uniquify true
puts "set_db si_delay_separate_on_data true" 
set_db si_delay_separate_on_data true
puts "set_db si_delay_enable_report true" 
set_db si_delay_enable_report true
puts "read_physical -lef { /home/josee767/ee478/capstone/sobel_accelerator/build/tech-sky130-cache/sky130_fd_sc_hd__nom.tlef /home/projects/ee477.2025wtr/cad/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef }" 
read_physical -lef { /home/josee767/ee478/capstone/sobel_accelerator/build/tech-sky130-cache/sky130_fd_sc_hd__nom.tlef /home/projects/ee477.2025wtr/cad/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef }
puts "read_mmmc /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/mmmc.tcl" 
read_mmmc /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/mmmc.tcl
puts "read_netlist { /home/josee767/ee478/capstone/sobel_accelerator/build/syn-rundir/sobel_top.mapped.v } -top sobel_top" 
read_netlist { /home/josee767/ee478/capstone/sobel_accelerator/build/syn-rundir/sobel_top.mapped.v } -top sobel_top
puts "init_design" 
init_design
puts "read_power_intent -cpf /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/power_spec.cpf" 
read_power_intent -cpf /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/power_spec.cpf
puts "commit_power_intent" 
commit_power_intent
puts "set_db design_flow_effort extreme" 
set_db design_flow_effort extreme

puts "set_dont_use \[get_db lib_cells */*sdf*\]"
if { [get_db lib_cells */*sdf*] ne "" } {
    set_dont_use [get_db lib_cells */*sdf*]
} else {
    puts "WARNING: cell */*sdf* was not found for set_dont_use"
}
            

puts "set_dont_use \[get_db lib_cells */sky130_fd_sc_hd__probe_p_*\]"
if { [get_db lib_cells */sky130_fd_sc_hd__probe_p_*] ne "" } {
    set_dont_use [get_db lib_cells */sky130_fd_sc_hd__probe_p_*]
} else {
    puts "WARNING: cell */sky130_fd_sc_hd__probe_p_* was not found for set_dont_use"
}
            

puts "set_dont_use \[get_db lib_cells */sky130_fd_sc_hd__probec_p_*\]"
if { [get_db lib_cells */sky130_fd_sc_hd__probec_p_*] ne "" } {
    set_dont_use [get_db lib_cells */sky130_fd_sc_hd__probec_p_*]
} else {
    puts "WARNING: cell */sky130_fd_sc_hd__probec_p_* was not found for set_dont_use"
}
            
puts "write_db pre_sky130_innovus_settings" 
write_db pre_sky130_innovus_settings
puts "ln -sfn pre_sky130_innovus_settings latest" 
ln -sfn pre_sky130_innovus_settings latest


##########################################################
# Placement attributes  [get_db -category place]
##########################################################
#-------------------------------------------------------------------------------
set_db place_global_place_io_pins  true

set_db opt_honor_fences true
set_db place_detail_dpt_flow true
set_db place_detail_color_aware_legal true
set_db place_global_solver_effort high
set_db place_detail_check_cut_spacing true
set_db place_global_cong_effort high

##########################################################
# Optimization attributes  [get_db -category opt]
##########################################################
#-------------------------------------------------------------------------------

set_db opt_fix_fanout_load true
set_db opt_clock_gate_aware false
set_db opt_area_recovery true
set_db opt_post_route_area_reclaim setup_aware
set_db opt_fix_hold_verbose true

##########################################################
# Clock attributes  [get_db -category cts]
##########################################################
#-------------------------------------------------------------------------------
set_db cts_target_skew 0.03
set_db cts_max_fanout 10
set_db cts_target_max_transition_time .3
set_db opt_setup_target_slack 0.10
set_db opt_hold_target_slack 0.10

##########################################################
# Routing attributes  [get_db -category route]
##########################################################
#-------------------------------------------------------------------------------
set_db route_design_bottom_routing_layer 2
    
puts "write_db pre_floorplan_design" 
write_db pre_floorplan_design
puts "ln -sfn pre_floorplan_design latest" 
ln -sfn pre_floorplan_design latest
puts "source -echo -verbose /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/floorplan.tcl" 
source -echo -verbose /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/floorplan.tcl
puts "write_db pre_place_bumps" 
write_db pre_place_bumps
puts "ln -sfn pre_place_bumps latest" 
ln -sfn pre_place_bumps latest
puts "write_db pre_sky130_add_endcaps" 
write_db pre_sky130_add_endcaps
puts "ln -sfn pre_sky130_add_endcaps latest" 
ln -sfn pre_sky130_add_endcaps latest

set_db add_endcaps_boundary_tap     true
set_db add_endcaps_left_edge        sky130_fd_sc_hd__tap_1
set_db add_endcaps_right_edge       sky130_fd_sc_hd__tap_1
add_endcaps
    
puts "write_db pre_place_tap_cells" 
write_db pre_place_tap_cells
puts "ln -sfn pre_place_tap_cells latest" 
ln -sfn pre_place_tap_cells latest
set_db add_well_taps_cell sky130_fd_sc_hd__tapvpwrvgnd_1
add_well_taps -cell_interval 15 -in_row_offset 5
puts "write_db pre_sky130_connect_nets" 
write_db pre_sky130_connect_nets
puts "ln -sfn pre_sky130_connect_nets latest" 
ln -sfn pre_sky130_connect_nets latest
connect_global_net VDD -type pg_pin -pin_base_name VPWR -all -auto_tie -netlist_override
connect_global_net VDD -type net    -net_base_name VPWR -all -netlist_override
connect_global_net VDD -type pg_pin -pin_base_name VPB -all -auto_tie -netlist_override
connect_global_net VDD -type net    -net_base_name VPB -all -netlist_override
connect_global_net VSS -type pg_pin -pin_base_name VGND -all -auto_tie -netlist_override
connect_global_net VSS -type net    -net_base_name VGND -all -netlist_override
connect_global_net VSS -type pg_pin -pin_base_name VNB -all -auto_tie -netlist_override
connect_global_net VSS -type net    -net_base_name VNB -all -netlist_override
puts "write_db pre_power_straps" 
write_db pre_power_straps
puts "ln -sfn pre_power_straps latest" 
ln -sfn pre_power_straps latest
puts "source -echo -verbose /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/power_straps.tcl" 
source -echo -verbose /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/power_straps.tcl
puts "write_db pre_place_pins" 
write_db pre_place_pins
puts "ln -sfn pre_place_pins latest" 
ln -sfn pre_place_pins latest
puts "set_db assign_pins_edit_in_batch true" 
set_db assign_pins_edit_in_batch true
puts "edit_pin -fixed_pin -pin * -hinst sobel_top -pattern fill_optimised -layer { met2 met4 } -side bottom -start { 1000 0 } -end { 0 0 }   " 
edit_pin -fixed_pin -pin * -hinst sobel_top -pattern fill_optimised -layer { met2 met4 } -side bottom -start { 1000 0 } -end { 0 0 }   
puts "set_db assign_pins_edit_in_batch false" 
set_db assign_pins_edit_in_batch false
puts "write_db pre_place_opt_design" 
write_db pre_place_opt_design
puts "ln -sfn pre_place_opt_design latest" 
ln -sfn pre_place_opt_design latest
puts "place_opt_design" 
place_opt_design
puts "write_db pre_innovus_snap_floorplan" 
write_db pre_innovus_snap_floorplan
puts "ln -sfn pre_innovus_snap_floorplan latest" 
ln -sfn pre_innovus_snap_floorplan latest
puts "snap_floorplan -all" 
snap_floorplan -all
puts "write_db pre_clock_tree" 
write_db pre_clock_tree
puts "ln -sfn pre_clock_tree latest" 
ln -sfn pre_clock_tree latest
puts "create_clock_tree_spec" 
create_clock_tree_spec
puts "ccopt_design -hold -report_dir hammer_cts_debug -report_prefix hammer_cts" 
ccopt_design -hold -report_dir hammer_cts_debug -report_prefix hammer_cts
puts "write_db pre_add_fillers" 
write_db pre_add_fillers
puts "ln -sfn pre_add_fillers latest" 
ln -sfn pre_add_fillers latest
set_db add_fillers_cells "sky130_fd_sc_hd__fill_8 sky130_fd_sc_hd__fill_4 sky130_fd_sc_hd__fill_2 sky130_fd_sc_hd__fill_1"
puts "add_fillers" 
add_fillers
puts "write_db pre_route_design" 
write_db pre_route_design
puts "ln -sfn pre_route_design latest" 
ln -sfn pre_route_design latest
puts "set_db design_express_route true" 
set_db design_express_route true
puts "route_design" 
route_design
puts "write_db pre_opt_design" 
write_db pre_opt_design
puts "ln -sfn pre_opt_design latest" 
ln -sfn pre_opt_design latest
puts "opt_design -post_route -setup -hold -expanded_views" 
opt_design -post_route -setup -hold -expanded_views
puts "write_db pre_write_regs" 
write_db pre_write_regs
puts "ln -sfn pre_write_regs latest" 
ln -sfn pre_write_regs latest

        set write_cells_ir "./find_regs_cells.json"
        set write_cells_ir [open $write_cells_ir "w"]
        puts $write_cells_ir "\["

        set refs [get_db [get_db lib_cells -if .is_sequential==true] .base_name]

        set len [llength $refs]

        for {set i 0} {$i < [llength $refs]} {incr i} {
            if {$i == $len - 1} {
                puts $write_cells_ir "    \"[lindex $refs $i]\""
            } else {
                puts $write_cells_ir "    \"[lindex $refs $i]\","
            }
        }

        puts $write_cells_ir "\]"
        close $write_cells_ir
        set write_regs_ir "./find_regs_paths.json"
        set write_regs_ir [open $write_regs_ir "w"]
        puts $write_regs_ir "\["

        set regs [get_db [get_db [all_registers -edge_triggered -output_pins] -if .direction==out] .name]

        set len [llength $regs]

        for {set i 0} {$i < [llength $regs]} {incr i} {
            #regsub -all {/} [lindex $regs $i] . myreg
            set myreg [lindex $regs $i]
            if {$i == $len - 1} {
                puts $write_regs_ir "    \"$myreg\""
            } else {
                puts $write_regs_ir "    \"$myreg\","
            }
        }

        puts $write_regs_ir "\]"

        close $write_regs_ir
        
puts "write_db pre_sky130_connect_nets2" 
write_db pre_sky130_connect_nets2
puts "ln -sfn pre_sky130_connect_nets2 latest" 
ln -sfn pre_sky130_connect_nets2 latest
connect_global_net VDD -type pg_pin -pin_base_name VPWR -all -auto_tie -netlist_override
connect_global_net VDD -type net    -net_base_name VPWR -all -netlist_override
connect_global_net VDD -type pg_pin -pin_base_name VPB -all -auto_tie -netlist_override
connect_global_net VDD -type net    -net_base_name VPB -all -netlist_override
connect_global_net VSS -type pg_pin -pin_base_name VGND -all -auto_tie -netlist_override
connect_global_net VSS -type net    -net_base_name VGND -all -netlist_override
connect_global_net VSS -type pg_pin -pin_base_name VNB -all -auto_tie -netlist_override
connect_global_net VSS -type net    -net_base_name VNB -all -netlist_override
puts "write_db pre_innovus_overwrite_write_sdf_funct" 
write_db pre_innovus_overwrite_write_sdf_funct
puts "ln -sfn pre_innovus_overwrite_write_sdf_funct latest" 
ln -sfn pre_innovus_overwrite_write_sdf_funct latest
puts "write_db pre_innovus_extra_reports" 
write_db pre_innovus_extra_reports
puts "ln -sfn pre_innovus_extra_reports latest" 
ln -sfn pre_innovus_extra_reports latest
puts "report_power -hierarchy all -out_file sobel_top_power.rpt" 
report_power -hierarchy all -out_file sobel_top_power.rpt
puts "report_area -detail > sobel_top_area.rpt" 
report_area -detail > sobel_top_area.rpt
set pg_list [get_path_group -include_internal_groups]
set_db timing_enable_simultaneous_setup_hold_mode true
foreach_in_collection g $pg_list {
  report_timing -check_type setup -group [get_property $g name] -nworst 50 > timingReports/sobel_top_postRoute_[get_property $g name].tarpt.gz
  report_timing -check_type  hold -group [get_property $g name] -nworst 50 > timingReports/sobel_top_postRoute_[get_property $g name]_hold.tarpt.gz
}
puts "write_db pre_write_design" 
write_db pre_write_design
puts "ln -sfn pre_write_design latest" 
ln -sfn pre_write_design latest
puts "write_db sobel_top_FINAL -def -verilog" 
write_db sobel_top_FINAL -def -verilog
puts "set_db write_stream_virtual_connection false" 
set_db write_stream_virtual_connection false
puts "connect_global_net VDD -type net -net_base_name VPWR" 
connect_global_net VDD -type net -net_base_name VPWR
puts "connect_global_net VDD -type net -net_base_name VPB" 
connect_global_net VDD -type net -net_base_name VPB
puts "connect_global_net VSS -type net -net_base_name VGND" 
connect_global_net VSS -type net -net_base_name VGND
puts "connect_global_net VSS -type net -net_base_name VNB" 
connect_global_net VSS -type net -net_base_name VNB
puts "write_netlist /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/sobel_top.lvs.v -top_module_first -top_module sobel_top -exclude_leaf_cells -phys -flat -exclude_insts_of_cells { sky130_fd_sc_hd__tap_1 sky130_fd_sc_hd__tap_2 sky130_fd_sc_hd__tapvgnd_1 sky130_fd_sc_hd__tapvpwrvgnd_1 sky130_fd_sc_hd__fill_1 sky130_fd_sc_hd__fill_2 sky130_fd_sc_hd__fill_4 sky130_fd_sc_hd__fill_8 sky130_fd_sc_hd__diode_2 } " 
write_netlist /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/sobel_top.lvs.v -top_module_first -top_module sobel_top -exclude_leaf_cells -phys -flat -exclude_insts_of_cells { sky130_fd_sc_hd__tap_1 sky130_fd_sc_hd__tap_2 sky130_fd_sc_hd__tapvgnd_1 sky130_fd_sc_hd__tapvpwrvgnd_1 sky130_fd_sc_hd__fill_1 sky130_fd_sc_hd__fill_2 sky130_fd_sc_hd__fill_4 sky130_fd_sc_hd__fill_8 sky130_fd_sc_hd__diode_2 } 
puts "write_netlist /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/sobel_top.sim.v -top_module_first -top_module sobel_top -exclude_leaf_cells -exclude_insts_of_cells { sky130_fd_sc_hd__tap_1 sky130_fd_sc_hd__tap_2 sky130_fd_sc_hd__tapvgnd_1 sky130_fd_sc_hd__tapvpwrvgnd_1 sky130_fd_sc_hd__fill_1 sky130_fd_sc_hd__fill_2 sky130_fd_sc_hd__fill_4 sky130_fd_sc_hd__fill_8 sky130_fd_sc_hd__diode_2 } " 
write_netlist /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/sobel_top.sim.v -top_module_first -top_module sobel_top -exclude_leaf_cells -exclude_insts_of_cells { sky130_fd_sc_hd__tap_1 sky130_fd_sc_hd__tap_2 sky130_fd_sc_hd__tapvgnd_1 sky130_fd_sc_hd__tapvpwrvgnd_1 sky130_fd_sc_hd__fill_1 sky130_fd_sc_hd__fill_2 sky130_fd_sc_hd__fill_4 sky130_fd_sc_hd__fill_8 sky130_fd_sc_hd__diode_2 } 
puts "write_stream -mode ALL -map_file /home/josee767/ee478/ee477-hammer-cad/hammer/src/hammer-vlsi/technology/sky130/extra/sky130_lefpin.map -uniquify_cell_names -merge { /home/projects/ee477.2025wtr/cad/pdk/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds }  /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/sobel_top.gds" 
write_stream -mode ALL -map_file /home/josee767/ee478/ee477-hammer-cad/hammer/src/hammer-vlsi/technology/sky130/extra/sky130_lefpin.map -uniquify_cell_names -merge { /home/projects/ee477.2025wtr/cad/pdk/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds }  /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/sobel_top.gds
puts "write_sdf /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/sobel_top.par.sdf -recompute_delaycal -edges library -min_period_edges posedge" 
write_sdf /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/sobel_top.par.sdf -recompute_delaycal -edges library -min_period_edges posedge
puts "write_sdc /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/sobel_top.par.sdc" 
write_sdc /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/sobel_top.par.sdc
puts "set_db extract_rc_coupled true" 
set_db extract_rc_coupled true
puts "extract_rc" 
extract_rc
puts "write_parasitics -spef_file /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/sobel_top.ss_100C_1v60.par.spef -rc_corner ss_100C_1v60.setup_rc" 
write_parasitics -spef_file /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/sobel_top.ss_100C_1v60.par.spef -rc_corner ss_100C_1v60.setup_rc
puts "write_parasitics -spef_file /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/sobel_top.ff_n40C_1v95.par.spef -rc_corner ff_n40C_1v95.hold_rc" 
write_parasitics -spef_file /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/sobel_top.ff_n40C_1v95.par.spef -rc_corner ff_n40C_1v95.hold_rc
puts "write_parasitics -spef_file /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/sobel_top.tt_025C_1v80.par.spef -rc_corner tt_025C_1v80.extra_rc" 
write_parasitics -spef_file /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/sobel_top.tt_025C_1v80.par.spef -rc_corner tt_025C_1v80.extra_rc
puts "write_db pre_innovus_gen_klayout_view_script" 
write_db pre_innovus_gen_klayout_view_script
puts "ln -sfn pre_innovus_gen_klayout_view_script latest" 
ln -sfn pre_innovus_gen_klayout_view_script latest
puts "write_db pre_innovus_gen_magic_view_script" 
write_db pre_innovus_gen_magic_view_script
puts "ln -sfn pre_innovus_gen_magic_view_script latest" 
ln -sfn pre_innovus_gen_magic_view_script latest
puts "write_db post_innovus_gen_magic_view_script" 
write_db post_innovus_gen_magic_view_script
puts "ln -sfn post_innovus_gen_magic_view_script latest" 
ln -sfn post_innovus_gen_magic_view_script latest
puts "exit" 
exit
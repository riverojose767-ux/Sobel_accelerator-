################################################################################
#
# Init setup file
# Created by Genus(TM) Synthesis Solution on 04/30/2026 22:51:22
#
################################################################################
if { ![is_common_ui_mode] } { error "ERROR: This script requires common_ui to be active."}

read_mmmc genus_invs_des/genus.mmmc.tcl

read_physical -lef {/home/josee767/ee478/capstone/sobel_accelerator/build/tech-sky130-cache/sky130_fd_sc_hd__nom.tlef /home/projects/ee477.2025wtr/cad/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef}

read_netlist genus_invs_des/genus.v.gz

init_design

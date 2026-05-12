HAMMER_EXEC ?= /home/josee767/ee478/ee477-hammer-cad/hammer_run
HAMMER_DEPENDENCIES ?= /home/josee767/ee478/capstone/sobel_accelerator/build/paths.yml /home/josee767/ee478/ee477-hammer-cad/hammer_cfg_top.yml /home/josee767/ee478/capstone/sobel_accelerator/cfg/cfg.yml /home/josee767/ee478/capstone/sobel_accelerator/cfg/src.yml /home/projects/digital-vlsi-cad-files/hammer_env.yml /home/josee767/ee478/capstone/sobel_accelerator/v/image_input.v /home/josee767/ee478/capstone/sobel_accelerator/v/line_buffer.v /home/josee767/ee478/capstone/sobel_accelerator/v/sobel_gradient.v /home/josee767/ee478/capstone/sobel_accelerator/v/threshold_unit.v /home/josee767/ee478/capstone/sobel_accelerator/v/sobel_top.v /home/josee767/ee478/capstone/sobel_accelerator/v/adaptive_threshold.v /home/josee767/ee478/capstone/sobel_accelerator/v/sobel_top.v /home/josee767/ee478/capstone/sobel_accelerator/v/line_buffer.v /home/josee767/ee478/capstone/sobel_accelerator/v/sobel_gradient.v /home/josee767/ee478/capstone/sobel_accelerator/v/threshold_unit.v /home/josee767/ee478/capstone/sobel_accelerator/v/image_input.v /home/josee767/ee478/capstone/sobel_accelerator/v/adaptive_threshold.v /home/josee767/ee478/basejump_stl/bsg_misc/bsg_defines.v /home/josee767/ee478/basejump_stl/bsg_misc/bsg_counter_clock_downsample.v /home/josee767/ee478/basejump_stl/bsg_misc/bsg_strobe.v /home/josee767/ee478/basejump_stl/bsg_misc/bsg_dff.v /home/josee767/ee478/basejump_stl/bsg_misc/bsg_xnor.v /home/josee767/ee478/basejump_stl/bsg_misc/bsg_mux2_gatestack.v /home/josee767/ee478/basejump_stl/bsg_misc/bsg_muxi2_gatestack.v /home/josee767/ee478/basejump_stl/bsg_misc/bsg_nand.v /home/josee767/ee478/basejump_stl/bsg_misc/bsg_nor3.v /home/josee767/ee478/basejump_stl/bsg_misc/bsg_reduce.v /home/josee767/ee478/basejump_stl/bsg_mem/bsg_mem_1r1w_synth.v /home/josee767/ee478/basejump_stl/bsg_misc/bsg_buf.v /home/josee767/ee478/basejump_stl/bsg_mem/bsg_mem_1r1w.v /home/josee767/ee478/basejump_stl/bsg_mem/bsg_mem_1r1w_sync.v


####################################################################################
## Global steps
####################################################################################
.PHONY: pcb
pcb: /home/josee767/ee478/capstone/sobel_accelerator/build/pcb-rundir/pcb-output-full.json

/home/josee767/ee478/capstone/sobel_accelerator/build/pcb-rundir/pcb-output-full.json: $(HAMMER_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/paths.yml -p /home/josee767/ee478/ee477-hammer-cad/hammer_cfg_top.yml -p /home/josee767/ee478/capstone/sobel_accelerator/cfg/cfg.yml -p /home/josee767/ee478/capstone/sobel_accelerator/cfg/src.yml --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build pcb


####################################################################################
## Steps for sobel_top
####################################################################################
.PHONY: sim-rtl syn syn-to-sim sim-syn syn-to-par par par-to-sim sim-par sim-par-to-power par-to-power power-par par-to-drc drc par-to-lvs lvs syn-to-formal formal-syn par-to-formal formal-par syn-to-timing timing-syn par-to-timing timing-par

#sim-rtl          : /home/josee767/ee478/capstone/sobel_accelerator/build/sim-rtl-rundir/sim-output-full.json
syn              : /home/josee767/ee478/capstone/sobel_accelerator/build/syn-rundir/syn-output-full.json

syn-to-sim       : /home/josee767/ee478/capstone/sobel_accelerator/build/sim-syn-input.json
#sim-syn          : /home/josee767/ee478/capstone/sobel_accelerator/build/sim-syn-rundir/sim-output-full.json

syn-to-par       : /home/josee767/ee478/capstone/sobel_accelerator/build/par-input.json
par              : /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/par-output-full.json

par-to-sim       : /home/josee767/ee478/capstone/sobel_accelerator/build/sim-par-input.json
#sim-par          : /home/josee767/ee478/capstone/sobel_accelerator/build/sim-par-rundir/sim-output-full.json

#sim-par-to-power : /home/josee767/ee478/capstone/sobel_accelerator/build/power-sim-par-input.json
par-to-power     : /home/josee767/ee478/capstone/sobel_accelerator/build/power-par-input.json
power-par        : /home/josee767/ee478/capstone/sobel_accelerator/build/power-par-rundir/power-output-full.json

par-to-drc       : /home/josee767/ee478/capstone/sobel_accelerator/build/drc-input.json
drc              : /home/josee767/ee478/capstone/sobel_accelerator/build/drc-rundir/drc-output-full.json

par-to-lvs       : /home/josee767/ee478/capstone/sobel_accelerator/build/lvs-input.json
lvs              : /home/josee767/ee478/capstone/sobel_accelerator/build/lvs-rundir/lvs-output-full.json

syn-to-formal    : /home/josee767/ee478/capstone/sobel_accelerator/build/formal-syn-input.json
formal-syn       : /home/josee767/ee478/capstone/sobel_accelerator/build/formal-syn-rundir/formal-output-full.json

par-to-formal    : /home/josee767/ee478/capstone/sobel_accelerator/build/formal-par-input.json
formal-par       : /home/josee767/ee478/capstone/sobel_accelerator/build/formal-par-rundir/formal-output-full.json

syn-to-timing    : /home/josee767/ee478/capstone/sobel_accelerator/build/timing-syn-input.json
timing-syn       : /home/josee767/ee478/capstone/sobel_accelerator/build/timing-syn-rundir/timing-output-full.json

par-to-timing    : /home/josee767/ee478/capstone/sobel_accelerator/build/timing-par-input.json
timing-par       : /home/josee767/ee478/capstone/sobel_accelerator/build/timing-par-rundir/timing-output-full.json



/home/josee767/ee478/capstone/sobel_accelerator/build/sim-rtl-rundir/sim-output-full.json: $(HAMMER_DEPENDENCIES) $(HAMMER_SIM_RTL_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/paths.yml -p /home/josee767/ee478/ee477-hammer-cad/hammer_cfg_top.yml -p /home/josee767/ee478/capstone/sobel_accelerator/cfg/cfg.yml -p /home/josee767/ee478/capstone/sobel_accelerator/cfg/src.yml $(HAMMER_EXTRA_ARGS) --sim_rundir /home/josee767/ee478/capstone/sobel_accelerator/build/sim-rtl-rundir --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build sim

/home/josee767/ee478/capstone/sobel_accelerator/build/syn-rundir/syn-output-full.json: $(HAMMER_DEPENDENCIES) $(HAMMER_SYN_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/paths.yml -p /home/josee767/ee478/ee477-hammer-cad/hammer_cfg_top.yml -p /home/josee767/ee478/capstone/sobel_accelerator/cfg/cfg.yml -p /home/josee767/ee478/capstone/sobel_accelerator/cfg/src.yml $(HAMMER_EXTRA_ARGS) --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build syn

/home/josee767/ee478/capstone/sobel_accelerator/build/sim-syn-input.json: /home/josee767/ee478/capstone/sobel_accelerator/build/syn-rundir/syn-output-full.json
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/syn-rundir/syn-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/sim-syn-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build syn-to-sim

/home/josee767/ee478/capstone/sobel_accelerator/build/sim-syn-rundir/sim-output-full.json: /home/josee767/ee478/capstone/sobel_accelerator/build/sim-syn-input.json $(HAMMER_SIM_SYN_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/sim-syn-input.json $(SIM_EXTRA_ARGS) $(HAMMER_EXTRA_ARGS) --sim_rundir /home/josee767/ee478/capstone/sobel_accelerator/build/sim-syn-rundir --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build sim

/home/josee767/ee478/capstone/sobel_accelerator/build/par-input.json: /home/josee767/ee478/capstone/sobel_accelerator/build/syn-rundir/syn-output-full.json
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/syn-rundir/syn-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/par-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build syn-to-par

/home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/par-output-full.json: /home/josee767/ee478/capstone/sobel_accelerator/build/par-input.json $(HAMMER_PAR_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/par-input.json $(HAMMER_EXTRA_ARGS) --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build par

/home/josee767/ee478/capstone/sobel_accelerator/build/sim-par-input.json: /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/par-output-full.json
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/sim-par-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build par-to-sim

/home/josee767/ee478/capstone/sobel_accelerator/build/sim-par-rundir/sim-output-full.json: /home/josee767/ee478/capstone/sobel_accelerator/build/sim-par-input.json $(HAMMER_SIM_PAR_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/sim-par-input.json $(SIM_EXTRA_ARGS) $(HAMMER_EXTRA_ARGS) --sim_rundir /home/josee767/ee478/capstone/sobel_accelerator/build/sim-par-rundir --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build sim

/home/josee767/ee478/capstone/sobel_accelerator/build/power-sim-par-input.json: /home/josee767/ee478/capstone/sobel_accelerator/build/sim-par-rundir/sim-output-full.json
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/sim-par-rundir/sim-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/power-sim-par-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build sim-to-power

/home/josee767/ee478/capstone/sobel_accelerator/build/power-par-input.json: /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/par-output-full.json
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/power-par-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build par-to-power

/home/josee767/ee478/capstone/sobel_accelerator/build/power-par-rundir/power-output-full.json: /home/josee767/ee478/capstone/sobel_accelerator/build/power-sim-par-input.json /home/josee767/ee478/capstone/sobel_accelerator/build/power-par-input.json $(HAMMER_POWER_PAR_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/power-sim-par-input.json -p /home/josee767/ee478/capstone/sobel_accelerator/build/power-par-input.json $(HAMMER_EXTRA_ARGS) --power_rundir /home/josee767/ee478/capstone/sobel_accelerator/build/power-par-rundir --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build power

/home/josee767/ee478/capstone/sobel_accelerator/build/drc-input.json: /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/par-output-full.json
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/drc-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build par-to-drc

/home/josee767/ee478/capstone/sobel_accelerator/build/drc-rundir/drc-output-full.json: /home/josee767/ee478/capstone/sobel_accelerator/build/drc-input.json $(HAMMER_DRC_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/drc-input.json $(HAMMER_EXTRA_ARGS) --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build drc

/home/josee767/ee478/capstone/sobel_accelerator/build/lvs-input.json: /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/par-output-full.json
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/lvs-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build par-to-lvs

/home/josee767/ee478/capstone/sobel_accelerator/build/lvs-rundir/lvs-output-full.json: /home/josee767/ee478/capstone/sobel_accelerator/build/lvs-input.json $(HAMMER_LVS_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/lvs-input.json $(HAMMER_EXTRA_ARGS) --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build lvs

/home/josee767/ee478/capstone/sobel_accelerator/build/formal-syn-input.json: /home/josee767/ee478/capstone/sobel_accelerator/build/syn-rundir/syn-output-full.json
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/syn-rundir/syn-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/formal-syn-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build syn-to-formal

/home/josee767/ee478/capstone/sobel_accelerator/build/formal-syn-rundir/formal-output-full.json: /home/josee767/ee478/capstone/sobel_accelerator/build/formal-syn-input.json $(HAMMER_FORMAL_SYN_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/formal-syn-input.json $(HAMMER_EXTRA_ARGS) --formal_rundir /home/josee767/ee478/capstone/sobel_accelerator/build/formal-syn-rundir --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build formal

/home/josee767/ee478/capstone/sobel_accelerator/build/formal-par-input.json: /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/par-output-full.json
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/formal-par-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build par-to-formal

/home/josee767/ee478/capstone/sobel_accelerator/build/formal-par-rundir/formal-output-full.json: /home/josee767/ee478/capstone/sobel_accelerator/build/formal-par-input.json $(HAMMER_FORMAL_PAR_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/formal-par-input.json $(HAMMER_EXTRA_ARGS) --formal_rundir /home/josee767/ee478/capstone/sobel_accelerator/build/formal-par-rundir --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build formal

/home/josee767/ee478/capstone/sobel_accelerator/build/timing-syn-input.json: /home/josee767/ee478/capstone/sobel_accelerator/build/syn-rundir/syn-output-full.json
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/syn-rundir/syn-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/timing-syn-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build syn-to-timing

/home/josee767/ee478/capstone/sobel_accelerator/build/timing-syn-rundir/timing-output-full.json: /home/josee767/ee478/capstone/sobel_accelerator/build/timing-syn-input.json $(HAMMER_TIMING_SYN_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/timing-syn-input.json $(HAMMER_EXTRA_ARGS) --timing_rundir /home/josee767/ee478/capstone/sobel_accelerator/build/timing-syn-rundir --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build timing

/home/josee767/ee478/capstone/sobel_accelerator/build/timing-par-input.json: /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/par-output-full.json
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/timing-par-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build par-to-timing

/home/josee767/ee478/capstone/sobel_accelerator/build/timing-par-rundir/timing-output-full.json: /home/josee767/ee478/capstone/sobel_accelerator/build/timing-par-input.json $(HAMMER_TIMING_PAR_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/timing-par-input.json $(HAMMER_EXTRA_ARGS) --timing_rundir /home/josee767/ee478/capstone/sobel_accelerator/build/timing-par-rundir --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build timing

# Redo steps
# These intentionally break the dependency graph, but allow the flexibility to rerun a step after changing a config.
# Hammer doesn't know what settings impact synthesis only, e.g., so these are for power-users who "know better."
# The HAMMER_EXTRA_ARGS variable allows patching in of new configurations with -p or using --to_step or --from_step, for example.
.PHONY: redo-sim-rtl redo-syn redo-syn-to-sim redo-sim-syn redo-syn-to-par redo-par redo-par-to-sim redo-sim-par redo-sim-par-to-power redo-par-to-power redo-power-par redo-par-to-drc redo-drc redo-par-to-lvs redo-lvs redo-syn-to-formal redo-formal-syn redo-par-to-formal redo-formal-par redo-syn-to-timing redo-timing-syn redo-par-to-timing redo-timing-par

#redo-sim-rtl:
#	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/paths.yml -p /home/josee767/ee478/ee477-hammer-cad/hammer_cfg_top.yml -p /home/josee767/ee478/capstone/sobel_accelerator/cfg/cfg.yml -p /home/josee767/ee478/capstone/sobel_accelerator/cfg/src.yml $(HAMMER_EXTRA_ARGS) --sim_rundir /home/josee767/ee478/capstone/sobel_accelerator/build/sim-rtl-rundir --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build sim

redo-syn:
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/paths.yml -p /home/josee767/ee478/ee477-hammer-cad/hammer_cfg_top.yml -p /home/josee767/ee478/capstone/sobel_accelerator/cfg/cfg.yml -p /home/josee767/ee478/capstone/sobel_accelerator/cfg/src.yml $(HAMMER_EXTRA_ARGS) --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build syn

redo-syn-to-sim:
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/syn-rundir/syn-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/sim-syn-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build syn-to-sim

#redo-sim-syn:
#	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/sim-syn-input.json $(SIM_EXTRA_ARGS) $(HAMMER_EXTRA_ARGS) --sim_rundir /home/josee767/ee478/capstone/sobel_accelerator/build/sim-syn-rundir --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build sim

redo-syn-to-par:
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/syn-rundir/syn-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/par-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build syn-to-par

redo-par:
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/par-input.json $(HAMMER_EXTRA_ARGS) --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build par

redo-par-to-sim:
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/sim-par-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build par-to-sim

#redo-sim-par:
#	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/sim-par-input.json $(SIM_EXTRA_ARGS) $(HAMMER_EXTRA_ARGS) --sim_rundir /home/josee767/ee478/capstone/sobel_accelerator/build/sim-par-rundir --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build sim

#redo-sim-par-to-power:
#	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/sim-par-rundir/sim-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/power-sim-par-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build sim-to-power

redo-par-to-power:
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/power-par-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build par-to-power

redo-power-par:
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/power-sim-par-input.json -p /home/josee767/ee478/capstone/sobel_accelerator/build/power-par-input.json $(HAMMER_EXTRA_ARGS) --power_rundir /home/josee767/ee478/capstone/sobel_accelerator/build/power-par-rundir --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build power

redo-par-to-drc:
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/drc-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build par-to-drc

redo-drc:
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/drc-input.json $(HAMMER_EXTRA_ARGS) --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build drc

redo-par-to-lvs:
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/lvs-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build par-to-lvs

redo-lvs:
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/lvs-input.json $(HAMMER_EXTRA_ARGS) --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build lvs

redo-syn-to-formal:
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/syn-rundir/syn-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/formal-syn-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build syn-to-formal

redo-formal-syn:
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/formal-syn-input.json $(HAMMER_EXTRA_ARGS) --formal_rundir /home/josee767/ee478/capstone/sobel_accelerator/build/formal-syn-rundir --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build formal

redo-par-to-formal:
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/formal-par-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build par-to-formal

redo-formal-par:
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/formal-par-input.json $(HAMMER_EXTRA_ARGS) --formal_rundir /home/josee767/ee478/capstone/sobel_accelerator/build/formal-par-rundir --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build formal

redo-syn-to-timing:
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/syn-rundir/syn-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/timing-syn-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build syn-to-timing

redo-timing-syn:
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/timing-syn-input.json $(HAMMER_EXTRA_ARGS) --timing_rundir /home/josee767/ee478/capstone/sobel_accelerator/build/timing-syn-rundir --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build timing

redo-par-to-timing:
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/josee767/ee478/capstone/sobel_accelerator/build/timing-par-input.json --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build par-to-timing

redo-timing-par:
	$(HAMMER_EXEC) -e /home/projects/digital-vlsi-cad-files/hammer_env.yml -p /home/josee767/ee478/capstone/sobel_accelerator/build/timing-par-input.json $(HAMMER_EXTRA_ARGS) --timing_rundir /home/josee767/ee478/capstone/sobel_accelerator/build/timing-par-rundir --obj_dir /home/josee767/ee478/capstone/sobel_accelerator/build timing


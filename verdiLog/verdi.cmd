simSetSimulator "-vcssv" -exec \
           "/home/josee767/ee478/capstone/sobel_accelerator/build/sim-rtl-rundir/simv" \
           -args
debImport "-full64" "-dbdir" \
          "/home/josee767/ee478/capstone/sobel_accelerator/build/sim-rtl-rundir/simv.daidir"
debLoadSimResult \
           /home/josee767/ee478/capstone/sobel_accelerator/build/sim-rtl-rundir/waveform.fsdb
wvCreateWindow
srcDeselectAll -win $_nTrace1
srcHBSelect "sobel_tb.dut" -win $_nTrace1
srcHBSelect "sobel_tb.dut.sg" -win $_nTrace1
srcHBSelect "sobel_tb.dut.sg" -win $_nTrace1
srcHBSelect "sobel_tb.dut.sg" -win $_nTrace1
srcSetScope -win $_nTrace1 "sobel_tb.dut.sg" -delim "."
srcHBSelect "sobel_tb.dut.sg" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "p1" -line 4 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "p2" -line 4 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "p1" -line 4 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "p2" -line 4 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcSelect -signal "p3" -line 4 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcSelect -signal "p4" -line 5 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcSelect -signal "p5" -line 5 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "p6" -line 5 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "p7" -line 6 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "p8" -line 6 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "p9" -line 6 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
debExit

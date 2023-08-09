elab1: 
	vcs -full64 -debug_acc+all -sverilog -l comp.log \
	-f ../rtl/files_rtl.f \
	-f ../tb/files_tb1.f \
	-timescale=1ns/1ps

elab2: 
	vcs -full64 -debug_acc+all -sverilog -l comp.log \
	-f ../rtl/files_rtl.f \
	-f ../tb/files_tb2.f \
	-timescale=1ns/1ps

elab3: 
	vcs -full64 -debug_acc+all -sverilog -l comp.log \
	-f ../rtl/files_rtl.f \
	-f ../tb/files_tb3.f \
	-timescale=1ns/1ps

elab4: 
	vcs -full64 -debug_acc+all -sverilog -l comp.log \
	-f ../rtl/files_rtl.f \
	-f ../tb/files_tb4.f \
	-timescale=1ns/1ps

run: 
	./simv -ucli -i run.tcl -l run.log  

verdi:
	verdi -f ../rtl/files_rtl.f -f ../tb/files_tb.f -ssf ./wave.fsdb &


clean:
	rm -rf AN.DB DVEfiles csrc simv.* *simv inter.vpd ucli.key *.log novas* *fsdb verdiLog

test1:elab1 run
test2:elab2 run
test3:elab3 run
test4:elab4 run

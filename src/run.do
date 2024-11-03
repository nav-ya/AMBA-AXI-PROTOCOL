vlog -sv run.sv +incdir+C:/questasim64_10.6c/verilog_src/uvm-1.1d/src
vsim axi_top -sv_lib C:/questasim64_10.6c/uvm-1.1d/win64/uvm_dpi
add wave -position insertpoint sim:/axi_top/intf/*





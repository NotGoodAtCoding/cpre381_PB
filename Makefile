all: singlecycle 


singlecycle: ./P3/singleCycle.vhd depends controlmodule branchcontrol alucontrol
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/P3/singleCycle.vhd

controlmodule: ./P1/controlModule.vhd  
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/P1/controlModule.vhd

alucontrol: ./P3/alu_control.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/P3/alu_control.vhd

branchcontrol: ./P3/branch_control.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/P3/branch_control.vhd

depends: ./dependencies/*
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/alu_32.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/add_sub.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/alu_one_bit.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/and2.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/array32_bit.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/arrays.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/barrel_shifter.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/dff.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/dmem.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/extender_16_32_signed.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/extender16to32u.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/extender16to32.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/extender8to32u.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/extender8to32.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/extenderModule.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/fullAdder.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/inv.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/memInputController.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/memOutputController.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/mem.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/mult32.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/mux2.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/mux_32_1.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/mux_n.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/nand2.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/n_bit_adder.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/nbit_dff.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/nor2.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/or2.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/reg_file_decoder.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/register_file.vhd
	vcom -reportprogress 300 -work work /home/rascheel/rascheel/cpre381/gitProject/381lab/B/src/dependencies/xor2.vhd
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

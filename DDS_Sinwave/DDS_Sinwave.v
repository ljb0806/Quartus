module DDS_Sinwave
(
	input clk,
	input rst_n,
	input [31:0] frequency,
	
	output [11:0] sinwave
);

wire clk_200M;
wire [31:0] phase;

PLL_200M	PLL_200M_inst (
	.inclk0 ( clk ),
	.c0 ( clk_200M )
);

SINROM	SINROM_inst (
	.address ( phase[31:20] ),
	.clock ( clk_200M ),
	.q ( sinwave )
);

get_phase get_phase_inst
(
	.frequency(frequency) ,	// input [31:0] frequency_sig
	.clk_200M(clk_200M) ,	// input  clk_200M_sig
	.rst_n(rst_n) ,	// input  rst_n_sig
	.phase(phase) 	// output [31:0] phase_sig
);

endmodule
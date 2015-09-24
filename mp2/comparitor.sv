import lc3b_types::*;

module comparator #(parameter width = 128)
(
	input [width-1:0] a, b, 
	output logic [width-1:0] out
);

// internal signals

// Logic

always_comb
	begin: 
